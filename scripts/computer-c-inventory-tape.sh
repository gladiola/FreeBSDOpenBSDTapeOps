#!/bin/sh
set -eu

SCRIPT_NAME=$(basename "$0")

log_error() {
  msg=$1
  printf '%s\n' "$msg" >&2
  if command -v logger >/dev/null 2>&1; then
    logger -t "$SCRIPT_NAME" -p user.err "$msg" || true
  fi
}

usage() {
  cat <<'USAGE'
Usage: computer-c-inventory-tape.sh <tape_device>

Inventories tape file markers and prints a table-of-contents showing where
archives exist on tape.

Optional decryption settings (used for encrypted entries):
  OPENSSL_DECRYPT_CIPHER=aes-256-gcm
  OPENSSL_DECRYPT_KEY_FILE=/path/to/symmetric_passphrase_file
  OPENSSL_DECRYPT_CERT_FILE=/path/to/recipient_cert.pem
  OPENSSL_DECRYPT_PRIVATE_KEY_FILE=/path/to/private_key.pem
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 1
fi

TAPE_DEVICE=$1
TAPE_BLOCK_SIZE=${TAPE_BLOCK_SIZE:-64k}
OPENSSL_DECRYPT_CIPHER=${OPENSSL_DECRYPT_CIPHER:-aes-256-gcm}
OPENSSL_DECRYPT_KEY_FILE=${OPENSSL_DECRYPT_KEY_FILE:-}
OPENSSL_DECRYPT_CERT_FILE=${OPENSSL_DECRYPT_CERT_FILE:-}
OPENSSL_DECRYPT_PRIVATE_KEY_FILE=${OPENSSL_DECRYPT_PRIVATE_KEY_FILE:-}

if [ ! -e "$TAPE_DEVICE" ]; then
  log_error "$(printf 'Tape device/file not found: %s' "$TAPE_DEVICE")"
  exit 2
fi

if [ -n "$OPENSSL_DECRYPT_KEY_FILE" ] && [ ! -f "$OPENSSL_DECRYPT_KEY_FILE" ]; then
  log_error "$(printf 'Decryption passphrase file not found: %s' "$OPENSSL_DECRYPT_KEY_FILE")"
  exit 2
fi

if [ -n "$OPENSSL_DECRYPT_CERT_FILE" ] && [ ! -f "$OPENSSL_DECRYPT_CERT_FILE" ]; then
  log_error "$(printf 'Decryption certificate file not found: %s' "$OPENSSL_DECRYPT_CERT_FILE")"
  exit 2
fi

if [ -n "$OPENSSL_DECRYPT_PRIVATE_KEY_FILE" ] && [ ! -f "$OPENSSL_DECRYPT_PRIVATE_KEY_FILE" ]; then
  log_error "$(printf 'Decryption private key file not found: %s' "$OPENSSL_DECRYPT_PRIVATE_KEY_FILE")"
  exit 2
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/inventory-tape.XXXXXX")
cleanup() {
  rm -rf "$tmpdir"
}
trap 'cleanup' EXIT INT TERM HUP

member_to_token() {
  member=$1
  case "$member" in
    rsyslog-*.log)
      stamp=${member#rsyslog-}
      stamp=${stamp%.log}
      case "$stamp" in
        ????-??-??T??00)
          printf '%s\n' "$stamp"
          return 0
          ;;
        [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
          printf '%s\n' "$stamp" | awk '{printf "%s-%s-%sT%s00\n", substr($0,1,4), substr($0,5,2), substr($0,7,2), substr($0,9,2)}'
          return 0
          ;;
      esac
      ;;
  esac
  return 1
}

infer_archive_hint() {
  first_member=$1
  last_member=$2

  if ! start=$(member_to_token "$first_member"); then
    return 1
  fi

  if ! end=$(member_to_token "$last_member"); then
    return 1
  fi

  printf 'rsyslog-%s_to_%s.tar.gz\n' "$start" "$end"
  return 0
}

decrypt_candidate_to_tar() {
  in_file=$1
  out_file=$2

  if ! command -v openssl >/dev/null 2>&1; then
    return 1
  fi

  if [ -n "$OPENSSL_DECRYPT_KEY_FILE" ]; then
    if openssl enc -d "-$OPENSSL_DECRYPT_CIPHER" -pbkdf2 \
      -in "$in_file" -out "$out_file" -pass "file:$OPENSSL_DECRYPT_KEY_FILE" \
      >/dev/null 2>&1
    then
      if tar -tzf "$out_file" >/dev/null 2>&1; then
        return 0
      fi
    fi
  fi

  if [ -n "$OPENSSL_DECRYPT_CERT_FILE" ] && [ -n "$OPENSSL_DECRYPT_PRIVATE_KEY_FILE" ]; then
    if openssl smime -decrypt -binary -inform DER \
      -in "$in_file" -out "$out_file" \
      -recip "$OPENSSL_DECRYPT_CERT_FILE" -inkey "$OPENSSL_DECRYPT_PRIVATE_KEY_FILE" \
      >/dev/null 2>&1
    then
      if tar -tzf "$out_file" >/dev/null 2>&1; then
        return 0
      fi
    fi
  fi

  return 1
}

print_header() {
  printf 'file_marker\tstatus\tencrypted\tarchive_hint\tfirst_member\tlast_member\tmember_count\tbytes\n'
}

print_row() {
  marker=$1
  status=$2
  encrypted=$3
  archive_hint=$4
  first_member=$5
  last_member=$6
  member_count=$7
  bytes=$8

  # Columns: file_marker status encrypted archive_hint first_member last_member member_count bytes
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$marker" "$status" "$encrypted" "$archive_hint" "$first_member" "$last_member" "$member_count" "$bytes"
}

inventory_entry() {
  marker=$1
  raw=$2
  bytes=$(wc -c < "$raw" | tr -d ' ')

  candidate=$raw
  encrypted=no
  status=ok

  if tar -tzf "$candidate" >/dev/null 2>&1; then
    :
  else
    decoded="$tmpdir/tape-file-$marker.tar.gz"
    if decrypt_candidate_to_tar "$raw" "$decoded"; then
      candidate=$decoded
      encrypted=yes
      status=decrypted
    else
      print_row "$marker" unreadable unknown unknown unknown 0 "$bytes"
      return 0
    fi
  fi

  summary=$(tar -tzf "$candidate" 2>/dev/null | awk '
    BEGIN {
      count = 0
      first = "unknown"
      last = "unknown"
    }
    NF {
      count += 1
      if (first == "unknown") first = $0
      last = $0
    }
    END {
      printf "%d\t%s\t%s\n", count, first, last
    }
  ')
  member_count=$(printf '%s\n' "$summary" | awk -F '\t' 'NR==1 { print $1 }')
  first_member=$(printf '%s\n' "$summary" | awk -F '\t' 'NR==1 { print $2 }')
  last_member=$(printf '%s\n' "$summary" | awk -F '\t' 'NR==1 { print $3 }')

  archive_hint=unknown
  if inferred=$(infer_archive_hint "$first_member" "$last_member" 2>/dev/null); then
    archive_hint=$inferred
    if [ "$encrypted" = "yes" ]; then
      archive_hint="$archive_hint.enc"
    fi
  fi

  print_row "$marker" "$status" "$encrypted" "$archive_hint" "$first_member" "$last_member" "$member_count" "$bytes"
}

print_header

if [ -c "$TAPE_DEVICE" ]; then
  if ! mt -f "$TAPE_DEVICE" rewind >/dev/null 2>&1; then
    log_error "$(printf 'Failed to rewind tape device %s' "$TAPE_DEVICE")"
    exit 3
  fi

  marker=0
  while :; do
    raw="$tmpdir/tape-file-$marker.bin"
    if ! dd if="$TAPE_DEVICE" of="$raw" bs="$TAPE_BLOCK_SIZE" 2>/dev/null; then
      log_error "$(printf 'Failed reading tape at file marker %s' "$marker")"
      exit 4
    fi

    if [ ! -s "$raw" ]; then
      break
    fi

    inventory_entry "$marker" "$raw"
    marker=$((marker + 1))
  done
else
  raw="$tmpdir/tape-file-0.bin"
  cp "$TAPE_DEVICE" "$raw"

  if [ ! -s "$raw" ]; then
    log_error "$(printf 'Tape input is empty: %s' "$TAPE_DEVICE")"
    exit 5
  fi

  inventory_entry 0 "$raw"
fi
