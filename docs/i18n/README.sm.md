# FreeBSDOpenBSDTapeOps (Gagana Samoa)

O ni script shell felagolagomaʻi e taʻitaʻi atu ai i gaioiga masani o le lipine maneta e faaaogā ai `mt` ma `tar`.

## Faasino Upu o Faamaumauga Gagana

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


## Script

| Script | OS taulaʻi |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

E faatino e script uma e lua le faasologa lava e tasi o gaioiga:

1. Fesili i le tagata faaaogā e faʻamaonia ua uta le lipine.
2. Toe faavili le lipine i le amataga.
3. Lolomi le tulaga o le lipine.
4. Lisi mea o loo i archive i tulaga faila 0, 1, 2, ma le 3 e ala i le `tar t`.
5. Ave le lipine i le tulaga offline.

E malolo laʻititi laasaga taʻitasi ma faatali le tagata faaaogā e oomi le **Enter** a o leʻi faaauau, ma avea ai script nei ma mea e talafeagai mo ni faaaliga felagolagomaʻi po o ni savaliga taiala.

## Eseesega i le Va o Script e Lua

### 1. Ala o le masini lipine

O nei script e taulaʻi i node eseese o masini lipine:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

O ia mea uma e lua o node masini e lē toe faavili otometi (o le prefiksi `n`), o lea e tumau ai le tulaga o le lipine i le va o poloaiga ma e pulea manino e script le faatulagaga e ala i `mt rewind` ma `mt fsf`.

### 2. Laasaga o le utaina o le lipine

- **FreeBSD**: E tuuina atu `mt -f /dev/nsa0 load` i le amataga e uta ai faamekanika le cartridge o le lipine i totonu o le drive a o leʻi toe faavili.
- **OpenBSD**: E faamisi le poloaiga `load` ona e lē lagolagoina e le `mt(1)` a OpenBSD se subcommand `load`. E manatu le script a OpenBSD ua uma ona iai le lipine i le drive ma e alu saʻo loa i le toe faavili.

## Script o le Paipa Log a le OpenBSD A-i-B-i-C

O le faasinoala `scripts/` e maua ai script mo le tulaga lea e talia ai e le Komepiuta B OpenBSD ni ulufale rsyslog mai le Komepiuta A, teu faaputuga i aso taʻitasi, auina atu i se tasi o ni server Komepiuta C, ma tusi e le Komepiuta C i luga o le lipine.

| Script | Faamoemoe |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Fausia se log ua feliuliuaʻi i itula taʻitasi mai le faila ulufale rsyslog o loo galue i le Komepiuta B. |
| `scripts/computer-b-daily-archive.sh` | Fusi faatasi le aso e tasi (`YYYYMMDD`) o log i itula taʻitasi i se archive `.tar.gz` e iai le va o taimi i luga o le Komepiuta B, ma aveese le itula o loo iai nei e ʻalofia ai feteenaʻiga o tusitusiga o loo ola. |
| `scripts/computer-b-send-archives.sh` | Auina atu archive i aso taʻitasi e leʻi auina (`.tar.gz` ma le `.tar.gz.enc` filifiliga) mai le Komepiuta B i se server Komepiuta C e tasi pe sili atu e ala i `scp`. |
| `scripts/computer-c-receive-archives.sh` | Faamaonia archive plaintext o loo ulufale mai ma tuu archive plaintext po o encrypted i le laina mo le lipine. |
| `scripts/computer-c-write-to-tape.sh` | Tusi archive plaintext po o encrypted ua i le laina i luga o le lipine, siaki le avanoa, faaopoopo ma le saogalemu, ma faailogaina ua puʻeina. |
| `scripts/computer-c-inventory-tape.sh` | Lolomi se table-of-contents o le lipine i le file marker ina ia mafai e le au faagaoioi ona vave saili archive. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Suʻe tulaga faila o le lipine mo le archive ua talosagaina, tatala le encryption pe a manaʻomia, ma sefe faamaumauga ua toe maua i se faila. |
| `scripts/test-computer-a-b-c-integration.sh` | Faatino se suega tuufaatasi i le lotoifale A→B→C e mautū (e aofia ai ma le toe maua mai i le lipine) e lē faalagolago i le taimi moni o le uati. |

Faasologa masani:

- Tamoe `computer-b-hourly-rotate.sh` i itula taʻitasi (cron i luga o B).
- Tamoe `computer-b-daily-archive.sh` faatasi i le aso (cron i luga o B).
- Tamoe `computer-b-send-archives.sh` pe a uma ona faia le archive (cron i luga o B).
- Tamoe `computer-c-receive-archives.sh` i ni taimi masani i luga o C.
- Tamoe `computer-c-write-to-tape.sh` i ni taimi masani i luga o C ma le masini lipine saʻo.
- Tamoe `computer-c-inventory-tape.sh` i luga o C pe a e manaomia se table-of-contents marker-by-marker.
- Tamoe `computer-c-restore-archive-from-tape.sh` i luga o C pe a e manaomia ona toe maua se archive patino mo le siakiina.

E lafo foʻi e script uma o le paipa ni feʻau faagaioiga i le syslog e ala i le `logger` (mo se faataitaiga, e iloa atu i rsyslog/journaling) faaopoopo i le output a le console.

### Auina atu i server e tele mai le Komepiuta B

E lagolagoina e `computer-b-send-archives.sh` le tulaga server e tasi ma le tulaga server e tele:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Filifiliga mo le filifilia o server i le itu client:

- Tuu atu se server e tasi i arguments e loka ai i se Komepiuta C e tasi.
- Tuu atu ni server e tele e faataga ai fallback.
- Seti `PREFERRED_SERVER=user@host` e filifili ai se server patino e tasi mai le lisi ua tuuina atu.

Filifiliga mo le taulimaina o le busy i le Komepiuta B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): faila marker e siaki i le itu mamao.
- `BUSY_RETRY_SECONDS` (default: `60`): taimi e faatali ai i le va o toe taumafaiga a o busy le server.
- `BUSY_MAX_RETRIES` (default: `10`): aofaiga maualuga o toe taumafaiga mo server taʻitasi.

### Faailoaina o le tulaga busy mai le Komepiuta C

E faia e `computer-c-write-to-tape.sh` se busy marker a o tusi archive i luga o le lipine ma aveese pe a filemu.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Faasino `REMOTE_BUSY_MARKER` i le Komepiuta B i le nofoaga marker o loo faaaogā e le Komepiuta C.

### Saogalemu o le lipine ma le amio o le faaopoopo i le Komepiuta C

A o leʻi tusia archive taʻitasi, e siaki e `computer-c-write-to-tape.sh` le avanoa o le lipine po o le masini ma e manaʻomia a itiiti ifo:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Fesuiaiga talafeagai:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override mo se avanoa ua iloa)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (faataga le tusitusi pe a lē mafai ona iloa le avanoa)

Mo masini lipine moni, e saili le tusitala i le iʻuga o faamaumauga (`mt eom`/`mt eod`) a o leʻi tusia, o lea e faaopoopo ai archive e tele nai lo le toe soloia o mea sa i luga o le lipine muamua.

### Timestamp e faigofie ona faitau i igoa faila

- O igoa o log i itula taʻitasi e pei o lenei: `rsyslog-2026-06-01T1600.log`
- O igoa o archive i aso taʻitasi e pei o lenei: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

E faavae le va o archive i aso taʻitasi i faila itula muamua ma mulimuli na aofia moni i totonu o le archive.
Ua fuafuaina nei igoa ina ia faigofie ona faitau e tagata o loo suʻeina faamalama o aso po o taimi o mea na tutupu.
Ua aveese ma le loto i ai le itula o loo iai nei mai le fausiaina o archive ina ia lē auina atu tusitusiga o loo galue pea.

### Encryption filifiliga a OpenSSL mo archive i aso taʻitasi

E mafai e `computer-b-daily-archive.sh` ona encrypt archive i OpenSSL pe a uma ona faia le tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` mo symmetric encryption (`openssl enc`, cipher default `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` mo recipient-certificate encryption (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` e filifili ai le cipher OpenSSL mo key-file ma certificate modes uma e lua (default: `aes-256-gcm`).

E tasi lava le tasi o nei filifiliga e mafai ona seti i le taimi e tasi. O output ua encrypted e faaaogā `.tar.gz.enc`.
Mo le saogalemu, e teena e le script filifiliga cipher vaivai po o mea e lē o ni AEAD ma e manaʻomia ciphers o le vasega GCM/poly1305.

### Toe maua archive mai le lipine i le Komepiuta C

Faaaogā `computer-c-restore-archive-from-tape.sh` e saili ai se archive patino e ala i le suʻeina o faila o le lipine i le faasologa mai le amataga:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Mo igoa archive e pei o `rsyslog-<start>_to_<end>.tar.gz` (po o `.tar.gz.enc`), e iloa e le script le fetaui saʻo e ala i le siaki pe o iai faila itula o tuaoi i totonu o le payload ua toe maua.
- Afai e ese lau faiga o igoa archive, seti `TARGET_MEMBER_GLOB` i se shell pattern e fetaui ma se member e tatau ona i totonu o le archive.
- Afai ua encrypted se archive, tuu mai tulaga decryption pe a manaʻomia:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetric `openssl enc` mode; default decrypt cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` ma `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME decrypt mode)

E tusia le output ua toe maua o se faila `.tar.gz` plaintext ina ia mafai ona suʻesuʻeina i meafaigaluega e pei o `tar -tzf`.

### Lisi table-of-contents o le lipine i le Komepiuta C

Faaaogā `computer-c-inventory-tape.sh` e lolomi ai se table-of-contents marker-by-marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

O koluma o le output e aofia ai:

- `file_marker`: le tulaga file marker o le lipine e amata mai i le zero
- `status`: `ok`, `decrypted`, po o `unreadable`
- `encrypted`: pe sa manaʻomia le decryption e asiasia ai le entry (`yes`/`no`)
- `archive_hint`: le igoa e pei o se archive ua fuafuaina pe a mafai ona iloa tuaoi
- `first_member` / `last_member`: le first ma le last tar members na vaaia i lena marker
- `member_count`: le numera o tar members na maua i lena marker
- `bytes`: raw bytes na faitau i lena marker

E mafai ai e se operator ona iloa le marker index e tatau ona sailia (`mt fsf <N>`) a o leʻi faia galuega toe maua.

### Suega tuufaatasi A/B/C e mautū

Faaaogā `scripts/test-computer-a-b-c-integration.sh` e faʻamaonia ai le tuufaatasiga pito-i-le-pito o Komepiuta A, B, ma C tusa lava po o le ā le taimi ua alu:

```sh
scripts/test-computer-a-b-c-integration.sh
```

O lenei script:

1. E faataitai le tusi log a A.
2. E tamoe le rotation a B ma le fausiaina o archive i aso taʻitasi.
3. E faataitai le transfer i le incoming a C.
4. E tamoe le receive a C ma le write-to-tape.
5. E toe maua le archive mai le lipine ma faʻamaonia le content.

E faaaogā se faailoga aso tumau (`TEST_DAY_STAMP`, default `20260101`) ina ia toe fai pea le amio ma lē fusifusia i le aso po o le taimi o loo iai nei.

### Taofia mo le 72 itula ma le saogalemu mo faamaumauga e lē o faʻamaonia

Ua avea nei ma default i script se faamalama taofia e 72 itula:

- `computer-b-hourly-rotate.sh` e naʻo le aveese o log itula tuai pe a iai se marker faʻamaoniga `.taped` faalotoifale e fetaui.
- `computer-b-send-archives.sh` e naʻo le aveese o archive faalotoifale tuai pe a iai uma marker faʻamaoniga `.sent` ma `.taped` faalotoifale.
- `computer-c-write-to-tape.sh` e naʻo le aveese o archive tuai ua uma ona iai marker `.taped`.

O lona uiga, o faila e leʻi auina atu ma faamauina ma le manuia i le lipine o loo taofia pea tusa pe ua matua atu nai lo `RETENTION_HOURS` (default `72`).
I le Komepiuta B, e manaʻomia e le faamamāina faalotoifale ni marker `.taped` faalotoifale (mo se faataitaiga mai se laasaga sync-back po o se faagasologa faʻamaoniga tusi lesona).
I le Komepiuta C, e fuaina le matua o le taofia mai le taimi o suiga o le marker `.taped` (e masani ona seti i le taimi e manuia ai le tusi i le lipine).

## Ata o le paipa

- [Ata Mermaid o le faasologa ma tulaga mo A/B/C](pipeline-diagrams/README.sm.md)
