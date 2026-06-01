#!/bin/sh
set -eu

SCRIPT_NAME=$(basename "$0")

log_info() {
  msg=$1
  printf '%s\n' "$msg"
  if command -v logger >/dev/null 2>&1; then
    logger -t "$SCRIPT_NAME" -p user.notice "$msg" || true
  fi
}

log_error() {
  msg=$1
  printf '%s\n' "$msg" >&2
  if command -v logger >/dev/null 2>&1; then
    logger -t "$SCRIPT_NAME" -p user.err "$msg" || true
  fi
}

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
  log_error 'No servers provided'
  exit 2
fi

if [ ! -d "$ARCHIVE_DIR" ]; then
  log_error "$(printf 'Archive directory not found: %s' "$ARCHIVE_DIR")"
  exit 2
fi

quote_for_remote_sh() {
  # Escape single quotes as '\'' and wrap the whole string in single quotes
  # so it can be safely embedded in remote shell commands.
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
    log_error "$(printf 'Preferred server not in provided server list: %s' "$PREFERRED_SERVER")"
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
      log_error "$(printf 'Server %s remained busy too long (marker %s)' "$remote" "$BUSY_MARKER_PATH")"
      return 1
    fi

    log_info "$(printf 'Server %s is busy; retrying in %s seconds (%s/%s)' \
      "$remote" "$BUSY_RETRY_SECONDS" "$retries" "$BUSY_MAX_RETRIES")"
    sleep "$BUSY_RETRY_SECONDS"
  done

  return 0
}

found=0
for archive in "$ARCHIVE_DIR"/*.tar.gz "$ARCHIVE_DIR"/*.tar.gz.enc; do
  [ -e "$archive" ] || continue
  found=1

  marker="$archive.sent"
  if [ -f "$marker" ]; then
    continue
  fi

  sent=0
  for remote in $(selected_servers); do
    if ! ensure_remote_dir "$remote"; then
      log_error "$(printf 'Could not prepare remote directory on %s' "$remote")"
      continue
    fi

    if ! wait_until_ready "$remote"; then
      continue
    fi

    if scp "$archive" "$remote:$REMOTE_DIR_QUOTED"; then
      touch "$marker"
      log_info "$(printf 'Sent %s via %s' "$archive" "$remote")"
      sent=1
      break
    fi

    log_error "$(printf 'Failed to send %s via %s' "$archive" "$remote")"
  done

  if [ "$sent" -ne 1 ]; then
    log_error "$(printf 'Failed to send %s to all candidate servers' "$archive")"
    exit 3
  fi
done

if [ "$found" -eq 0 ]; then
  log_info "$(printf 'No archives found in %s' "$ARCHIVE_DIR")"
fi

find "$ARCHIVE_DIR" -type f \( -name '*.tar.gz.taped' -o -name '*.tar.gz.enc.taped' \) -mmin +$((RETENTION_HOURS * 60)) | while IFS= read -r taped_marker; do
  archive=${taped_marker%.taped}
  sent_marker="$archive.sent"

  # Keep data unless local send and tape confirmations both exist.
  [ -f "$sent_marker" ] || continue
  rm -f "$archive" "$sent_marker" "$taped_marker"
  log_info "$(printf 'Removed retained archive and markers: %s' "$archive")"
done
