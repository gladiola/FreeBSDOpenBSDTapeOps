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
Usage: computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>

Searches tape files sequentially for the requested archive, decrypts if needed, and
writes the recovered archive payload to output_file for examination.

Matching:
  - If archive_name follows rsyslog-<start>_to_<end>.tar.gz[.enc], match by
    verifying those boundary hourly log files exist in the candidate archive.
  - Otherwise set TARGET_MEMBER_GLOB (shell pattern) to identify a member file.

Optional decryption settings (only used when candidate is encrypted):
  OPENSSL_DECRYPT_CIPHER=aes-256-cbc
  OPENSSL_DECRYPT_KEY_FILE=/path/to/symmetric_passphrase_file
  OPENSSL_DECRYPT_CERT_FILE=/path/to/recipient_cert.pem
  OPENSSL_DECRYPT_PRIVATE_KEY_FILE=/path/to/private_key.pem
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

TAPE_DEVICE=$1
ARCHIVE_NAME=$2
OUTPUT_FILE=$3
TAPE_BLOCK_SIZE=${TAPE_BLOCK_SIZE:-64k}
TARGET_MEMBER_GLOB=${TARGET_MEMBER_GLOB:-}
OPENSSL_DECRYPT_CIPHER=${OPENSSL_DECRYPT_CIPHER:-aes-256-cbc}
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

EXPECT_START=
EXPECT_END=
case "$ARCHIVE_NAME" in
  rsyslog-*_to_*.tar.gz|rsyslog-*_to_*.tar.gz.enc)
    EXPECT_START=$(printf '%s\n' "$ARCHIVE_NAME" | sed -n 's/^rsyslog-\(.*\)_to_.*\.tar\.gz\(\.enc\)\{0,1\}$/\1/p')
    EXPECT_END=$(printf '%s\n' "$ARCHIVE_NAME" | sed -n 's/^rsyslog-.*_to_\(.*\)\.tar\.gz\(\.enc\)\{0,1\}$/\1/p')
    ;;
esac

if [ -z "$EXPECT_START" ] || [ -z "$EXPECT_END" ]; then
  if [ -z "$TARGET_MEMBER_GLOB" ]; then
    log_error "$(printf 'Could not infer archive boundaries from name %s; set TARGET_MEMBER_GLOB' "$ARCHIVE_NAME")"
    exit 2
  fi
fi

to_legacy_hour_file() {
  token=$1
  compact=$(printf '%s' "$token" | sed 's/-//g;s/T//;s/00$//')
  printf 'rsyslog-%s.log\n' "$compact"
}

archive_matches_target() {
  archive=$1

  if [ -n "$TARGET_MEMBER_GLOB" ]; then
    if tar -tzf "$archive" 2>/dev/null | while IFS= read -r member; do
      case "$member" in
        $TARGET_MEMBER_GLOB)
          exit 0
          ;;
      esac
    done
    then
      return 0
    fi
    return 1
  fi

  start_human=$(printf 'rsyslog-%s.log\n' "$EXPECT_START")
  end_human=$(printf 'rsyslog-%s.log\n' "$EXPECT_END")
  start_legacy=$(to_legacy_hour_file "$EXPECT_START")
  end_legacy=$(to_legacy_hour_file "$EXPECT_END")

  tar -tzf "$archive" 2>/dev/null | awk \
    -v sh="$start_human" -v eh="$end_human" \
    -v sl="$start_legacy" -v el="$end_legacy" '
      $0 == sh || $0 == sl { start_found = 1 }
      $0 == eh || $0 == el { end_found = 1 }
      END { exit ! (start_found && end_found) }
    '
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

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/restore-from-tape.XXXXXX")
cleanup() {
  rm -rf "$tmpdir"
}
trap 'cleanup' EXIT INT TERM HUP

found=0
mkdir -p "$(dirname "$OUTPUT_FILE")"

if [ -c "$TAPE_DEVICE" ]; then
  if ! mt -f "$TAPE_DEVICE" rewind >/dev/null 2>&1; then
    log_error "$(printf 'Failed to rewind tape device %s' "$TAPE_DEVICE")"
    exit 3
  fi

  position=0
  while :; do
    raw="$tmpdir/tape-file-$position.bin"
    if ! dd if="$TAPE_DEVICE" of="$raw" bs="$TAPE_BLOCK_SIZE" 2>/dev/null; then
      log_error "$(printf 'Failed reading tape at file position %s' "$position")"
      exit 4
    fi

    if [ ! -s "$raw" ]; then
      break
    fi

    candidate="$raw"
    decoded="$tmpdir/tape-file-$position.tar.gz"
    if tar -tzf "$candidate" >/dev/null 2>&1; then
      :
    else
      if decrypt_candidate_to_tar "$raw" "$decoded"; then
        candidate="$decoded"
      else
        position=$((position + 1))
        continue
      fi
    fi

    if archive_matches_target "$candidate"; then
      cp "$candidate" "$OUTPUT_FILE"
      log_info "$(printf 'Recovered archive from tape file position %s into %s' "$position" "$OUTPUT_FILE")"
      found=1
      break
    fi

    position=$((position + 1))
  done
else
  raw="$tmpdir/tape-file-0.bin"
  cp "$TAPE_DEVICE" "$raw"
  candidate="$raw"
  decoded="$tmpdir/tape-file-0.tar.gz"

  if tar -tzf "$candidate" >/dev/null 2>&1; then
    :
  else
    if decrypt_candidate_to_tar "$raw" "$decoded"; then
      candidate="$decoded"
    else
      log_error "$(printf 'Input %s is not a readable archive and could not be decrypted' "$TAPE_DEVICE")"
      exit 5
    fi
  fi

  if archive_matches_target "$candidate"; then
    cp "$candidate" "$OUTPUT_FILE"
    log_info "$(printf 'Recovered archive from %s into %s' "$TAPE_DEVICE" "$OUTPUT_FILE")"
    found=1
  fi
fi

if [ "$found" -ne 1 ]; then
  log_error "$(printf 'Requested archive %s not found on tape input %s' "$ARCHIVE_NAME" "$TAPE_DEVICE")"
  exit 6
fi

