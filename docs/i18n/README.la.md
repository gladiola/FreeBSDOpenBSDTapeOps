# FreeBSDOpenBSDTapeOps (Latina)

Scripta shell interactiva quae operationes communes taeniae magneticae per `mt` et `tar` demonstrant.

## Index Documentorum Linguarum

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


## Scripta

| Scriptum | Systema destinatum |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Utrumque scriptum eandem seriem operationum peragit:

1. Usorem rogare ut confirmet taeniam insertam esse.
2. Taeniam ad initium revolvere.
3. Statum taeniae ostendere.
4. Contenta archivorum in positionibus 0, 1, 2, et 3 per `tar t` enumerare.
5. Taeniam in statum offline ponere.

Singuli gradus sistunt et exspectant dum usor **Enter** premit antequam pergatur; ita scripta apta sunt demonstrationibus interactivis vel ductis per gradus.

## Differentiae Inter Duo Scripta

### 1. Via machinae taeniae

Scripta ad diversos nodos machinae taeniae spectant:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Uterque est nodus non-rewinding (praefixum `n`), ideo positio taeniae inter mandata servatur et scripta positionem explicite moderantur per `mt rewind` et `mt fsf`.

### 2. Gradus ad taeniam onerandam

- **FreeBSD**: In initio mandat `mt -f /dev/nsa0 load` ut cassetta taeniae mechanice in drive imponatur ante rewind.
- **OpenBSD**: Mandatum `load` omittit quia `mt(1)` in OpenBSD submandatum `load` non sustinet. Scriptum OpenBSD praesumit taeniam iam in drive esse et statim rewind facit.

## Scripta Pipeline Log OpenBSD A-ad-B-ad-C

Directorium `scripts/` continet scripta ad casum in quo Computer B OpenBSD inscriptiones rsyslog a Computatro A accipit, eas cotidie colligit, ad unum ex pluribus servitoribus Computer C mittit, et Computer C eas in taenia scribit.

| Scriptum | Propositum |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Logum singulis horis rotatum ex activo archivo input rsyslog in Computer B creat. |
| `scripts/computer-b-daily-archive.sh` | Loga unius diei (`YYYYMMDD`) in archivum `.tar.gz` temporis intervallo definitum in Computer B conligat, hora currenti exclusa ad conflictus scripturae activae vitandos. |
| `scripts/computer-b-send-archives.sh` | Archiva cotidiana nondum missa (`.tar.gz` et optionale `.tar.gz.enc`) ex Computer B ad unum vel plures servitores Computer C per `scp` mittit. |
| `scripts/computer-c-receive-archives.sh` | Archiva plaintext incoming validat et archiva plaintext/encrypta in ordinem pro taenia ponit. |
| `scripts/computer-c-write-to-tape.sh` | Archiva plaintext vel encrypta in ordine ad taeniam scribit, spatium examinat, secure appendit, et ea scripta notat. |
| `scripts/computer-c-inventory-tape.sh` | Indicem contentorum taeniae per file marker imprimit ut operatores archiva celeriter inveniant. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Positiones file in taenia scrutatur pro archivo petito, si opus est decriptat, et data recuperata in archivum servat. |
| `scripts/test-computer-a-b-c-integration.sh` | Testem integrationis localem A→B→C deterministicam (cum recuperatione ex taenia) currit, quae a tempore horologii non pendet. |

Ordinatio usitata:

- Curre `computer-b-hourly-rotate.sh` omni hora (cron in B).
- Curre `computer-b-daily-archive.sh` semel in die (cron in B).
- Curre `computer-b-send-archives.sh` post creationem archivi (cron in B).
- Curre `computer-c-receive-archives.sh` periodicē in C.
- Curre `computer-c-write-to-tape.sh` periodicē in C cum recto apparatu taeniae.
- Curre `computer-c-inventory-tape.sh` in C cum indice marker-by-marker opus est.
- Curre `computer-c-restore-archive-from-tape.sh` in C cum archivum certum ad inspectionem recuperare debes.

Omnia scripta pipeline etiam nuntios operationales ad syslog per `logger` mittunt (exempli gratia visibiles in rsyslog/journaling) praeter output in console.

### Missio multi-servitoris ex Computer B

`computer-b-send-archives.sh` modum unius servitoris et modum multi-servitoris sustinet:

- Unus servitor: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-servitor: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Optiones selectionis servitoris in parte clientis:

- Da unum servitorem in argumentis ut ad unum Computer C figatur.
- Da plures servitores ut fallback permittatur.
- Pone `PREFERRED_SERVER=user@host` ut unum servitorem certum ex indice dato eligas.

Optiones tractationis status occupati in Computer B:

- `REMOTE_BUSY_MARKER` (defaltum: `.busy`): marker file in parte remota inspectus.
- `BUSY_RETRY_SECONDS` (defaltum: `60`): tempus expectationis inter retries dum servitor occupatus est.
- `BUSY_MAX_RETRIES` (defaltum: `10`): numerus maximus retry pro singulo servitore.

### Publicatio status occupati ex Computer C

`computer-c-write-to-tape.sh` marker occupati creat dum archiva ad taeniam active scribit et eum removet cum otiosum est.

- `BUSY_MARKER` (defaltum: `<received_dir>/.busy`)

Dirige `REMOTE_BUSY_MARKER` in Computer B ad locum marker quem Computer C adhibet.

### Securitas taeniae et ratio appendendi in Computer C

Antequam singulum archivum scribatur, `computer-c-write-to-tape.sh` capacitatem taeniae/apparatus examinat et minimum requirit:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variabiles pertinentes:

- `TAPE_SAFETY_MARGIN_BYTES` (defaltum: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override pro spatio noto disponibili)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (scripturam permittit si spatium deprehendi non potest)

Pro veris apparatibus taeniae, scriptum ad finem datorum (`mt eom`/`mt eod`) quaerit ante scripturam, ita plura archiva appenduntur potius quam vetera contenta supercribantur.

### Notae temporis hominibus faciles in nominibus file

- Loga horaria sic nominantur: `rsyslog-2026-06-01T1600.log`
- Archiva cotidiana sic nominantur: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Intervalla archivi cotidiani ex primis et ultimis file horariis revera inclusis determinantur.
Haec nomina ad lectionem humanam destinata sunt dum fenestras temporis eventuum scrutaris.
Hora currentis consulto ex creatione archivi excluditur ne scriptura activa transmittatur.

### Encryptio OpenSSL optionalis pro archivis cotidianis

`computer-b-daily-archive.sh` archiva OpenSSL post creationem tarball encryptare potest:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` pro encryptione symmetrica (`openssl enc`, cipher defaltum `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` pro encryptione per certificatum recipientis (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` ad cipher OpenSSL eligendum in modis key-file et certificati (defaltum: `aes-256-gcm`).

Una tantum ex his optionibus simul poni potest. Output encrypta `.tar.gz.enc` utuntur.
Propter securitatem scriptum ciphra debilia aut non-AEAD respuit et ciphra classis GCM/poly1305 requirit.

### Recuperatio archivi ex taenia in Computer C

Utere `computer-c-restore-archive-from-tape.sh` ut archivum certum invenias per ordinem file taeniae ab initio perscrutando:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Pro nominibus archivi ut `rsyslog-<start>_to_<end>.tar.gz` (aut `.tar.gz.enc`), scriptum rectam concordantiam agnoscit comprobando files horarias limites in payload recuperato adesse.
- Si ratio nominandi diversa est, pone `TARGET_MEMBER_GLOB` ad pattern shell quod membro necessario in archivo respondet.
- Si archivum encryptum est, da settinges decryptionis prout opus est:
  - `OPENSSL_DECRYPT_KEY_FILE` (modus symmetricae `openssl enc`; default decrypt cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` et `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (modus decryptionis S/MIME)

Output recuperata scribitur ut file `.tar.gz` plaintext ut instrumentis sicut `tar -tzf` inspici possit.

### Inventarium indicis contentorum taeniae in Computer C

Utere `computer-c-inventory-tape.sh` ut indicem contentorum marker-by-marker imprimas:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Columnae output includunt:

- `file_marker`: positio file marker taeniae a zero numerata
- `status`: `ok`, `decrypted`, aut `unreadable`
- `encrypted`: utrum decryptio ad inspectionem entry necessaria fuerit (`yes`/`no`)
- `archive_hint`: nomen generis archivi inferum cum limites agnosci possunt
- `first_member` / `last_member`: primi et ultimi membra tar in illo marker visa
- `member_count`: numerus membrorum tar in illo marker repertorum
- `bytes`: bytes crudi in illo marker lecti

Hoc operatorem iuvat ad indicem marker quaerendum (`mt fsf <N>`) ante operationes recuperationis determinandum.

### Testis integrationis A/B/C deterministica

Utere `scripts/test-computer-a-b-c-integration.sh` ad integrationem end-to-end Computatrorum A, B, et C validandam quacumque mora temporis:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Hoc scriptum:

1. Simulat A loga scribere.
2. Rotationem B et creationem archivi quotidiani currit.
3. Translationem in incoming C simulat.
4. Receptionem C et write-to-tape currit.
5. Archivum ex taenia recuperat et contentum validat.

Utitur signo diei fixo (`TEST_DAY_STAMP`, defaltum `20260101`) ut mores repetibiles sint neque ad diem/horam praesentem alligentur.

### Retentio 72 horarum cum tutela pro datis nondum confirmatis

Scripta nunc ad fenestram retentionis 72 horarum per defaltum redeunt:

- `computer-b-hourly-rotate.sh` vetera loga horaria removet tantum si congruens marker confirmationis localis `.taped` exstat.
- `computer-b-send-archives.sh` vetera archiva localia removet tantum si et marker `.sent` et marker localis `.taped` exstant.
- `computer-c-write-to-tape.sh` vetera archiva removet tantum quae iam markers `.taped` habent.

Quam ob rem files quae nondum feliciter translata et in taenia scripta sunt servantur etiam si vetustiores sunt quam `RETENTION_HOURS` (defaltum `72`).
In Computer B, purgatio localis markers locales `.taped` requirit (exempli causa ex gradu sync-back vel processu confirmationis manualis).
In Computer C, aetas retentionis ex tempore modificationis marker `.taped` metitur (plerumque tempore scripturae in taeniam feliciter peractae statuitur).

## Diagrammata cursus

- [Diagrammata ordinis et status Mermaid pro A/B/C](pipeline-diagrams/README.la.md)
