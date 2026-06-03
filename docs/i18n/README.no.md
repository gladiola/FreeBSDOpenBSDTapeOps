# FreeBSDOpenBSDTapeOps (Norsk)

Interaktive skallskript som går gjennom vanlige operasjoner med magnetbånd ved hjelp av `mt` og `tar`.

## Indeks for språkdokumentasjon

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


## Scripts

| Script | Mål-OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Begge skriptene utfører samme operasjonsrekkefølge:

1. Be brukeren bekrefte at båndet er lastet inn.
2. Spol båndet tilbake.
3. Skriv ut båndstatusen.
4. List innholdet i arkiver på filposisjonene 0, 1, 2 og 3 ved hjelp av `tar t`.
5. Sett båndet offline.

Hvert steg pauser og venter på at brukeren trykker **Enter** før det fortsetter, noe som gjør skriptene egnet som interaktive demonstrasjoner eller veiledede gjennomganger.

## Forskjeller mellom de to skriptene

### 1. Sti til båndenhet

Skriptene bruker ulike enhetsnoder for bånd:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Begge er enhetsnoder uten automatisk tilbakespoling (prefikset `n`), så båndposisjonen bevares mellom kommandoer, og skriptene styrer posisjoneringen eksplisitt med `mt rewind` og `mt fsf`.

### 2. Steg for innlasting av bånd

- **FreeBSD**: Kjører `mt -f /dev/nsa0 load` ved oppstart for mekanisk å laste båndkassetten inn i stasjonen før tilbakespoling.
- **OpenBSD**: Hopper over kommandoen `load` fordi OpenBSDs `mt(1)` ikke støtter en `load`-underkommando. OpenBSD-skriptet antar at båndet allerede er i stasjonen og går direkte videre til tilbakespoling.

## OpenBSD A-til-B-til-C-loggpipelineskript

Katalogen `scripts/` inneholder skript for scenariet der OpenBSD Computer B mottar rsyslog-oppføringer fra Computer A, samler dem daglig, sender dem til en av flere Computer C-servere, og Computer C skriver dem til bånd.

| Script | Formål |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Oppretter en timevis rotert logg fra den aktive rsyslog-inndatafilen på Computer B. |
| `scripts/computer-b-daily-archive.sh` | Samler én dag (`YYYYMMDD`) med timeloger i et tidsavgrenset `.tar.gz`-arkiv på Computer B, og utelater den nåværende timen for å unngå konflikter med aktive skrivinger. |
| `scripts/computer-b-send-archives.sh` | Sender usendte daglige arkiver (`.tar.gz` og valgfritt `.tar.gz.enc`) fra Computer B til én eller flere Computer C-servere over `scp`. |
| `scripts/computer-c-receive-archives.sh` | Validerer innkommende ukrypterte arkiver og køer ukrypterte/krypterte arkiver for bånd. |
| `scripts/computer-c-write-to-tape.sh` | Skriver kølagte ukrypterte eller krypterte arkiver til bånd, kontrollerer plass, legger til trygt og markerer dem som registrert. |
| `scripts/computer-c-inventory-tape.sh` | Skriver ut en innholdsfortegnelse for bånd markør for markør slik at operatører raskt kan finne arkiver. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Skanner båndets filposisjoner etter et forespurt arkiv, dekrypterer ved behov og lagrer gjenopprettede data i en fil. |
| `scripts/test-computer-a-b-c-integration.sh` | Kjører en deterministisk lokal A→B→C-integrasjonstest (inkludert gjenoppretting fra bånd) som ikke er avhengig av faktisk klokketid. |

Typisk planlegging:

- Kjør `computer-b-hourly-rotate.sh` hver time (cron på B).
- Kjør `computer-b-daily-archive.sh` én gang per dag (cron på B).
- Kjør `computer-b-send-archives.sh` etter at arkivet er opprettet (cron på B).
- Kjør `computer-c-receive-archives.sh` periodisk på C.
- Kjør `computer-c-write-to-tape.sh` periodisk på C med riktig båndenhet.
- Kjør `computer-c-inventory-tape.sh` på C når du trenger en innholdsfortegnelse markør for markør.
- Kjør `computer-c-restore-archive-from-tape.sh` på C når du trenger å gjenopprette et bestemt arkiv for inspeksjon.

Alle pipelineskriptene sender også driftsmeldinger til syslog via `logger` (for eksempel synlige gjennom rsyslog/journaling) i tillegg til konsollutdata.

### Flerserver-sending fra Computer B

`computer-b-send-archives.sh` støtter både enkeltservermodus og flerservermodus:

- Enkeltserver: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Flerserver: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Alternativer for servervalg på klientsiden:

- Oppgi én server i argumentene for å låse til én bestemt Computer C.
- Oppgi flere servere for å tillate reservevalg.
- Sett `PREFERRED_SERVER=user@host` for å velge én spesifikk server fra listen som er oppgitt.

Alternativer for håndtering av opptatt-status på Computer B:

- `REMOTE_BUSY_MARKER` (standard: `.busy`): markørfil som kontrolleres på den eksterne siden.
- `BUSY_RETRY_SECONDS` (standard: `60`): ventetid mellom nye forsøk mens serveren er opptatt.
- `BUSY_MAX_RETRIES` (standard: `10`): maksimalt antall nye forsøk per server.

### Publisering av opptatt-status fra Computer C

`computer-c-write-to-tape.sh` oppretter en opptatt-markør mens arkiver aktivt skrives til bånd og fjerner den når systemet er ledig.

- `BUSY_MARKER` (standard: `<received_dir>/.busy`)

Pek `REMOTE_BUSY_MARKER` på Computer B til markørplasseringen som brukes av Computer C.

### Båndsikkerhet og append-atferd på Computer C

Før hvert arkiv skrives, kontrollerer `computer-c-write-to-tape.sh` tilgjengelig bånd-/enhetskapasitet og krever minst:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevante variabler:

- `TAPE_SAFETY_MARGIN_BYTES` (standard: `10485760`)
- `TAPE_AVAILABLE_BYTES` (overstyring for kjent tilgjengelig plass)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (tillater skriving hvis plass ikke kan oppdages)

For ekte båndenheter søker skriveren til slutten av data (`mt eom`/`mt eod`) før skriving, slik at flere arkiver legges til i stedet for å overskrive tidligere båndinnhold.

### Menneskelesbare tidsstempler i filnavn

- Timeloger navngis slik: `rsyslog-2026-06-01T1600.log`
- Daglige arkiver navngis slik: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Daglige arkivintervaller er basert på de faktiske første og siste timefilene som er inkludert i arkivet.
Disse navnene er ment å være lesbare for personer som skanner etter hendelsesvinduer for dato/tid.
Den nåværende timen er med vilje utelatt fra oppretting av arkiv slik at aktive skrivinger ikke overføres.

### Valgfri OpenSSL-kryptering for daglige arkiver

`computer-b-daily-archive.sh` kan kryptere arkiver med OpenSSL etter at tarballen er opprettet:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` for symmetrisk kryptering (`openssl enc`, standard cipher `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` for kryptering med mottakersertifikat (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` for å velge OpenSSL-cipher for både nøkkelfil- og sertifikatmodus (standard: `aes-256-gcm`).

Bare ett av disse alternativene kan være satt om gangen. Kryptert utdata bruker `.tar.gz.enc`.
Av sikkerhetshensyn avviser skriptet svake eller ikke-AEAD-ciphervalg og krever ciphers i GCM/poly1305-klassen.

### Arkivgjenoppretting fra bånd på Computer C

Bruk `computer-c-restore-archive-from-tape.sh` for å finne et bestemt arkiv ved å søke gjennom båndfiler i rekkefølge fra begynnelsen:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- For arkivnavn som `rsyslog-<start>_to_<end>.tar.gz` (eller `.tar.gz.enc`) identifiserer skriptet riktig treff ved å kontrollere at grense-timefilene finnes i den gjenopprettede nyttelasten.
- Hvis navngivingen av arkivene dine er annerledes, sett `TARGET_MEMBER_GLOB` til et skallmønster som matcher et medlem som må finnes i arkivet.
- Hvis et arkiv er kryptert, oppgi dekrypteringsinnstillinger ved behov:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetrisk `openssl enc`-modus; standard dekrypteringscipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` og `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-dekrypteringsmodus)

Den gjenopprettede utdatafilen skrives som en ukryptert `.tar.gz`-fil slik at den kan inspiseres med verktøy som `tar -tzf`.

### Båndinventar med innholdsfortegnelse på Computer C

Bruk `computer-c-inventory-tape.sh` for å skrive ut en innholdsfortegnelse markør for markør:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Utdata-kolonnene inkluderer:

- `file_marker`: nullbasert posisjon for båndfilmarkør
- `status`: `ok`, `decrypted` eller `unreadable`
- `encrypted`: om dekryptering var nødvendig for å inspisere oppføringen (`yes`/`no`)
- `archive_hint`: avledet arkivlignende navn når grenser kan gjenkjennes
- `first_member` / `last_member`: første og siste tar-medlem som ble sett i den markøren
- `member_count`: antall tar-medlemmer som ble funnet i den markøren
- `bytes`: rå byte lest ved den markøren

Dette lar en operatør identifisere markørindeksen det skal søkes til (`mt fsf <N>`) før gjenopprettingsoperasjoner.

### Deterministisk A/B/C-integrasjonstest

Bruk `scripts/test-computer-a-b-c-integration.sh` for å validere ende-til-ende-integrasjonen av Computers A, B og C uavhengig av forløpt tid:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Dette skriptet:

1. Simulerer at A skriver logger.
2. Kjører B-rotasjon og oppretting av daglig arkiv.
3. Simulerer overføring til C incoming.
4. Kjører C receive + write-to-tape.
5. Gjenoppretter arkivet fra bånd og validerer innholdet.

Det bruker et fast dagsstempel (`TEST_DAY_STAMP`, standard `20260101`) slik at oppførselen er repeterbar og ikke knyttet til gjeldende dato/tid.

### 72-timers oppbevaring med sikkerhet for ubekreftede data

Skriptene bruker nå som standard et oppbevaringsvindu på 72 timer:

- `computer-b-hourly-rotate.sh` fjerner bare gamle timeloger når en samsvarende lokal `.taped`-bekreftelsesmarkør finnes.
- `computer-b-send-archives.sh` fjerner bare gamle lokale arkiver når både `.sent`- og lokale `.taped`-bekreftelsesmarkører finnes.
- `computer-c-write-to-tape.sh` fjerner bare gamle arkiver som allerede har `.taped`-markører.

Som følge av dette beholdes filer som ennå ikke er vellykket overført og registrert på bånd, selv når de er eldre enn `RETENTION_HOURS` (standard `72`).
På Computer B krever lokal opprydding lokale `.taped`-markører (for eksempel fra et sync-back-trinn eller en manuell bekreftelsesprosess).
På Computer C måles oppbevaringsalderen fra endringstiden til `.taped`-markøren (normalt satt ved vellykket skriving til bånd).

## Pipeline-diagrammer

- [A/B/C Mermaid-sekvens- og tilstandsdiagrammer](pipeline-diagrams/README.no.md)
