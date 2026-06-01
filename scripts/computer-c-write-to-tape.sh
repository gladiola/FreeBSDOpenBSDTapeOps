#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: computer-c-write-to-tape.sh <received_dir> <tape_device>

Writes queued archives to tape and marks each one as recorded.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -ne 2 ]; then
  usage >&2
  exit 1
fi

RECEIVED_DIR=$1
TAPE_DEVICE=$2
TAPE_BLOCK_SIZE=${TAPE_BLOCK_SIZE:-64k}
RETENTION_HOURS=${RETENTION_HOURS:-72}
TAPE_SAFETY_MARGIN_BYTES=${TAPE_SAFETY_MARGIN_BYTES:-10485760}
TAPE_AVAILABLE_BYTES=${TAPE_AVAILABLE_BYTES:-}
BUSY_MARKER=${BUSY_MARKER:-$RECEIVED_DIR/.busy}
ALLOW_UNKNOWN_TAPE_SPACE=${ALLOW_UNKNOWN_TAPE_SPACE:-0}

if [ ! -d "$RECEIVED_DIR" ]; then
  printf 'Received directory not found: %s\n' "$RECEIVED_DIR" >&2
  exit 2
fi

parse_bytes() {
  value=$1
  awk -v raw="$value" 'BEGIN {
    s=raw
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
    if (s !~ /^[0-9]+([.][0-9]+)?([KkMmGgTtPp][Bb]?|[Bb])?$/) exit 1
    unit=""
    num=s
    if (s ~ /[A-Za-z]+$/) {
      match(s, /[A-Za-z]+$/)
      unit=substr(s, RSTART, RLENGTH)
      num=substr(s, 1, RSTART - 1)
    }
    mult=1
    if (unit ~ /^[Bb]$/ || unit == "") mult=1
    else if (unit ~ /^[Kk][Bb]?$/) mult=1024
    else if (unit ~ /^[Mm][Bb]?$/) mult=1024*1024
    else if (unit ~ /^[Gg][Bb]?$/) mult=1024*1024*1024
    else if (unit ~ /^[Tt][Bb]?$/) mult=1024*1024*1024*1024
    else if (unit ~ /^[Pp][Bb]?$/) mult=1024*1024*1024*1024*1024
    else exit 1
    printf "%.0f\n", num * mult
  }'
}

space_available_bytes() {
  target=$1

  if [ -n "$TAPE_AVAILABLE_BYTES" ]; then
    parse_bytes "$TAPE_AVAILABLE_BYTES"
    return 0
  fi

  if [ -c "$target" ]; then
    status=$(mt -f "$target" status 2>/dev/null || true)
    remaining=$(printf '%s\n' "$status" | awk '
      BEGIN { IGNORECASE=1 }
      /remaining|avail|available/ {
        line=$0
        if (match(line, /[0-9]+([.][0-9]+)?[[:space:]]*([KMGTP]?B|bytes?)/)) {
          token=substr(line, RSTART, RLENGTH)
          gsub(/[[:space:]]+/, "", token)
          print token
          exit
        }
      }
    ')

    if [ -n "$remaining" ]; then
      parse_bytes "$remaining"
      return 0
    fi

    if [ "$ALLOW_UNKNOWN_TAPE_SPACE" = "1" ]; then
      # Max signed 64-bit value used as an effectively-unbounded fallback.
      printf '9223372036854775807\n'
      return 0
    fi

    return 1
  fi

  dir=$(dirname "$target")
  df -Pk "$dir" | awk 'NR==2 { print $4 * 1024 }'
}

ensure_can_write_archive() {
  archive=$1
  archive_size=$(wc -c < "$archive" | tr -d ' ')

  if ! available=$(space_available_bytes "$TAPE_DEVICE"); then
    printf 'Could not determine available tape space for %s\n' "$TAPE_DEVICE" >&2
    return 1
  fi

  required=$((archive_size + TAPE_SAFETY_MARGIN_BYTES))
  if [ "$available" -lt "$required" ]; then
    printf 'Insufficient tape space for %s: need %s bytes incl. margin, have %s\n' \
      "$archive" "$required" "$available" >&2
    return 1
  fi

  return 0
}

set_busy() {
  : > "$BUSY_MARKER"
}

clear_busy() {
  rm -f "$BUSY_MARKER"
}

trap 'clear_busy' EXIT INT TERM HUP

seek_end_of_data() {
  if mt -f "$TAPE_DEVICE" eom >/dev/null 2>&1; then
    return 0
  fi
  if mt -f "$TAPE_DEVICE" eod >/dev/null 2>&1; then
    return 0
  fi
  printf 'Failed to seek end-of-data on tape %s\n' "$TAPE_DEVICE" >&2
  return 1
}

found=0
for ready in "$RECEIVED_DIR"/*.tar.gz.ready; do
  [ -e "$ready" ] || continue
  found=1

  archive=${ready%.ready}
  done_marker="$archive.taped"
  [ -f "$done_marker" ] && continue

  if [ ! -s "$archive" ]; then
    printf 'Skipping empty archive %s\n' "$archive" >&2
    continue
  fi

  if ! ensure_can_write_archive "$archive"; then
    exit 6
  fi

  set_busy
  printf 'Writing %s to tape %s\n' "$archive" "$TAPE_DEVICE"
  if [ -c "$TAPE_DEVICE" ]; then
    if ! seek_end_of_data; then
      exit 5
    fi

    if dd if="$archive" of="$TAPE_DEVICE" bs="$TAPE_BLOCK_SIZE" conv=sync; then
      if ! mt -f "$TAPE_DEVICE" weof 1; then
        printf 'Failed writing EOF marker to tape %s\n' "$TAPE_DEVICE" >&2
        exit 5
      fi
    else
      printf 'Failed writing %s to tape %s\n' "$archive" "$TAPE_DEVICE" >&2
      exit 3
    fi
  else
    if ! cat "$archive" >> "$TAPE_DEVICE"; then
      printf 'Failed appending %s to %s\n' "$archive" "$TAPE_DEVICE" >&2
      exit 4
    fi
  fi

  touch "$done_marker"
  rm -f "$ready"
  clear_busy
done

if [ "$found" -eq 0 ]; then
  printf 'No queued archives in %s\n' "$RECEIVED_DIR"
fi

find "$RECEIVED_DIR" -type f -name '*.tar.gz.taped' -mmin +$((RETENTION_HOURS * 60)) | while IFS= read -r taped_marker; do
  # Uses .taped marker mtime as the age proxy for retention.
  archive=${taped_marker%.taped}
  rm -f "$archive" "$taped_marker"
done
