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
## OpenBSD A→B→C Log Pipeline Scripts

The `scripts/` directory provides scripts for the scenario where OpenBSD Computer B receives rsyslog entries from Computer A, batches them daily, sends them to Computer C, and Computer C writes them to tape.

| Script | Purpose |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Creates an hourly rotated log from the active rsyslog input file on Computer B. |
| `scripts/computer-b-daily-archive.sh` | Bundles one day (`YYYYMMDD`) of hourly logs into a `.tar.gz` archive on Computer B. |
| `scripts/computer-b-send-archives.sh` | Sends unsent daily archives from Computer B to Computer C over `scp`. |
| `scripts/computer-c-receive-archives.sh` | Validates incoming archives on Computer C and queues them for tape. |
| `scripts/computer-c-write-to-tape.sh` | Writes queued archives to tape on Computer C and marks them recorded. |

Typical scheduling:

- Run `computer-b-hourly-rotate.sh` every hour (cron on B).
- Run `computer-b-daily-archive.sh` once per day (cron on B).
- Run `computer-b-send-archives.sh` after archive creation (cron on B).
- Run `computer-c-receive-archives.sh` periodically on C.
- Run `computer-c-write-to-tape.sh` periodically on C with the correct tape device.
