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
Usage: computer-b-daily-archive.sh <hourly_log_dir> <archive_dir> <day_stamp>

Builds one 24-hour tar.gz archive for the specified day (YYYYMMDD).
Optional encryption:
  OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile   (symmetric, openssl enc)
  OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem (recipient cert, openssl smime AES-256-GCM)
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
    log_error "$(printf 'Invalid day stamp (expected YYYYMMDD): %s' "$DAY_STAMP")"
    exit 2
    ;;
esac

DAY_HUMAN=$(printf '%s' "$DAY_STAMP" | sed 's/^\(....\)\(..\)\(..\)$/\1-\2-\3/')
# Hourly files are stamped with local time in computer-b-hourly-rotate.sh,
# so current-hour exclusion uses the same local-time basis.
CURRENT_HOUR_TOKEN=$(date +%Y-%m-%dT%H00)
OPENSSL_ENCRYPT_KEY_FILE=${OPENSSL_ENCRYPT_KEY_FILE:-}
OPENSSL_ENCRYPT_CERT_FILE=${OPENSSL_ENCRYPT_CERT_FILE:-}
OPENSSL_ENCRYPT_CIPHER=${OPENSSL_ENCRYPT_CIPHER:-aes-256-gcm}

if [ -n "$OPENSSL_ENCRYPT_KEY_FILE" ] && [ -n "$OPENSSL_ENCRYPT_CERT_FILE" ]; then
  log_error 'Set only one of OPENSSL_ENCRYPT_KEY_FILE or OPENSSL_ENCRYPT_CERT_FILE'
  exit 2
fi

if [ -n "$OPENSSL_ENCRYPT_KEY_FILE" ] && [ ! -f "$OPENSSL_ENCRYPT_KEY_FILE" ]; then
  log_error "$(printf 'Encryption key file not found: %s' "$OPENSSL_ENCRYPT_KEY_FILE")"
  exit 2
fi

if [ -n "$OPENSSL_ENCRYPT_CERT_FILE" ] && [ ! -f "$OPENSSL_ENCRYPT_CERT_FILE" ]; then
  log_error "$(printf 'Encryption certificate file not found: %s' "$OPENSSL_ENCRYPT_CERT_FILE")"
  exit 2
fi

if [ -n "$OPENSSL_ENCRYPT_KEY_FILE" ] || [ -n "$OPENSSL_ENCRYPT_CERT_FILE" ]; then
  if ! command -v openssl >/dev/null 2>&1; then
    log_error 'OpenSSL is required for archive encryption but was not found in PATH'
    exit 2
  fi
fi

require_strong_encrypt_cipher() {
  cipher_lower=$(printf '%s' "$OPENSSL_ENCRYPT_CIPHER" | tr '[:upper:]' '[:lower:]')
  case "$cipher_lower" in
    *gcm*|*poly1305*)
      return 0
      ;;
    *)
      log_error "$(printf 'Refusing weak/non-AEAD cipher "%s"; use GCM or better (for example: aes-256-gcm)' "$OPENSSL_ENCRYPT_CIPHER")"
      return 1
      ;;
  esac
}

if [ -n "$OPENSSL_ENCRYPT_KEY_FILE" ] || [ -n "$OPENSSL_ENCRYPT_CERT_FILE" ]; then
  if ! require_strong_encrypt_cipher; then
    exit 2
  fi
fi

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

    token=$(hour_token_from_file "$base") || continue
    if [ "$token" = "$CURRENT_HOUR_TOKEN" ]; then
      log_info "$(printf 'Skipping current-hour log to avoid conflicts: %s' "$base")"
      continue
    fi
    set -- "$@" "$base"
    if [ -z "$FIRST_HOUR" ]; then
      FIRST_HOUR=$token
    fi
    LAST_HOUR=$token
  done
done

if [ "$#" -eq 0 ]; then
  log_error "$(printf 'No hourly logs found for day %s in %s after current-hour exclusion' "$DAY_STAMP" "$HOURLY_DIR")"
  exit 3
fi

if [ -z "$FIRST_HOUR" ] || [ -z "$LAST_HOUR" ]; then
  log_error "$(printf 'Could not determine first/last hour for archive naming on day %s' "$DAY_STAMP")"
  exit 4
fi

ARCHIVE_FILE="$ARCHIVE_DIR/rsyslog-${FIRST_HOUR}_to_${LAST_HOUR}.tar.gz"

tar -C "$HOURLY_DIR" -czf "$ARCHIVE_FILE" "$@"

if [ -n "$OPENSSL_ENCRYPT_KEY_FILE" ]; then
  ENCRYPTED_ARCHIVE="$ARCHIVE_FILE.enc"
  if openssl enc "-$OPENSSL_ENCRYPT_CIPHER" -pbkdf2 -salt -in "$ARCHIVE_FILE" -out "$ENCRYPTED_ARCHIVE" -pass "file:$OPENSSL_ENCRYPT_KEY_FILE"; then
    rm -f "$ARCHIVE_FILE"
    ARCHIVE_FILE=$ENCRYPTED_ARCHIVE
    log_info "$(printf 'Encrypted archive with key file: %s' "$ARCHIVE_FILE")"
  else
    log_error "$(printf 'Failed to encrypt archive with key file: %s' "$ARCHIVE_FILE")"
    exit 5
  fi
elif [ -n "$OPENSSL_ENCRYPT_CERT_FILE" ]; then
  ENCRYPTED_ARCHIVE="$ARCHIVE_FILE.enc"
  # -outform DER sets the S/MIME envelope serialization to binary DER
  # (no PEM headers), while -$OPENSSL_ENCRYPT_CIPHER selects the content cipher.
  if openssl smime -encrypt -binary "-$OPENSSL_ENCRYPT_CIPHER" -in "$ARCHIVE_FILE" -out "$ENCRYPTED_ARCHIVE" -outform DER "$OPENSSL_ENCRYPT_CERT_FILE"; then
    rm -f "$ARCHIVE_FILE"
    ARCHIVE_FILE=$ENCRYPTED_ARCHIVE
    log_info "$(printf 'Encrypted archive with certificate: %s' "$ARCHIVE_FILE")"
  else
    log_error "$(printf 'Failed to encrypt archive with certificate: %s' "$ARCHIVE_FILE")"
    exit 5
  fi
fi

log_info "$(printf 'Created daily archive %s' "$ARCHIVE_FILE")"
