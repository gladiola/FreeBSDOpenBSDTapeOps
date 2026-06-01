# FreeBSDOpenBSDTapeOps (Norsk)

Interactive shell scripts that walk through common magnetic tape operations using `mt` and `tar`.

## Language Documentation Index

- [US English](docs/i18n/README.en-US.md)
- [Deutsch (German)](docs/i18n/README.de.md)
- [Español (Spanish)](docs/i18n/README.es.md)
- [Français (French)](docs/i18n/README.fr.md)
- [Português (Portuguese)](docs/i18n/README.pt.md)
- [Italiano (Italian)](docs/i18n/README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](docs/i18n/README.zh-HK.md)
- [简体中文 (Simplified Chinese)](docs/i18n/README.zh-CN.md)
- [한국어 (Korean)](docs/i18n/README.ko.md)
- [हिन्दी (Hindi)](docs/i18n/README.hi.md)
- [Русский (Russian)](docs/i18n/README.ru.md)
- [العربية (Arabic)](docs/i18n/README.ar.md)
- [Kiswahili (Swahili)](docs/i18n/README.sw.md)
- [日本語 (Japanese)](docs/i18n/README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](docs/i18n/README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](docs/i18n/README.haw.md)
- [Gagana Samoa (Samoan)](docs/i18n/README.sm.md)
- [Te Reo Māori (Maori)](docs/i18n/README.mi.md)
- [Afrikaans](docs/i18n/README.af.md)
- [Nederlands (Dutch)](docs/i18n/README.nl.md)
- [Hausa](docs/i18n/README.ha.md)
- [አማርኛ (Amharic)](docs/i18n/README.am.md)
- [Yorùbá (Yoruba)](docs/i18n/README.yo.md)
- [বাংলা (Bengali)](docs/i18n/README.bn.md)
- [Gaeilge (Irish)](docs/i18n/README.ga.md)
- [Eesti (Estonian)](docs/i18n/README.et.md)
- [Suomi (Finnish)](docs/i18n/README.fi.md)
- [Svenska (Swedish)](docs/i18n/README.sv.md)
- [Norsk (Norwegian)](docs/i18n/README.no.md)
- [Українська (Ukrainian)](docs/i18n/README.uk.md)
- [ไทย (Thai)](docs/i18n/README.th.md)
- [Bahasa Indonesia](docs/i18n/README.id.md)
- [Tagalog](docs/i18n/README.tl.md)
- [Bahasa Melayu (Malay)](docs/i18n/README.ms.md)
- [Basa Jawa (Javanese)](docs/i18n/README.jv.md)
- [Ελληνικά (Greek)](docs/i18n/README.el.md)
- [Latina (Latin)](docs/i18n/README.la.md)
- [עברית (Hebrew)](docs/i18n/README.he.md)


## Scripts

| Script | Target OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Both scripts perform the same sequence of operations:

1. Prompt the user to confirm the tape is loaded.
2. Rewind the tape.
3. Print the tape status.
4. List the contents of archives at file positions 0, 1, 2, and 3 using `tar t`.
5. Take the tape offline.

Each step pauses and waits for the user to press **Enter** before continuing, making the scripts suitable as interactive demonstrations or guided walkthroughs.

## Differences Between the Two Scripts

### 1. Tape device path

The scripts target different tape device nodes:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Both are non-rewinding device nodes (the `n` prefix), so the tape position is preserved between commands and the scripts control positioning explicitly with `mt rewind` and `mt fsf`.

### 2. Tape loading step

- **FreeBSD**: Issues `mt -f /dev/nsa0 load` at startup to mechanically load the tape cartridge into the drive before rewinding.
- **OpenBSD**: Skips the `load` command because OpenBSD's `mt(1)` does not support a `load` subcommand. The OpenBSD script assumes the tape is already present in the drive and proceeds directly to rewind.

## OpenBSD A-to-B-to-C Log Pipeline Scripts

The `scripts/` directory provides scripts for the scenario where OpenBSD Computer B receives rsyslog entries from Computer A, batches them daily, sends them to one of several Computer C servers, and Computer C writes them to tape.

| Script | Purpose |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Creates an hourly rotated log from the active rsyslog input file on Computer B. |
| `scripts/computer-b-daily-archive.sh` | Bundles one day (`YYYYMMDD`) of hourly logs into a time-ranged `.tar.gz` archive on Computer B, excluding the current hour to avoid active-write conflicts. |
| `scripts/computer-b-send-archives.sh` | Sends unsent daily archives (`.tar.gz` and optional `.tar.gz.enc`) from Computer B to one or more Computer C servers over `scp`. |
| `scripts/computer-c-receive-archives.sh` | Validates incoming plaintext archives and queues plaintext/encrypted archives for tape. |
| `scripts/computer-c-write-to-tape.sh` | Writes queued plaintext or encrypted archives to tape, checks space, appends safely, and marks them recorded. |
| `scripts/computer-c-inventory-tape.sh` | Prints a tape table-of-contents by file marker so operators can locate archives quickly. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Scans tape file positions for a requested archive, decrypts when needed, and saves recovered data to a file. |
| `scripts/test-computer-a-b-c-integration.sh` | Runs a deterministic local A→B→C integration test (including tape restore) that does not depend on wall-clock timing. |

Typical scheduling:

- Run `computer-b-hourly-rotate.sh` every hour (cron on B).
- Run `computer-b-daily-archive.sh` once per day (cron on B).
- Run `computer-b-send-archives.sh` after archive creation (cron on B).
- Run `computer-c-receive-archives.sh` periodically on C.
- Run `computer-c-write-to-tape.sh` periodically on C with the correct tape device.
- Run `computer-c-inventory-tape.sh` on C when you need a marker-by-marker table of contents.
- Run `computer-c-restore-archive-from-tape.sh` on C when you need to recover a specific archive for inspection.

All pipeline scripts also emit operational messages to syslog via `logger` (for example, visible through rsyslog/journaling) in addition to console output.

### Multi-server send from Computer B

`computer-b-send-archives.sh` supports both single-server mode and multi-server mode:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Client-side server selection options:

- Provide one server in arguments to pin to one Computer C.
- Provide multiple servers to allow fallback.
- Set `PREFERRED_SERVER=user@host` to choose one specific server from the provided list.

Busy handling options on Computer B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): marker file checked on the remote side.
- `BUSY_RETRY_SECONDS` (default: `60`): wait time between retries while server is busy.
- `BUSY_MAX_RETRIES` (default: `10`): max retry attempts per server.

### Busy state publication from Computer C

`computer-c-write-to-tape.sh` creates a busy marker while actively writing archives to tape and removes it when idle.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Point `REMOTE_BUSY_MARKER` on Computer B to the marker location used by Computer C.

### Tape safety and append behavior on Computer C

Before writing each archive, `computer-c-write-to-tape.sh` checks for available tape/device capacity and requires at least:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevant variables:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override for known available space)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (allows writing if space cannot be detected)

For real tape devices, the writer seeks to end-of-data (`mt eom`/`mt eod`) before writing, so multiple archives are appended instead of overwriting previous tape contents.

### Human-readable timestamps in filenames

- Hourly logs are named like: `rsyslog-2026-06-01T1600.log`
- Daily archives are named like: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Daily archive ranges are based on the actual first and last hourly files included in the archive.
These names are intended to be readable by people scanning for event date/time windows.
The current hour is intentionally excluded from archive creation so active writes are not transmitted.

### Optional OpenSSL encryption for daily archives

`computer-b-daily-archive.sh` can encrypt archives with OpenSSL after creating the tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` for symmetric encryption (`openssl enc`, default cipher `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` for recipient-certificate encryption (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` to choose the OpenSSL cipher for both key-file and certificate modes (default: `aes-256-gcm`).

Only one of these options may be set at a time. Encrypted outputs use `.tar.gz.enc`.
For security, the script rejects weak or non-AEAD cipher choices and requires GCM/poly1305-class ciphers.

### Archive recovery from tape on Computer C

Use `computer-c-restore-archive-from-tape.sh` to locate a specific archive by searching tape files in order from the beginning:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- For archive names like `rsyslog-<start>_to_<end>.tar.gz` (or `.tar.gz.enc`), the script identifies the correct match by checking that boundary hourly files are present in the recovered payload.
- If your archive naming is different, set `TARGET_MEMBER_GLOB` to a shell pattern matching a member that must exist in the archive.
- If an archive is encrypted, provide decryption settings as needed:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetric `openssl enc` mode; default decrypt cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` and `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME decrypt mode)

The recovered output is written as a plaintext `.tar.gz` file so it can be inspected with tools like `tar -tzf`.

### Tape table-of-contents inventory on Computer C

Use `computer-c-inventory-tape.sh` to print a marker-by-marker table of contents:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

The output columns include:

- `file_marker`: zero-based tape file marker position
- `status`: `ok`, `decrypted`, or `unreadable`
- `encrypted`: whether decryption was needed to inspect the entry (`yes`/`no`)
- `archive_hint`: inferred archive-style name when boundaries can be recognized
- `first_member` / `last_member`: first and last tar members seen in that marker
- `member_count`: number of tar members found in that marker
- `bytes`: raw bytes read at that marker

This lets an operator identify the marker index to seek (`mt fsf <N>`) before restore operations.

### Deterministic A/B/C integration test

Use `scripts/test-computer-a-b-c-integration.sh` to validate end-to-end integration of Computers A, B, and C regardless of elapsed time:

```sh
scripts/test-computer-a-b-c-integration.sh
```

This script:

1. Simulates A writing logs.
2. Runs B rotation and daily archive creation.
3. Simulates transfer into C incoming.
4. Runs C receive + write-to-tape.
5. Restores the archive from tape and validates content.

It uses a fixed day stamp (`TEST_DAY_STAMP`, default `20260101`) so behavior is repeatable and not tied to current date/time.

### 72-hour retention with safety for unconfirmed data

The scripts now default to a 72-hour retention window:

- `computer-b-hourly-rotate.sh` only removes old hourly logs when a matching local `.taped` confirmation marker exists.
- `computer-b-send-archives.sh` only removes old local archives when both `.sent` and local `.taped` confirmation markers exist.
- `computer-c-write-to-tape.sh` only removes old archives that already have `.taped` markers.

As a result, files that are not yet successfully transmitted and recorded to tape are retained even when older than `RETENTION_HOURS` (default `72`).
On Computer B, local cleanup requires local `.taped` markers (for example from a sync-back step or manual confirmation process).
On Computer C, retention age is measured from `.taped` marker modification time (normally set at successful tape write time).
