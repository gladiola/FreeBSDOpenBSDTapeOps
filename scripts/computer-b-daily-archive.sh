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

DAY_HUMAN=$(printf '%s' "$DAY_STAMP" | sed 's/^\(....\)\(..\)\(..\)$/\1-\2-\3/')

mkdir -p "$ARCHIVE_DIR"

hour_token_from_file() {
  base=$1
  case "$base" in
    # Legacy hourly format: rsyslog-YYYYMMDDHH.log (10 digits after prefix)
    rsyslog-[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].log)
      y=$(printf '%s' "$base" | sed -n 's/^rsyslog-\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\.log$/\1/p')
      m=$(printf '%s' "$base" | sed -n 's/^rsyslog-\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\.log$/\2/p')
      d=$(printf '%s' "$base" | sed -n 's/^rsyslog-\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\.log$/\3/p')
      h=$(printf '%s' "$base" | sed -n 's/^rsyslog-\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\.log$/\4/p')
      printf '%s-%s-%sT%s00\n' "$y" "$m" "$d" "$h"
      ;;
    # Current hourly format: rsyslog-YYYY-MM-DDTHH00.log
    rsyslog-[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]00.log)
      printf '%s\n' "${base#rsyslog-}" | sed 's/\.log$//'
      ;;
    *)
      return 1
      ;;
  esac
}

set --
FIRST_HOUR=
LAST_HOUR=
for hour_pattern in 0[0-9] 1[0-9] 2[0-3]; do
  for candidate in \
    "$HOURLY_DIR"/rsyslog-"$DAY_STAMP"$hour_pattern.log \
    "$HOURLY_DIR"/rsyslog-"$DAY_HUMAN"T$hour_pattern"00.log"
  do
    [ -e "$candidate" ] || continue
    base=$(basename "$candidate")
    set -- "$@" "$base"

    token=$(hour_token_from_file "$base") || continue
    if [ -z "$FIRST_HOUR" ]; then
      FIRST_HOUR=$token
    fi
    LAST_HOUR=$token
  done
done

if [ "$#" -eq 0 ]; then
  printf 'No hourly logs found for day %s in %s\n' "$DAY_STAMP" "$HOURLY_DIR" >&2
  exit 3
fi

if [ -z "$FIRST_HOUR" ] || [ -z "$LAST_HOUR" ]; then
  printf 'Could not determine first/last hour for archive naming on day %s\n' "$DAY_STAMP" >&2
  exit 4
fi

ARCHIVE_FILE="$ARCHIVE_DIR/rsyslog-${FIRST_HOUR}_to_${LAST_HOUR}.tar.gz"

tar -C "$HOURLY_DIR" -czf "$ARCHIVE_FILE" "$@"

printf 'Created daily archive %s\n' "$ARCHIVE_FILE"
