#!/bin/sh
set -eu

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
RETENTION_HOURS=${RETENTION_HOURS:-72}

mkdir -p "$INCOMING_DIR" "$RECEIVED_DIR"

found=0
for archive in "$INCOMING_DIR"/*.tar.gz; do
  [ -e "$archive" ] || continue
  found=1

  if ! tar -tzf "$archive" >/dev/null 2>&1; then
    printf 'Invalid archive (left in incoming): %s\n' "$archive" >&2
    continue
  fi

  base=$(basename "$archive")
  target="$RECEIVED_DIR/$base"
  mv "$archive" "$target"
  : > "$target.ready"
  printf 'Queued %s for tape\n' "$target"
done

if [ "$found" -eq 0 ]; then
  printf 'No new archives in %s\n' "$INCOMING_DIR"
fi

find "$RECEIVED_DIR" -type f -name '*.tar.gz.taped' -mmin +$((RETENTION_HOURS * 60)) | while IFS= read -r taped_marker; do
  archive=${taped_marker%.taped}
  rm -f "$archive" "$taped_marker"
done
