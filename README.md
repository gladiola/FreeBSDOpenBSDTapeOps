# FreeBSDOpenBSDTapeOps

Interactive shell scripts that walk through common magnetic tape operations using `mt` and `tar`.

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
| `scripts/computer-b-daily-archive.sh` | Bundles one day (`YYYYMMDD`) of hourly logs into a `.tar.gz` archive on Computer B. |
| `scripts/computer-b-send-archives.sh` | Sends unsent daily archives from Computer B to one or more Computer C servers over `scp`. |
| `scripts/computer-c-receive-archives.sh` | Validates incoming archives on Computer C and queues them for tape. |
| `scripts/computer-c-write-to-tape.sh` | Writes queued archives to tape on Computer C, checks space, appends safely, and marks them recorded. |

Typical scheduling:

- Run `computer-b-hourly-rotate.sh` every hour (cron on B).
- Run `computer-b-daily-archive.sh` once per day (cron on B).
- Run `computer-b-send-archives.sh` after archive creation (cron on B).
- Run `computer-c-receive-archives.sh` periodically on C.
- Run `computer-c-write-to-tape.sh` periodically on C with the correct tape device.

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

### 72-hour retention

The scripts now default to a 72-hour retention window:

- `computer-b-hourly-rotate.sh` keeps 72 hours by default (`keep_hours` default is `72`).
- `computer-b-send-archives.sh` deletes local archives/markers older than `RETENTION_HOURS` (default `72`).
- `computer-c-receive-archives.sh` deletes old incoming and queued/taped files older than `RETENTION_HOURS` (default `72`).
- `computer-c-write-to-tape.sh` deletes old queued/taped files older than `RETENTION_HOURS` (default `72`).
