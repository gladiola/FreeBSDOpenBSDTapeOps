# FreeBSDOpenBSDTapeOps (Svenska)

Interaktiva shellskript som går igenom vanliga magnetbandsoperationer med `mt` och `tar`.

## Språkdokumentationsindex

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

Båda skripten utför samma sekvens av åtgärder:

1. Uppmana användaren att bekräfta att bandet är laddat.
2. Spola tillbaka bandet.
3. Skriv ut bandstatusen.
4. Lista innehållet i arkiv vid filpositionerna 0, 1, 2 och 3 med `tar t`.
5. Ta bandet offline.

Varje steg pausar och väntar på att användaren ska trycka på **Enter** innan det fortsätter, vilket gör skripten lämpliga som interaktiva demonstrationer eller guidade genomgångar.

## Skillnader mellan de två skripten

### 1. Sökväg till bandenheten

Skripten använder olika enhetsnoder för band:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Båda är icke-återspolande enhetsnoder (prefixet `n`), så bandpositionen bevaras mellan kommandon och skripten styr positioneringen uttryckligen med `mt rewind` och `mt fsf`.

### 2. Steg för bandladdning

- **FreeBSD**: Kör `mt -f /dev/nsa0 load` vid start för att mekaniskt ladda bandkassetten i enheten innan återspolning.
- **OpenBSD**: Hoppar över kommandot `load` eftersom OpenBSDs `mt(1)` inte stöder ett `load`-underkommando. OpenBSD-skriptet förutsätter att bandet redan finns i enheten och går direkt vidare till återspolning.

## OpenBSD A-till-B-till-C-loggpipelineskript

Katalogen `scripts/` innehåller skript för scenariot där OpenBSD Computer B tar emot rsyslog-poster från Computer A, buntar dem dagligen, skickar dem till en av flera Computer C-servrar och Computer C skriver dem till band.

| Script | Syfte |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Skapar en timvis roterad logg från den aktiva rsyslog-indatafilen på Computer B. |
| `scripts/computer-b-daily-archive.sh` | Samlar en dag (`YYYYMMDD`) med timloggar i ett tidsintervallbaserat `.tar.gz`-arkiv på Computer B, där den aktuella timmen utesluts för att undvika konflikter med aktiva skrivningar. |
| `scripts/computer-b-send-archives.sh` | Skickar osända dagliga arkiv (`.tar.gz` och valfritt `.tar.gz.enc`) från Computer B till en eller flera Computer C-servrar via `scp`. |
| `scripts/computer-c-receive-archives.sh` | Validerar inkommande okrypterade arkiv och köar okrypterade/krypterade arkiv för band. |
| `scripts/computer-c-write-to-tape.sh` | Skriver köade okrypterade eller krypterade arkiv till band, kontrollerar utrymme, lägger till säkert och markerar dem som registrerade. |
| `scripts/computer-c-inventory-tape.sh` | Skriver ut en innehållsförteckning för band per filmarkör så att operatörer snabbt kan hitta arkiv. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Söker igenom bandets filpositioner efter ett begärt arkiv, dekrypterar vid behov och sparar återställda data till en fil. |
| `scripts/test-computer-a-b-c-integration.sh` | Kör ett deterministiskt lokalt A→B→C-integrationstest (inklusive återställning från band) som inte beror på faktisk klocktid. |

Typisk schemaläggning:

- Kör `computer-b-hourly-rotate.sh` varje timme (cron på B).
- Kör `computer-b-daily-archive.sh` en gång per dag (cron på B).
- Kör `computer-b-send-archives.sh` efter att arkivet har skapats (cron på B).
- Kör `computer-c-receive-archives.sh` periodiskt på C.
- Kör `computer-c-write-to-tape.sh` periodiskt på C med rätt bandenhet.
- Kör `computer-c-inventory-tape.sh` på C när du behöver en innehållsförteckning markör för markör.
- Kör `computer-c-restore-archive-from-tape.sh` på C när du behöver återställa ett specifikt arkiv för inspektion.

Alla pipelineskript skickar dessutom driftmeddelanden till syslog via `logger` (till exempel synliga via rsyslog/journaling) utöver konsolutmatning.

### Fler-server-sändning från Computer B

`computer-b-send-archives.sh` stöder både enserverläge och flerserverläge:

- En server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Flera servrar: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Alternativ för serverval på klientsidan:

- Ange en server i argumenten för att låsa till en viss Computer C.
- Ange flera servrar för att möjliggöra reservväg.
- Sätt `PREFERRED_SERVER=user@host` för att välja en specifik server från den angivna listan.

Alternativ för hantering av upptaget läge på Computer B:

- `REMOTE_BUSY_MARKER` (standard: `.busy`): markeringsfil som kontrolleras på fjärrsidan.
- `BUSY_RETRY_SECONDS` (standard: `60`): väntetid mellan nya försök medan servern är upptagen.
- `BUSY_MAX_RETRIES` (standard: `10`): maximalt antal nya försök per server.

### Publicering av upptaget läge från Computer C

`computer-c-write-to-tape.sh` skapar en upptaget-markör medan arkiv aktivt skrivs till band och tar bort den när systemet är sysslolöst.

- `BUSY_MARKER` (standard: `<received_dir>/.busy`)

Peka `REMOTE_BUSY_MARKER` på Computer B mot markeringsplatsen som används av Computer C.

### Bandsäkerhet och append-beteende på Computer C

Innan varje arkiv skrivs kontrollerar `computer-c-write-to-tape.sh` tillgänglig kapacitet på band/enhet och kräver minst:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevanta variabler:

- `TAPE_SAFETY_MARGIN_BYTES` (standard: `10485760`)
- `TAPE_AVAILABLE_BYTES` (åsidosättning för känt tillgängligt utrymme)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (tillåter skrivning om utrymmet inte kan upptäckas)

För riktiga bandenheter söker skrivaren till data-slut (`mt eom`/`mt eod`) före skrivning, så att flera arkiv läggs till i stället för att skriva över tidigare bandinnehåll.

### Mänskligt läsbara tidsstämplar i filnamn

- Timloggar namnges så här: `rsyslog-2026-06-01T1600.log`
- Dagliga arkiv namnges så här: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Dagliga arkivintervall baseras på de faktiska första och sista timfilerna som ingår i arkivet.
Dessa namn är avsedda att vara läsbara för personer som söker efter händelsefönster för datum/tid.
Den aktuella timmen utesluts avsiktligt från arkivskapandet så att aktiva skrivningar inte överförs.

### Valfri OpenSSL-kryptering för dagliga arkiv

`computer-b-daily-archive.sh` kan kryptera arkiv med OpenSSL efter att tarballen har skapats:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` för symmetrisk kryptering (`openssl enc`, standardchiffer `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` för kryptering med mottagarcertifikat (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` för att välja OpenSSL-chiffer för både nyckelfils- och certifikatlägena (standard: `aes-256-gcm`).

Endast ett av dessa alternativ får vara satt åt gången. Krypterad utdata använder `.tar.gz.enc`.
Av säkerhetsskäl avvisar skriptet svaga eller icke-AEAD-chifferval och kräver chiffer i GCM/poly1305-klassen.

### Arkivåterställning från band på Computer C

Använd `computer-c-restore-archive-from-tape.sh` för att hitta ett specifikt arkiv genom att söka igenom bandfiler i ordning från början:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- För arkivnamn som `rsyslog-<start>_to_<end>.tar.gz` (eller `.tar.gz.enc`) identifierar skriptet rätt träff genom att kontrollera att gränstimfilerna finns i den återställda nyttolasten.
- Om din arkivnamngivning är annorlunda, sätt `TARGET_MEMBER_GLOB` till ett skal-mönster som matchar en medlem som måste finnas i arkivet.
- Om ett arkiv är krypterat, ange dekrypteringsinställningar efter behov:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetriskt `openssl enc`-läge; standardchiffer för dekryptering: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` och `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-dekrypteringsläge)

Den återställda utdatafilen skrivs som en okrypterad `.tar.gz`-fil så att den kan inspekteras med verktyg som `tar -tzf`.

### Inventering av bandets innehållsförteckning på Computer C

Använd `computer-c-inventory-tape.sh` för att skriva ut en innehållsförteckning markör för markör:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Utmatningskolumnerna omfattar:

- `file_marker`: nollbaserad position för bandfilmarkör
- `status`: `ok`, `decrypted` eller `unreadable`
- `encrypted`: om dekryptering behövdes för att inspektera posten (`yes`/`no`)
- `archive_hint`: härlett arkivliknande namn när gränser kan kännas igen
- `first_member` / `last_member`: första och sista tar-medlemmen som sågs i den markören
- `member_count`: antal tar-medlemmar som hittades i den markören
- `bytes`: råa byte som lästes vid den markören

Detta gör att en operatör kan identifiera vilket markörindex som ska sökas till (`mt fsf <N>`) före återställningsåtgärder.

### Deterministiskt A/B/C-integrationstest

Använd `scripts/test-computer-a-b-c-integration.sh` för att validera end-to-end-integrationen mellan Computers A, B och C oavsett förfluten tid:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Det här skriptet:

1. Simulerar att A skriver loggar.
2. Kör B-rotation och skapande av dagligt arkiv.
3. Simulerar överföring till C incoming.
4. Kör C receive + write-to-tape.
5. Återställer arkivet från band och validerar innehållet.

Det använder en fast dagstämpel (`TEST_DAY_STAMP`, standard `20260101`) så att beteendet är upprepningsbart och inte knutet till aktuellt datum/klockslag.

### 72 timmars retention med säkerhet för obekräftade data

Skripten använder nu som standard ett retentionsfönster på 72 timmar:

- `computer-b-hourly-rotate.sh` tar bara bort gamla timloggar när en matchande lokal `.taped`-bekräftelsemarkör finns.
- `computer-b-send-archives.sh` tar bara bort gamla lokala arkiv när både `.sent`- och lokala `.taped`-bekräftelsemarkörer finns.
- `computer-c-write-to-tape.sh` tar bara bort gamla arkiv som redan har `.taped`-markörer.

Som resultat behålls filer som ännu inte har överförts och registrerats på band med lyckat resultat, även när de är äldre än `RETENTION_HOURS` (standard `72`).
På Computer B kräver lokal städning lokala `.taped`-markörer (till exempel från ett sync-back-steg eller en manuell bekräftelseprocess).
På Computer C mäts retentionens ålder från ändringstiden för `.taped`-markören (normalt satt vid lyckad skrivning till band).

## Pipeline-diagram

- [A/B/C Mermaid-sekvens- och tillståndsdiagram](pipeline-diagrams/README.sv.md)
