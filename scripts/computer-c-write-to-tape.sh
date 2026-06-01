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

if [ ! -d "$RECEIVED_DIR" ]; then
  printf 'Received directory not found: %s\n' "$RECEIVED_DIR" >&2
  exit 2
fi

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

  printf 'Writing %s to tape %s\n' "$archive" "$TAPE_DEVICE"
  if [ -c "$TAPE_DEVICE" ]; then
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
done

if [ "$found" -eq 0 ]; then
  printf 'No queued archives in %s\n' "$RECEIVED_DIR"
fi
