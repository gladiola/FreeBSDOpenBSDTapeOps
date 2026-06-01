#!/bin/sh
set -eu

usage() {
  cat <<'USAGE'
Usage: computer-b-daily-archive.sh <hourly_log_dir> <archive_dir> <day_stamp>

Builds one 24-hour tar.gz archive for the specified day (YYYYMMDD).
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

HOURLY_DIR=$1
ARCHIVE_DIR=$2
DAY_STAMP=$3

case "$DAY_STAMP" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) ;;
  *)
    printf 'Invalid day stamp (expected YYYYMMDD): %s\n' "$DAY_STAMP" >&2
    exit 2
    ;;
esac

mkdir -p "$ARCHIVE_DIR"

set --
for hour_pattern in 0[0-9] 1[0-9] 2[0-3]; do
  for candidate in "$HOURLY_DIR"/rsyslog-"$DAY_STAMP"$hour_pattern.log; do
    [ -e "$candidate" ] || continue
    set -- "$@" "$(basename "$candidate")"
  done
done

if [ "$#" -eq 0 ]; then
  printf 'No hourly logs found for day %s in %s\n' "$DAY_STAMP" "$HOURLY_DIR" >&2
  exit 3
fi

ARCHIVE_FILE="$ARCHIVE_DIR/rsyslog-$DAY_STAMP.tar.gz"

tar -C "$HOURLY_DIR" -czf "$ARCHIVE_FILE" "$@"

printf 'Created daily archive %s\n' "$ARCHIVE_FILE"
