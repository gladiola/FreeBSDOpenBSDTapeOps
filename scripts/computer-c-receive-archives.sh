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
Usage: computer-c-receive-archives.sh <incoming_dir> <received_dir>

Validates newly received .tar.gz files and moves them into the tape queue.
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

INCOMING_DIR=$1
RECEIVED_DIR=$2

mkdir -p "$INCOMING_DIR" "$RECEIVED_DIR"

found=0
for archive in "$INCOMING_DIR"/*.tar.gz "$INCOMING_DIR"/*.tar.gz.enc; do
  [ -e "$archive" ] || continue
  found=1

  case "$archive" in
    *.tar.gz)
      if ! tar -tzf "$archive" >/dev/null 2>&1; then
        log_error "$(printf 'Invalid archive (left in incoming): %s' "$archive")"
        continue
      fi
      ;;
    *.tar.gz.enc)
      if [ ! -s "$archive" ]; then
        log_error "$(printf 'Invalid encrypted archive (left in incoming): %s' "$archive")"
        continue
      fi
      ;;
  esac

  base=$(basename "$archive")
  target="$RECEIVED_DIR/$base"
  mv "$archive" "$target"
  : > "$target.ready"
  if [ "${archive##*.}" = "enc" ]; then
    log_info "$(printf 'Queued encrypted archive %s for tape' "$target")"
  else
    log_info "$(printf 'Queued %s for tape' "$target")"
  fi
done

if [ "$found" -eq 0 ]; then
  log_info "$(printf 'No new archives in %s' "$INCOMING_DIR")"
fi
