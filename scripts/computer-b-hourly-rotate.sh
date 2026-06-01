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
Usage: computer-b-hourly-rotate.sh <rsyslog_input_file> <hourly_output_dir> [keep_hours]

Copies the current rsyslog input log into an hourly file and truncates the input file.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  usage >&2
  exit 1
fi

INPUT_LOG=$1
OUTPUT_DIR=$2
KEEP_HOURS=${3:-72}

if [ ! -f "$INPUT_LOG" ]; then
  log_error "$(printf 'Input log not found: %s' "$INPUT_LOG")"
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

STAMP=$(date +%Y-%m-%dT%H00)
OUT_FILE="$OUTPUT_DIR/rsyslog-$STAMP.log"

if command -v rcctl >/dev/null 2>&1; then
  rcctl stop rsyslogd
  cp "$INPUT_LOG" "$OUT_FILE"
  : > "$INPUT_LOG"
  rcctl start rsyslogd
else
  cp "$INPUT_LOG" "$OUT_FILE"
  : > "$INPUT_LOG"
fi

find "$OUTPUT_DIR" -type f -name 'rsyslog-*.log' -mmin +$((KEEP_HOURS * 60)) | while IFS= read -r old_log; do
  # Uses mtime as the age proxy for retention.
  # Only remove logs that have an explicit local tape-confirmation marker.
  [ -f "$old_log.taped" ] || continue
  rm -f "$old_log" "$old_log.taped"
  log_info "$(printf 'Removed retained hourly log and marker: %s' "$old_log")"
done

log_info "$(printf 'Created hourly log %s and rotated %s' "$OUT_FILE" "$INPUT_LOG")"
