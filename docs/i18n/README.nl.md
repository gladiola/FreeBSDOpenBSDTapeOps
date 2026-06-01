# FreeBSDOpenBSDTapeOps (Nederlands)

Interactieve shellscripts die veelvoorkomende bewerkingen met magneetbanden doorlopen met `mt` en `tar`.

## Taaldocumentatie-index

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

| Script | Doel-OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Beide scripts voeren dezelfde reeks bewerkingen uit:

1. Vraag de gebruiker te bevestigen dat de tape is geladen.
2. Spoel de tape terug.
3. Druk de tapestatus af.
4. Geef de inhoud weer van archieven op bestandsposities 0, 1, 2 en 3 met `tar t`.
5. Zet de tape offline.

Elke stap pauzeert en wacht tot de gebruiker op **Enter** drukt voordat wordt doorgegaan, waardoor de scripts geschikt zijn als interactieve demonstraties of begeleide walkthroughs.

## Verschillen tussen de twee scripts

### 1. Pad van het tapeapparaat

De scripts richten zich op verschillende apparaatknooppunten voor tape:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Beide zijn apparaatknooppunten zonder automatische rewind (het voorvoegsel `n`), zodat de tapepositie tussen opdrachten behouden blijft en de scripts de positionering expliciet regelen met `mt rewind` en `mt fsf`.

### 2. Stap voor het laden van de tape

- **FreeBSD**: Voert bij het opstarten `mt -f /dev/nsa0 load` uit om de tapecartridge mechanisch in het station te laden voordat wordt teruggespoeld.
- **OpenBSD**: Slaat de opdracht `load` over omdat OpenBSD's `mt(1)` geen `load`-subopdracht ondersteunt. Het OpenBSD-script gaat ervan uit dat de tape al in het station aanwezig is en gaat direct verder met terugspoelen.

## OpenBSD A-naar-B-naar-C-logpijplijnscripts

De map `scripts/` bevat scripts voor het scenario waarin OpenBSD Computer B rsyslog-vermeldingen van Computer A ontvangt, deze dagelijks bundelt, ze naar een van meerdere Computer C-servers verzendt en Computer C ze naar tape schrijft.

| Script | Doel |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Maakt een elk uur geroteerd logbestand van het actieve rsyslog-invoerbestand op Computer B. |
| `scripts/computer-b-daily-archive.sh` | Bundelt één dag (`YYYYMMDD`) aan uurlogs in een `.tar.gz`-archief met tijdbereik op Computer B, waarbij het huidige uur wordt uitgesloten om conflicten met actieve schrijfbewerkingen te voorkomen. |
| `scripts/computer-b-send-archives.sh` | Verzendt nog niet verzonden dagelijkse archieven (`.tar.gz` en optioneel `.tar.gz.enc`) van Computer B naar een of meer Computer C-servers via `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valideert binnenkomende niet-versleutelde archieven en zet niet-versleutelde/versleutelde archieven in de wachtrij voor tape. |
| `scripts/computer-c-write-to-tape.sh` | Schrijft niet-versleutelde of versleutelde archieven uit de wachtrij naar tape, controleert de ruimte, voegt veilig toe en markeert ze als vastgelegd. |
| `scripts/computer-c-inventory-tape.sh` | Drukt een tape-inhoudsopgave per bestandsmarkering af zodat operators archieven snel kunnen vinden. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Scant bestandsposities op tape op een gevraagd archief, ontsleutelt indien nodig en slaat herstelde gegevens op in een bestand. |
| `scripts/test-computer-a-b-c-integration.sh` | Voert een deterministische lokale A→B→C-integratietest uit (inclusief herstel vanaf tape) die niet afhankelijk is van kloktijd. |

Gebruikelijke planning:

- Voer `computer-b-hourly-rotate.sh` elk uur uit (cron op B).
- Voer `computer-b-daily-archive.sh` één keer per dag uit (cron op B).
- Voer `computer-b-send-archives.sh` uit na het maken van het archief (cron op B).
- Voer `computer-c-receive-archives.sh` periodiek uit op C.
- Voer `computer-c-write-to-tape.sh` periodiek uit op C met het juiste tapeapparaat.
- Voer `computer-c-inventory-tape.sh` uit op C wanneer u een inhoudsopgave per markering nodig hebt.
- Voer `computer-c-restore-archive-from-tape.sh` uit op C wanneer u een specifiek archief voor inspectie moet herstellen.

Alle pijplijnscripts sturen naast console-uitvoer ook operationele berichten naar syslog via `logger` (bijvoorbeeld zichtbaar via rsyslog/journaling).

### Verzending naar meerdere servers vanaf Computer B

`computer-b-send-archives.sh` ondersteunt zowel de modus met één server als de modus met meerdere servers:

- Enkele server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Meerdere servers: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opties voor serverselectie aan clientzijde:

- Geef één server op in de argumenten om vast te zetten op één Computer C.
- Geef meerdere servers op om uitwijking mogelijk te maken.
- Stel `PREFERRED_SERVER=user@host` in om één specifieke server uit de opgegeven lijst te kiezen.

Opties voor afhandeling van bezet-status op Computer B:

- `REMOTE_BUSY_MARKER` (standaard: `.busy`): markerbestand dat aan de externe zijde wordt gecontroleerd.
- `BUSY_RETRY_SECONDS` (standaard: `60`): wachttijd tussen nieuwe pogingen terwijl de server bezet is.
- `BUSY_MAX_RETRIES` (standaard: `10`): maximaal aantal nieuwe pogingen per server.

### Publicatie van bezet-status vanaf Computer C

`computer-c-write-to-tape.sh` maakt een bezet-marker aan terwijl archieven actief naar tape worden geschreven en verwijdert die wanneer het script niet actief is.

- `BUSY_MARKER` (standaard: `<received_dir>/.busy`)

Wijs `REMOTE_BUSY_MARKER` op Computer B naar de markerlocatie die door Computer C wordt gebruikt.

### Tapeveiligheid en append-gedrag op Computer C

Voordat elk archief wordt geschreven, controleert `computer-c-write-to-tape.sh` de beschikbare tape-/apparaatcapaciteit en vereist minimaal:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevante variabelen:

- `TAPE_SAFETY_MARGIN_BYTES` (standaard: `10485760`)
- `TAPE_AVAILABLE_BYTES` (overschrijving voor bekende beschikbare ruimte)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (staat schrijven toe als de ruimte niet kan worden gedetecteerd)

Bij echte tapeapparaten zoekt de schrijver vóór het schrijven naar het einde van de data (`mt eom`/`mt eod`), zodat meerdere archieven worden toegevoegd in plaats van eerdere tape-inhoud te overschrijven.

### Menselijk leesbare tijdstempels in bestandsnamen

- Uurlogs krijgen namen zoals: `rsyslog-2026-06-01T1600.log`
- Dagelijkse archieven krijgen namen zoals: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Dagelijkse archiefbereiken zijn gebaseerd op de daadwerkelijke eerste en laatste uurbestanden die in het archief zijn opgenomen.
Deze namen zijn bedoeld om leesbaar te zijn voor mensen die zoeken naar gebeurtenisvensters op datum/tijd.
Het huidige uur wordt bewust uitgesloten van het maken van archieven zodat actieve schrijfbewerkingen niet worden verzonden.

### Optionele OpenSSL-versleuteling voor dagelijkse archieven

`computer-b-daily-archive.sh` kan archieven met OpenSSL versleutelen nadat het tarball is gemaakt:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` voor symmetrische versleuteling (`openssl enc`, standaard cipher `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` voor versleuteling met een ontvangerscertificaat (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` om de OpenSSL-cipher te kiezen voor zowel de sleutelbestand- als certificaatmodus (standaard: `aes-256-gcm`).

Slechts één van deze opties mag tegelijk worden ingesteld. Versleutelde uitvoer gebruikt `.tar.gz.enc`.
Om veiligheidsredenen weigert het script zwakke of niet-AEAD-cipherkeuzes en vereist het ciphers uit de GCM/poly1305-klasse.

### Archiefherstel van tape op Computer C

Gebruik `computer-c-restore-archive-from-tape.sh` om een specifiek archief te vinden door vanaf het begin op volgorde door tapebestanden te zoeken:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Voor archiefnamen zoals `rsyslog-<start>_to_<end>.tar.gz` (of `.tar.gz.enc`) identificeert het script de juiste overeenkomst door te controleren of de grens-uurbestanden aanwezig zijn in de herstelde payload.
- Als uw archiefnaamgeving anders is, stel `TARGET_MEMBER_GLOB` dan in op een shellpatroon dat overeenkomt met een onderdeel dat in het archief aanwezig moet zijn.
- Als een archief versleuteld is, geef dan waar nodig decryptie-instellingen op:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetrische `openssl enc`-modus; standaard decryptiecipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` en `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-decryptiemodus)

De herstelde uitvoer wordt geschreven als een niet-versleuteld `.tar.gz`-bestand zodat die kan worden geïnspecteerd met hulpmiddelen zoals `tar -tzf`.

### Tape-inventaris met inhoudsopgave op Computer C

Gebruik `computer-c-inventory-tape.sh` om een inhoudsopgave per markering af te drukken:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

De uitvoerkolommen omvatten:

- `file_marker`: nulgebaseerde positie van de tape-bestandsmarkering
- `status`: `ok`, `decrypted` of `unreadable`
- `encrypted`: of decryptie nodig was om de vermelding te inspecteren (`yes`/`no`)
- `archive_hint`: afgeleide archiefachtige naam wanneer grenzen kunnen worden herkend
- `first_member` / `last_member`: eerste en laatste tar-onderdelen die in die markering zijn gezien
- `member_count`: aantal tar-onderdelen dat in die markering is gevonden
- `bytes`: ruwe bytes die op die markering zijn gelezen

Hiermee kan een operator de markerindex bepalen waarnaar moet worden gezocht (`mt fsf <N>`) vóór herstelbewerkingen.

### Deterministische A/B/C-integratietest

Gebruik `scripts/test-computer-a-b-c-integration.sh` om de end-to-end-integratie van Computers A, B en C te valideren, ongeacht verstreken tijd:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Dit script:

1. Simuleert dat A logs schrijft.
2. Voert B-rotatie en het maken van een dagelijks archief uit.
3. Simuleert overdracht naar C incoming.
4. Voert C receive + write-to-tape uit.
5. Herstelt het archief vanaf tape en valideert de inhoud.

Het gebruikt een vaste dagstempel (`TEST_DAY_STAMP`, standaard `20260101`) zodat het gedrag herhaalbaar is en niet aan de huidige datum/tijd is gekoppeld.

### 72-uursretentie met veiligheid voor niet-bevestigde gegevens

De scripts gebruiken nu standaard een retentievenster van 72 uur:

- `computer-b-hourly-rotate.sh` verwijdert oude uurlogs alleen wanneer er een overeenkomende lokale `.taped`-bevestigingsmarker bestaat.
- `computer-b-send-archives.sh` verwijdert oude lokale archieven alleen wanneer zowel `.sent`- als lokale `.taped`-bevestigingsmarkers bestaan.
- `computer-c-write-to-tape.sh` verwijdert alleen oude archieven die al `.taped`-markers hebben.

Daardoor worden bestanden die nog niet succesvol zijn verzonden en op tape zijn vastgelegd behouden, zelfs wanneer ze ouder zijn dan `RETENTION_HOURS` (standaard `72`).
Op Computer B vereist lokale opschoning lokale `.taped`-markers (bijvoorbeeld vanuit een sync-back-stap of een handmatig bevestigingsproces).
Op Computer C wordt de retentieouderdom gemeten vanaf de wijzigingstijd van de `.taped`-marker (normaal ingesteld op het moment van succesvol schrijven naar tape).
