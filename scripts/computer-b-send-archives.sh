#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>

Sends unsent .tar.gz archives from Computer B to Computer C via scp.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -ne 3 ]; then
  usage >&2
  exit 1
fi

ARCHIVE_DIR=$1
REMOTE=$2
REMOTE_DIR=$3

if [ ! -d "$ARCHIVE_DIR" ]; then
  printf 'Archive directory not found: %s\n' "$ARCHIVE_DIR" >&2
  exit 2
fi

ssh "$REMOTE" "mkdir -p '$REMOTE_DIR'"

found=0
for archive in "$ARCHIVE_DIR"/*.tar.gz; do
  [ -e "$archive" ] || continue
  found=1
  marker="$archive.sent"

  if [ -f "$marker" ]; then
    continue
  fi

  scp "$archive" "$REMOTE:$REMOTE_DIR/"
  touch "$marker"
  printf 'Sent %s\n' "$archive"
done

if [ "$found" -eq 0 ]; then
  printf 'No archives found in %s\n' "$ARCHIVE_DIR"
fi
