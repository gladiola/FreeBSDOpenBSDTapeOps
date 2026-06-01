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