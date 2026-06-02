# FreeBSDOpenBSDTapeOps (Afrikaans)

Interaktiewe skuldskrifte wat deur algemene magnetiese bandverrigtinge stap deur `mt` en `tar` te gebruik.

## Taaldokumentasie-indeks

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


## Skuldskrifte

| Skuldskrif | Teikenbestuurstelsel |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Beide skuldskrifte voer dieselfde reeks bewerkings uit:

1. Vra die gebruiker om te bevestig dat die band gelaai is.
2. Spoel die band terug.
3. Druk die bandstatus af.
4. Lys die inhoud van argiewe by lêerposisies 0, 1, 2 en 3 met `tar t`.
5. Neem die band vanlyn.

Elke stap pauses en wag vir die gebruiker om **Enter** te druk voordat dit voortgaan, wat die skuldskrifte geskik maak as interaktiewe demonstrasies of begeleide deurlooptoere.

## Verskille Tussen die Twee Skuldskrifte

### 1. Bandtoestelbaan

Die skuldskrifte teiken verskillende bandtoesteelnodusse:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Beide is nie-terugspoelende toesteelnodusse (die `n`-voorvoegsel), sodat die bandposisie tussen opdragte bewaar word en die skuldskrifte posisionering eksplisiet beheer met `mt rewind` en `mt fsf`.

### 2. Bandlaaiingstap

- **FreeBSD**: Stuur `mt -f /dev/nsa0 load` by opstart om die bandkassette meganies in die aandrywer te laai voor die terugspoeling.
- **OpenBSD**: Slaan die `load`-opdrag oor omdat OpenBSD se `mt(1)` nie 'n `load`-subopdrag ondersteun nie. Die OpenBSD-skuldskrif neem aan dat die band reeds in die aandrywer is en gaan direk voort na terugspoeling.

## OpenBSD A-na-B-na-C Loglynskrifte

Die `scripts/`-gids bied skuldskrifte vir die scenario waar OpenBSD-rekenaar B rsyslog-inskrywings van Rekenaar A ontvang, dit daagliks saamvoeg, dit na een van verskeie Rekenaar C-bedieners stuur, en Rekenaar C dit op band skryf.

| Skuldskrif | Doel |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Skep 'n uurlikse geroteerde log van die aktiewe rsyslog-invoerlêer op Rekenaar B. |
| `scripts/computer-b-daily-archive.sh` | Bondel een dag (`YYYYMMDD`) se uurlikse logs in 'n tydsgebaseerde `.tar.gz`-argief op Rekenaar B, met uitsluiting van die huidige uur om aktiewe-skryfkonflikte te vermy. |
| `scripts/computer-b-send-archives.sh` | Stuur ongestuurde daaglikse argiewe (`.tar.gz` en opsionele `.tar.gz.enc`) van Rekenaar B na een of meer Rekenaar C-bedieners oor `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valideer inkomende leestekstargiewe en plaas leesteks-/versleutelde argiewe in die tou vir band. |
| `scripts/computer-c-write-to-tape.sh` | Skryf getouede leesteks- of versleutelde argiewe na band, kontroleer spasie, voeg veilig by, en merk dit as opgeneem. |
| `scripts/computer-c-inventory-tape.sh` | Druk 'n band-inhoudsopgawe af per lêermerkeerder sodat operateurs argiewe vinnig kan vind. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Skandeer bandlêerposisies vir 'n gevraagde argief, dekripteer indien nodig, en stoor herstelde data in 'n lêer. |
| `scripts/test-computer-a-b-c-integration.sh` | Voer 'n deterministiese plaaslike A→B→C-integrasietoets uit (insluitend bandherstelaing) wat nie afhang van werklike tydmeting nie. |

Tipiese skedulering:

- Voer `computer-b-hourly-rotate.sh` elke uur uit (cron op B).
- Voer `computer-b-daily-archive.sh` een keer per dag uit (cron op B).
- Voer `computer-b-send-archives.sh` na argiefskepping uit (cron op B).
- Voer `computer-c-receive-archives.sh` periodiek uit op C.
- Voer `computer-c-write-to-tape.sh` periodiek uit op C met die korrekte bandtoestel.
- Voer `computer-c-inventory-tape.sh` op C uit wanneer jy 'n merkeerder-vir-merkeerder inhoudsopgawe nodig het.
- Voer `computer-c-restore-archive-from-tape.sh` op C uit wanneer jy 'n spesifieke argief vir inspeksie moet herstel.

Alle lynskrifte stuur ook bedryfsberichte na syslog via `logger` (byvoorbeeld, sigbaar deur rsyslog/joernaal) bykomend tot konsole-uitvoer.

### Multi-bediener stuur van Rekenaar B

`computer-b-send-archives.sh` ondersteun beide enkelbediener-modus en multibediener-modus:

- Enkelbediener: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multibediener: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Kliëntsydige bedienerseleksieopties:

- Verskaf een bediener in argumente om aan een Rekenaar C vas te pen.
- Verskaf verskeie bedieners om terugval toe te laat.
- Stel `PREFERRED_SERVER=user@host` om een spesifieke bediener uit die verskafde lys te kies.

Besigheidshanterings-opsies op Rekenaar B:

- `REMOTE_BUSY_MARKER` (verstek: `.busy`): merkerlêer wat aan die afgeleë kant nagegaan word.
- `BUSY_RETRY_SECONDS` (verstek: `60`): wagtyd tussen herproewe terwyl bediener besig is.
- `BUSY_MAX_RETRIES` (verstek: `10`): maksimum herproefpogings per bediener.

### Besigheidstoestandpublikasie van Rekenaar C

`computer-c-write-to-tape.sh` skep 'n besige merkeerder terwyl argiewe aktief na band geskryf word en verwyder dit wanneer dit ledig is.

- `BUSY_MARKER` (verstek: `<received_dir>/.busy`)

Wys `REMOTE_BUSY_MARKER` op Rekenaar B na die merkeerderlocatie wat deur Rekenaar C gebruik word.

### Bandveiligheid en byvoeggedrag op Rekenaar C

Voor die skryf van elke argief, kontroleer `computer-c-write-to-tape.sh` vir beskikbare band-/toesteelkapasiteit en vereis minstens:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevante veranderlikes:

- `TAPE_SAFETY_MARGIN_BYTES` (verstek: `10485760`)
- `TAPE_AVAILABLE_BYTES` (oorskryf vir bekende beskikbare spasie)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (laat skryf toe as spasie nie opgespoor kan word nie)

Vir werklike bandtoestelle soek die skrywer na einde-van-data (`mt eom`/`mt eod`) voor skryf, sodat verskeie argiewe bygevoeg word in plaas van vorige bandinhoud te oorskryf.

### Mensleesbare tydstempels in lêername

- Uurlikse logs word benoem soos: `rsyslog-2026-06-01T1600.log`
- Daaglikse argiewe word benoem soos: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Daaglikse argiefbereike is gebaseer op die werklike eerste en laaste uurlikse lêers wat in die argief ingesluit is.
Hierdie name is bedoel om leesbaar te wees vir mense wat soek na gebeurtenisdatum-/tydvensters.
Die huidige uur word doelbewus uitgesluit van argiefskepping sodat aktiewe skrywes nie gestuur word nie.

### Opsionele OpenSSL-versleuteling vir daaglikse argiewe

`computer-b-daily-archive.sh` kan argiewe met OpenSSL versleutel nadat die tarball geskep is:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` vir simmetriese versleuteling (`openssl enc`, versteksyfer `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` vir ontvanger-sertifikaatversleuteling (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` om die OpenSSL-syfer vir beide sleutellêer- en sertifikaatmodusse te kies (verstek: `aes-256-gcm`).

Slegs een van hierdie opsies kan op 'n slag ingestel word. Versleutelde uitsette gebruik `.tar.gz.enc`.
Vir veiligheid verwerp die skuldskrif swak of nie-AEAD-syferkeuses en vereis GCM/poly1305-klas-syfers.

### Argiewherstel van band op Rekenaar C

Gebruik `computer-c-restore-archive-from-tape.sh` om 'n spesifieke argief te vind deur bandlêers in volgorde vanaf die begin te deursoek:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Vir argiefname soos `rsyslog-<start>_to_<end>.tar.gz` (of `.tar.gz.enc`) identifiseer die skuldskrif die korrekte treffer deur te kontroleer dat grensuurlikse lêers teenwoordig is in die herstelde lading.
- As jou argifbenaming anders is, stel `TARGET_MEMBER_GLOB` op 'n skuilpatroon wat ooreenstem met 'n lid wat in die argief moet bestaan.
- As 'n argief versleutel is, verskaf dekripsieinstellings soos nodig:
  - `OPENSSL_DECRYPT_KEY_FILE` (simmetriese `openssl enc`-modus; verstekdekripsieryfer: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` en `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-dekripsiemodus)

Die herstelde uitvoer word geskryf as 'n leesteks-`.tar.gz`-lêer sodat dit met gereedskap soos `tar -tzf` geïnspekteer kan word.

### Band-inhoudsopgawe-inventaris op Rekenaar C

Gebruik `computer-c-inventory-tape.sh` om 'n merkeerder-vir-merkeerder inhoudsopgawe af te druk:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Die uitvoerkolomme sluit in:

- `file_marker`: nulgebaseerde bandlêermerkeerderposisie
- `status`: `ok`, `decrypted` of `unreadable`
- `encrypted`: of dekriptering nodig was om die inskrywing te inspekteer (`yes`/`no`)
- `archive_hint`: afgesluide argiefstyl-naam wanneer grense herken kan word
- `first_member` / `last_member`: eerste en laaste tar-lede wat by daardie merkeerder gesien is
- `member_count`: aantal tar-lede wat by daardie merkeerder gevind is
- `bytes`: rou grepe gelees by daardie merkeerder

Dit laat 'n operateur toe om die merkeerderindeks te identifiseer om te soek (`mt fsf <N>`) voor herstelbeweringe.

### Deterministiese A/B/C-integrasietoets

Gebruik `scripts/test-computer-a-b-c-integration.sh` om end-tot-end-integrasie van Rekenaars A, B en C te valideer ongeag verstreke tyd:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Hierdie skuldskrif:

1. Simuleer A wat logs skryf.
2. Voer B-rotasie en daaglikse argiefskeppings uit.
3. Simuleer oordrag na C se inkomende.
4. Voer C-ontvangs + skryf-na-band uit.
5. Herstel die argief van band en valideer inhoud.

Dit gebruik 'n vaste dagstempel (`TEST_DAY_STAMP`, verstek `20260101`) sodat gedrag herhaalbaar is en nie aan huidige datum/tyd gekoppel is nie.

### 72-uur behoud met veiligheid vir onbevestigde data

Die skuldskrifte gebruik nou standaard 'n 72-uur behoudsvenster:

- `computer-b-hourly-rotate.sh` verwyder slegs ou uurlikse logs wanneer 'n ooreenstemmende plaaslike `.taped`-bevestigingsmerkeerder bestaan.
- `computer-b-send-archives.sh` verwyder slegs ou plaaslike argiewe wanneer beide `.sent`- en plaaslike `.taped`-bevestigingsmerkeerders bestaan.
- `computer-c-write-to-tape.sh` verwyder slegs ou argiewe wat reeds `.taped`-merkeerders het.

As gevolg hiervan word lêers wat nog nie suksesvol na band gestuur en opgeneem is nie, behou selfs wanneer ouer as `RETENTION_HOURS` (verstek `72`).
Op Rekenaar B vereis plaaslike skoonmaak plaaslike `.taped`-merkeerders (byvoorbeeld van 'n terug-sinkronisasiestap of handmatige bevestigingsproses).
Op Rekenaar C word behoudsouderdom gemeet vanaf `.taped`-merkeerder-wysigingstyd (normaalweg ingestel by suksesvolle bandskryftyd).

## Pyplyn Diagramme

- [A/B/C Mermaid-volgorde- en toestanddiagramme](pipeline-diagrams/README.af.md)
