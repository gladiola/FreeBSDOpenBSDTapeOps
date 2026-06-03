# FreeBSDOpenBSDTapeOps (Tagalog)

Mga interaktibong shell script na gumagabay sa karaniwang operasyon ng magnetic tape gamit ang `mt` at `tar`.

## Indeks ng Dokumentasyon ng Wika

- [US English](README.en-US.md)
- [Deutsch (German)](README.de.md)
- [Español (Spanish)](README.es.md)
- [Français (French)](README.fr.md)
- [Português (Portuguese)](README.pt.md)
- [Italiano (Italian)](README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](README.zh-HK.md)
- [简体中文 (Simplified Chinese)](README.zh-CN.md)
- [한국어 (Korean)](README.ko.md)
- [हिन्दी (Hindi)](README.hi.md)
- [Русский (Russian)](README.ru.md)
- [العربية (Arabic)](README.ar.md)
- [Kiswahili (Swahili)](README.sw.md)
- [日本語 (Japanese)](README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](README.haw.md)
- [Gagana Samoa (Samoan)](README.sm.md)
- [Te Reo Māori (Maori)](README.mi.md)
- [Afrikaans](README.af.md)
- [Nederlands (Dutch)](README.nl.md)
- [Hausa](README.ha.md)
- [አማርኛ (Amharic)](README.am.md)
- [Yorùbá (Yoruba)](README.yo.md)
- [বাংলা (Bengali)](README.bn.md)
- [Gaeilge (Irish)](README.ga.md)
- [Eesti (Estonian)](README.et.md)
- [Suomi (Finnish)](README.fi.md)
- [Svenska (Swedish)](README.sv.md)
- [Norsk (Norwegian)](README.no.md)
- [Українська (Ukrainian)](README.uk.md)
- [ไทย (Thai)](README.th.md)
- [Bahasa Indonesia](README.id.md)
- [Tagalog](README.tl.md)
- [Bahasa Melayu (Malay)](README.ms.md)
- [Basa Jawa (Javanese)](README.jv.md)
- [Ελληνικά (Greek)](README.el.md)
- [Latina (Latin)](README.la.md)
- [עברית (Hebrew)](README.he.md)


## Mga Script

| Script | Target na OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Parehong script ay nagsasagawa ng iisang pagkakasunod ng operasyon:

1. Hilingin sa user na kumpirmahing naka-load ang tape.
2. I-rewind ang tape.
3. I-print ang status ng tape.
4. Ilista ang nilalaman ng mga archive sa file positions 0, 1, 2, at 3 gamit ang `tar t`.
5. Ilagay ang tape sa offline.

Bawat hakbang ay humihinto at naghihintay na pindutin ng user ang **Enter** bago magpatuloy, kaya ang mga script ay angkop para sa interaktibong demo o guided walkthrough.

## Pagkakaiba ng Dalawang Script

### 1. Path ng tape device

Magkaiba ang tape device node na tina-target ng mga script:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Pareho silang non-rewinding device nodes (prefix na `n`), kaya napapanatili ang posisyon ng tape sa pagitan ng mga command at tahasang kinokontrol ng scripts ang pagposisyon gamit ang `mt rewind` at `mt fsf`.

### 2. Hakbang sa pag-load ng tape

- **FreeBSD**: Nagpapatakbo ng `mt -f /dev/nsa0 load` sa startup para mekanikal na i-load ang tape cartridge sa drive bago mag-rewind.
- **OpenBSD**: Nilalampasan ang command na `load` dahil hindi suportado ng `mt(1)` ng OpenBSD ang `load` subcommand. Ipinapalagay ng OpenBSD script na nasa drive na ang tape at direktang magre-rewind.

## OpenBSD A-to-B-to-C Log Pipeline Scripts

Ang direktoryong `scripts/` ay may mga script para sa sitwasyong tumatanggap ang OpenBSD Computer B ng rsyslog entries mula sa Computer A, iniipon ang mga ito araw-araw, ipinapadala sa isa sa maraming Computer C servers, at isinusulat ng Computer C sa tape.

| Script | Layunin |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Gumagawa ng hourly rotated log mula sa aktibong rsyslog input file sa Computer B. |
| `scripts/computer-b-daily-archive.sh` | Binubuo ang isang araw (`YYYYMMDD`) ng hourly logs sa time-ranged `.tar.gz` archive sa Computer B, at hindi isinasama ang kasalukuyang oras upang maiwasan ang active-write conflicts. |
| `scripts/computer-b-send-archives.sh` | Ipinapadala ang hindi pa naipapadalang daily archives (`.tar.gz` at optional `.tar.gz.enc`) mula Computer B papunta sa isa o higit pang Computer C servers sa `scp`. |
| `scripts/computer-c-receive-archives.sh` | Vina-validate ang mga papasok na plaintext archive at ipinipila ang plaintext/encrypted archives para sa tape. |
| `scripts/computer-c-write-to-tape.sh` | Isinusulat ang naka-queue na plaintext o encrypted archives sa tape, tinitingnan ang space, ligtas na ina-append, at minamarkahang recorded. |
| `scripts/computer-c-inventory-tape.sh` | Nagpi-print ng tape table-of-contents ayon sa file marker para mabilis mahanap ng operator ang archives. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Ini-scan ang tape file positions para sa hiniling na archive, nagde-decrypt kung kailangan, at sine-save ang recovered data sa file. |
| `scripts/test-computer-a-b-c-integration.sh` | Nagpapatakbo ng deterministikong lokal na A→B→C integration test (kasama ang tape restore) na hindi nakadepende sa wall-clock timing. |

Karaniwang iskedyul:

- Patakbuhin ang `computer-b-hourly-rotate.sh` kada oras (cron sa B).
- Patakbuhin ang `computer-b-daily-archive.sh` isang beses kada araw (cron sa B).
- Patakbuhin ang `computer-b-send-archives.sh` pagkatapos gumawa ng archive (cron sa B).
- Patakbuhin ang `computer-c-receive-archives.sh` nang pana-panahon sa C.
- Patakbuhin ang `computer-c-write-to-tape.sh` nang pana-panahon sa C gamit ang tamang tape device.
- Patakbuhin ang `computer-c-inventory-tape.sh` sa C kapag kailangan mo ng marker-by-marker table of contents.
- Patakbuhin ang `computer-c-restore-archive-from-tape.sh` sa C kapag kailangan mong ibalik ang partikular na archive para sa inspeksyon.

Lahat ng pipeline scripts ay nagpapadala rin ng operational messages sa syslog sa pamamagitan ng `logger` (halimbawa, nakikita sa rsyslog/journaling) bukod sa console output.

### Multi-server send mula Computer B

Sinusuportahan ng `computer-b-send-archives.sh` ang single-server mode at multi-server mode:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Mga opsyon sa pagpili ng server sa client side:

- Magbigay ng isang server sa arguments para i-pin sa isang Computer C.
- Magbigay ng maraming server para payagan ang fallback.
- Itakda ang `PREFERRED_SERVER=user@host` para pumili ng isang partikular na server mula sa ibinigay na listahan.

Mga opsyon sa paghawak ng busy state sa Computer B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): marker file na chine-check sa remote side.
- `BUSY_RETRY_SECONDS` (default: `60`): oras ng paghihintay sa pagitan ng retries habang busy ang server.
- `BUSY_MAX_RETRIES` (default: `10`): maximum retry attempts kada server.

### Paglalathala ng busy state mula Computer C

Gumagawa ang `computer-c-write-to-tape.sh` ng busy marker habang aktibong nagsusulat ng archives sa tape at inaalis ito kapag idle.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Ituro ang `REMOTE_BUSY_MARKER` sa Computer B sa marker location na ginagamit ng Computer C.

### Tape safety at append behavior sa Computer C

Bago isulat ang bawat archive, tinitingnan ng `computer-c-write-to-tape.sh` ang available na tape/device capacity at nangangailangan ng hindi bababa sa:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Mga kaugnay na variable:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override para sa kilalang available space)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (pinapahintulutan ang pagsusulat kung hindi ma-detect ang space)

Para sa tunay na tape devices, hinahanap ng writer ang end-of-data (`mt eom`/`mt eod`) bago magsulat, kaya ina-append ang maraming archive sa halip na ma-overwrite ang naunang laman ng tape.

### Human-readable timestamps sa filenames

- Ang hourly logs ay pinapangalanang tulad ng: `rsyslog-2026-06-01T1600.log`
- Ang daily archives ay pinapangalanang tulad ng: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Ang daily archive ranges ay batay sa aktuwal na una at huling hourly files na naisama sa archive.
Ang mga pangalang ito ay nilayon para madaling basahin ng tao habang naghahanap ng event date/time windows.
Sadyang hindi isinasama ang kasalukuyang oras sa paggawa ng archive para hindi maipadala ang active writes.

### Opsyonal na OpenSSL encryption para sa daily archives

Maaaring i-encrypt ng `computer-b-daily-archive.sh` ang archives gamit ang OpenSSL pagkatapos malikha ang tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` para sa symmetric encryption (`openssl enc`, default cipher `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` para sa recipient-certificate encryption (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` para pumili ng OpenSSL cipher para sa key-file at certificate modes (default: `aes-256-gcm`).

Isa lang sa mga opsyong ito ang puwedeng itakda sa isang pagkakataon. Ang encrypted outputs ay gumagamit ng `.tar.gz.enc`.
Para sa seguridad, tinatanggihan ng script ang mahihinang o non-AEAD cipher choices at nangangailangan ng GCM/poly1305-class ciphers.

### Pag-recover ng archive mula tape sa Computer C

Gamitin ang `computer-c-restore-archive-from-tape.sh` para hanapin ang isang partikular na archive sa pamamagitan ng pag-scan ng tape files ayon sa pagkakasunod mula simula:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Para sa archive names na tulad ng `rsyslog-<start>_to_<end>.tar.gz` (o `.tar.gz.enc`), kinikilala ng script ang tamang match sa pag-check na naroon ang boundary hourly files sa recovered payload.
- Kung iba ang archive naming mo, itakda ang `TARGET_MEMBER_GLOB` sa shell pattern na tumutugma sa member na dapat umiiral sa archive.
- Kung encrypted ang archive, ibigay ang kinakailangang decryption settings:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetric `openssl enc` mode; default decrypt cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` at `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME decrypt mode)

Ang recovered output ay isinusulat bilang plaintext `.tar.gz` file para ma-inspect gamit ang tools tulad ng `tar -tzf`.

### Tape table-of-contents inventory sa Computer C

Gamitin ang `computer-c-inventory-tape.sh` para mag-print ng marker-by-marker na table of contents:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Kasama sa output columns ang:

- `file_marker`: zero-based tape file marker position
- `status`: `ok`, `decrypted`, o `unreadable`
- `encrypted`: kung kinailangan ang decryption para siyasatin ang entry (`yes`/`no`)
- `archive_hint`: inferred archive-style name kapag nakikilala ang boundaries
- `first_member` / `last_member`: una at huling tar members na nakita sa marker na iyon
- `member_count`: bilang ng tar members na natagpuan sa marker na iyon
- `bytes`: raw bytes na nabasa sa marker na iyon

Ito ay tumutulong sa operator na tukuyin ang marker index na ise-seek (`mt fsf <N>`) bago ang restore operations.

### Deterministikong A/B/C integration test

Gamitin ang `scripts/test-computer-a-b-c-integration.sh` para i-validate ang end-to-end integration ng Computers A, B, at C anuman ang lumipas na oras:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Ang script na ito ay:

1. Nagsi-simulate na nagsusulat ng logs ang A.
2. Pinapatakbo ang rotation at daily archive creation sa B.
3. Nagsi-simulate ng transfer papasok sa C.
4. Pinapatakbo ang receive + write-to-tape sa C.
5. Nirere-restore ang archive mula tape at vina-validate ang content.

Gumagamit ito ng fixed day stamp (`TEST_DAY_STAMP`, default `20260101`) kaya repeatable ang behavior at hindi nakatali sa kasalukuyang petsa/oras.

### 72-hour retention na may kaligtasan para sa hindi pa kumpirmadong data

Default na ngayon ang scripts sa 72-hour retention window:

- `computer-b-hourly-rotate.sh` nag-aalis lang ng lumang hourly logs kapag may tumutugmang lokal na `.taped` confirmation marker.
- `computer-b-send-archives.sh` nag-aalis lang ng lumang lokal na archives kapag parehong may `.sent` at lokal na `.taped` confirmation markers.
- `computer-c-write-to-tape.sh` nag-aalis lang ng lumang archives na mayroon nang `.taped` markers.

Bilang resulta, pinananatili ang files na hindi pa matagumpay na naipapadala at naitatala sa tape kahit mas luma pa sa `RETENTION_HOURS` (default `72`).
Sa Computer B, ang lokal na cleanup ay nangangailangan ng lokal na `.taped` markers (halimbawa mula sa sync-back step o manual confirmation process).
Sa Computer C, ang retention age ay sinusukat mula sa `.taped` marker modification time (karaniwang itinatakda sa oras ng matagumpay na tape write).

## Mga Diyagram ng Pipeline

- [Mga Mermaid sequence at state diagram ng A/B/C](pipeline-diagrams/README.tl.md)
