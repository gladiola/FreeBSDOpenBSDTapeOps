#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage:
  computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>
  computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]

Sends unsent .tar.gz archives from Computer B to Computer C servers via scp.
Set PREFERRED_SERVER to force selection of one server from the provided server list.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 3 ]; then
  usage >&2
  exit 1
fi

ARCHIVE_DIR=$1
RETENTION_HOURS=${RETENTION_HOURS:-72}
BUSY_RETRY_SECONDS=${BUSY_RETRY_SECONDS:-60}
BUSY_MAX_RETRIES=${BUSY_MAX_RETRIES:-10}
REMOTE_BUSY_MARKER=${REMOTE_BUSY_MARKER:-.busy}
PREFERRED_SERVER=${PREFERRED_SERVER:-}

if [ "$#" -eq 3 ]; then
  REMOTE_DIR=$3
  set -- "$2"
else
  REMOTE_DIR=$2
  shift 2
fi

SERVERS=$*

if [ -z "$SERVERS" ]; then
  printf 'No servers provided\n' >&2
  exit 2
fi

if [ ! -d "$ARCHIVE_DIR" ]; then
  printf 'Archive directory not found: %s\n' "$ARCHIVE_DIR" >&2
  exit 2
fi

quote_for_remote_sh() {
  printf "%s" "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

REMOTE_DIR_QUOTED=$(quote_for_remote_sh "$REMOTE_DIR")
BUSY_MARKER_PATH=$REMOTE_DIR/$REMOTE_BUSY_MARKER
BUSY_MARKER_QUOTED=$(quote_for_remote_sh "$BUSY_MARKER_PATH")

selected_servers() {
  if [ -n "$PREFERRED_SERVER" ]; then
    for server in $SERVERS; do
      if [ "$server" = "$PREFERRED_SERVER" ]; then
        printf '%s\n' "$server"
        return 0
      fi
    done
    printf 'Preferred server not in provided server list: %s\n' "$PREFERRED_SERVER" >&2
    return 1
  fi

  for server in $SERVERS; do
    printf '%s\n' "$server"
  done
}

ensure_remote_dir() {
  remote=$1
  ssh "$remote" "mkdir -p -- $REMOTE_DIR_QUOTED"
}

remote_is_busy() {
  remote=$1
  if ssh "$remote" "test -e -- $BUSY_MARKER_QUOTED"; then
    return 0
  fi
  return 1
}

wait_until_ready() {
  remote=$1
  retries=0

  while remote_is_busy "$remote"; do
    retries=$((retries + 1))
    if [ "$retries" -gt "$BUSY_MAX_RETRIES" ]; then
      printf 'Server %s remained busy too long (marker %s)\n' "$remote" "$BUSY_MARKER_PATH" >&2
      return 1
    fi

    printf 'Server %s is busy; retrying in %s seconds (%s/%s)\n' \
      "$remote" "$BUSY_RETRY_SECONDS" "$retries" "$BUSY_MAX_RETRIES"
    sleep "$BUSY_RETRY_SECONDS"
  done

  return 0
}

found=0
for archive in "$ARCHIVE_DIR"/*.tar.gz; do
  [ -e "$archive" ] || continue
  found=1

  marker="$archive.sent"
  if [ -f "$marker" ]; then
    continue
  fi

  sent=0
  for remote in $(selected_servers); do
    if ! ensure_remote_dir "$remote"; then
      printf 'Could not prepare remote directory on %s\n' "$remote" >&2
      continue
    fi

    if ! wait_until_ready "$remote"; then
      continue
    fi

    if scp "$archive" "$remote:$REMOTE_DIR_QUOTED"; then
      touch "$marker"
      printf 'Sent %s via %s\n' "$archive" "$remote"
      sent=1
      break
    fi

    printf 'Failed to send %s via %s\n' "$archive" "$remote" >&2
  done

  if [ "$sent" -ne 1 ]; then
    printf 'Failed to send %s to all candidate servers\n' "$archive" >&2
    exit 3
  fi
done

if [ "$found" -eq 0 ]; then
  printf 'No archives found in %s\n' "$ARCHIVE_DIR"
fi

find "$ARCHIVE_DIR" -type f \( -name '*.tar.gz' -o -name '*.tar.gz.sent' \) \
  -mmin +$((RETENTION_HOURS * 60)) -delete
