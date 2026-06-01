#!/bin/sh
set -eu

SCRIPT_NAME=$(basename "$0")
REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

log_info() {
  msg=$1
  printf '%s\n' "$msg"
}

log_error() {
  msg=$1
  printf '%s\n' "$msg" >&2
}

usage() {
  cat <<'USAGE'
Usage: test-computer-a-b-c-integration.sh [work_dir]

Runs a deterministic end-to-end integration test of the A->B->C pipeline:
  A log creation -> B rotate/archive -> C receive/write-to-tape -> tape restore.

Environment:
  TEST_DAY_STAMP=YYYYMMDD   Fixed day used for deterministic archive checks (default 20260101)
  KEEP_TEST_DIR=1           Keep working directory after success/failure
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

WORK_DIR=${1:-}
TEST_DAY_STAMP=${TEST_DAY_STAMP:-20260101}
KEEP_TEST_DIR=${KEEP_TEST_DIR:-0}

case "$TEST_DAY_STAMP" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]) ;;
  *)
    log_error "$(printf 'Invalid TEST_DAY_STAMP: %s' "$TEST_DAY_STAMP")"
    exit 2
    ;;
esac

if [ -z "$WORK_DIR" ]; then
  WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/abc-integration.XXXXXX")
else
  mkdir -p "$WORK_DIR"
fi

cleanup() {
  if [ "$KEEP_TEST_DIR" != "1" ]; then
    rm -rf "$WORK_DIR"
  fi
}
trap 'cleanup' EXIT INT TERM HUP

A_DIR="$WORK_DIR/computer-a"
B_DIR="$WORK_DIR/computer-b"
C_DIR="$WORK_DIR/computer-c"
mkdir -p "$A_DIR" "$B_DIR/hourly" "$B_DIR/archives" "$C_DIR/incoming" "$C_DIR/received" "$C_DIR/recovered"

A_INPUT_LOG="$A_DIR/rsyslog.log"
TAPE_FILE="$C_DIR/tape.bin"
RESTORED_ARCHIVE="$C_DIR/recovered/restored.tar.gz"
DAY_HUMAN=$(printf '%s' "$TEST_DAY_STAMP" | sed 's/^\(....\)\(..\)\(..\)$/\1-\2-\3/')

cat > "$A_INPUT_LOG" <<'EOF'
<134>1 2026-01-01T00:00:00Z computer-a app - - - integration-start
<134>1 2026-01-01T00:00:01Z computer-a app - - - integration-data
EOF

"$REPO_ROOT/scripts/computer-b-hourly-rotate.sh" "$A_INPUT_LOG" "$B_DIR/hourly" 720
if [ -s "$A_INPUT_LOG" ]; then
  log_error 'computer-b-hourly-rotate.sh did not truncate the input log'
  exit 3
fi

cat > "$B_DIR/hourly/rsyslog-${DAY_HUMAN}T0000.log" <<'EOF'
deterministic-entry-00
EOF
cat > "$B_DIR/hourly/rsyslog-${DAY_HUMAN}T2300.log" <<'EOF'
deterministic-entry-23
EOF

"$REPO_ROOT/scripts/computer-b-daily-archive.sh" "$B_DIR/hourly" "$B_DIR/archives" "$TEST_DAY_STAMP"

found_archive=0
ARCHIVE_TO_SEND=
for archive in "$B_DIR/archives"/*.tar.gz "$B_DIR/archives"/*.tar.gz.enc; do
  [ -e "$archive" ] || continue
  ARCHIVE_TO_SEND=$archive
  found_archive=1
  break
done

if [ "$found_archive" -ne 1 ]; then
  log_error 'No daily archive was created by computer-b-daily-archive.sh'
  exit 4
fi

cp "$ARCHIVE_TO_SEND" "$C_DIR/incoming/$(basename "$ARCHIVE_TO_SEND")"
"$REPO_ROOT/scripts/computer-c-receive-archives.sh" "$C_DIR/incoming" "$C_DIR/received"
"$REPO_ROOT/scripts/computer-c-write-to-tape.sh" "$C_DIR/received" "$TAPE_FILE"

if [ ! -s "$TAPE_FILE" ]; then
  log_error 'computer-c-write-to-tape.sh did not write data to simulated tape file'
  exit 5
fi

target_name=$(basename "$ARCHIVE_TO_SEND")
"$REPO_ROOT/scripts/computer-c-restore-archive-from-tape.sh" "$TAPE_FILE" "$target_name" "$RESTORED_ARCHIVE"

if ! tar -tzf "$RESTORED_ARCHIVE" >/dev/null 2>&1; then
  log_error 'Recovered archive is not a valid tar.gz payload'
  exit 6
fi

if ! tar -tzf "$RESTORED_ARCHIVE" | grep -q "^rsyslog-${DAY_HUMAN}T0000.log\$"; then
  log_error 'Recovered archive content does not include expected deterministic member'
  exit 7
fi

log_info "$(printf 'Integration test succeeded. Working directory: %s' "$WORK_DIR")"

