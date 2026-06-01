#!/bin/sh
set -eu

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
KEEP_HOURS=${3:-168}

if [ ! -f "$INPUT_LOG" ]; then
  printf 'Input log not found: %s\n' "$INPUT_LOG" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

STAMP=$(date +%Y%m%d%H)
OUT_FILE="$OUTPUT_DIR/rsyslog-$STAMP.log"

cp "$INPUT_LOG" "$OUT_FILE"
: > "$INPUT_LOG"

find "$OUTPUT_DIR" -type f -name 'rsyslog-*.log' -mtime +$((KEEP_HOURS / 24)) -delete

printf 'Created hourly log %s and truncated %s\n' "$OUT_FILE" "$INPUT_LOG"
