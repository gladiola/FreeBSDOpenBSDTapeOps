# FreeBSDOpenBSDTapeOps (Yorùbá)

Àwọn àkọsílẹ shell tó ní ìbáṣepọ̀ pẹ̀lú oníṣe tí ń tọ́ ọ lọ nípasẹ̀ àwọn iṣẹ́ teepu oofa tó wọ́pọ̀ ní lílo `mt` àti `tar`.

## Àtòkọ Ìwé Àlàyé Èdè

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


## Àwọn Skripti

| Skripti | OS Àfojúsùn |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Àwọn skripti méjèèjì n ṣe ìtẹ̀sí àwọn iṣẹ́ kan náà:

1. Béèrè fún oníṣe láti jẹ́risi pé a ti fi teepu sínú ẹrọ.
2. Da teepu padà sí ìbẹ̀rẹ̀.
3. Ṣe àtẹ̀jáde ipo teepu.
4. Ṣe àkójọ ohun inú àwọn archive ní ipò fáìlì 0, 1, 2, àti 3 ní lílo `tar t`.
5. Gbé teepu sí ipo offline.

Ìgbésẹ̀ kọ̀ọ̀kan máa ń dúró tí ó sì ń dúró de kí oníṣe tẹ **Enter** kí ó tó tẹ̀síwájú, èyí sì jẹ́ kí àwọn skripti yẹ fún àwọn àfihàn ibáṣepọ̀ tàbí ìtòsọ́nà nípasẹ̀ ìgbésẹ̀.

## Àwọn Ìyàtọ̀ Láàárín Àwọn Skripti Méjì

### 1. Ọ̀nà ẹrọ teepu

Àwọn skripti náà ń lo àwọn node ẹrọ teepu tó yàtọ̀:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Wọ́n jẹ́ àwọn node ẹrọ tí kì í tún teepu pada (àfikún-ṣáájú `n`), nítorí náà ipò teepu máa ń dúró láàárín àwọn àṣẹ, àwọn skripti sì ń ṣàkóso ìpo náà ní kedere pẹ̀lú `mt rewind` àti `mt fsf`.

### 2. Ìgbésẹ̀ fífi teepu sínú ẹrọ

- **FreeBSD**: Ó ń ṣe `mt -f /dev/nsa0 load` nígbà ìbẹ̀rẹ̀ láti fi cartridge teepu sínú drive lọ́nà mákànìkà kí o tó da a padà sí ìbẹ̀rẹ̀.
- **OpenBSD**: Ó fo àṣẹ `load` kọjá nítorí pé `mt(1)` ti OpenBSD kò ṣe atilẹyin àṣẹ-kekere `load`. Skripti OpenBSD ń gba pé teepu ti wà nínú drive tẹ́lẹ̀, ó sì ń lọ taara sí ìgbésẹ̀ ìpadà sí ìbẹ̀rẹ̀.

## Àwọn Skripti Pipeline Log OpenBSD A-sí-B-sí-C

Àpótí `scripts/` ń pèsè àwọn skripti fún ipò tí Kọ̀ǹpútà B OpenBSD fi ń gba àwọn ìforúkọsílẹ̀ rsyslog láti Kọ̀ǹpútà A, tí ó ń kó wọn jọ lójoojúmọ́, tí ó ń fi wọ́n ránṣẹ́ sí ọ̀kan lára ọ̀pọ̀ olupin Kọ̀ǹpútà C, tí Kọ̀ǹpútà C sì ń kọ wọ́n sí teepu.

| Skripti | Ète |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Ó ń dá log tí a yí padà lọ́ọ̀rọ̀ wákàtí sílẹ̀ láti inú fáìlì ìwọlé rsyslog tí ń ṣiṣẹ́ lórí Kọ̀ǹpútà B. |
| `scripts/computer-b-daily-archive.sh` | Ó ń ko ọjọ́ kan (`YYYYMMDD`) ti àwọn log wákàtí jọ sínú archive `.tar.gz` tó ní ààlà àkókò lórí Kọ̀ǹpútà B, ní fífi wákàtí tó ń lọ lọwọlọwọ sílẹ̀ kí ìjà ìkọ̀wé tó ń lọ má bà a ṣẹlẹ̀. |
| `scripts/computer-b-send-archives.sh` | Ó ń fi àwọn archive ojoojúmọ́ tí a kò tíì rán (`.tar.gz` àti `.tar.gz.enc` àṣàyàn) rán láti Kọ̀ǹpútà B sí olupin Kọ̀ǹpútà C kan tàbí jù bẹ́ẹ̀ lọ nípasẹ̀ `scp`. |
| `scripts/computer-c-receive-archives.sh` | Ó ń jẹ́risi àwọn archive plaintext tó ń wọlé, ó sì ń fi àwọn archive plaintext tàbí encrypted sínú ìlà de teepu. |
| `scripts/computer-c-write-to-tape.sh` | Ó ń kọ àwọn archive plaintext tàbí encrypted tó wà nínú ìlà de sí teepu, ó ń ṣàyẹ̀wò àyè, ó ń fi kún un láìbàjẹ́, ó sì ń fi àmì pé a ti gbasilẹ wọn. |
| `scripts/computer-c-inventory-tape.sh` | Ó ń tẹ table-of-contents teepu jáde nípasẹ̀ file marker kí àwọn olùṣàkóso lè rí archive lọ́rẹ̀ẹ́rẹ̀. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Ó ń ṣàyẹ̀wò àwọn ipò fáìlì lórí teepu fún archive tí a béèrè, ó ń tú ìfipamọ́ àṣírí sílẹ̀ bí ó bá yẹ, ó sì ń fi data tí a gba padà pamọ́ sínú fáìlì. |
| `scripts/test-computer-a-b-c-integration.sh` | Ó ń ṣiṣẹ́ ìdánwò ìṣọ̀kan A→B→C ìbílẹ̀ tó dájú (pẹ̀lú ìmúpadàbọ̀ teepu) tí kò dá lórí àkókò aago. |

Ìṣètò àkókò tó wọ́pọ̀:

- Ṣe `computer-b-hourly-rotate.sh` ní gbogbo wákàtí (cron lórí B).
- Ṣe `computer-b-daily-archive.sh` lẹ́ẹ̀kan lójoojúmọ́ (cron lórí B).
- Ṣe `computer-b-send-archives.sh` lẹ́yìn ìdásílẹ̀ archive (cron lórí B).
- Ṣe `computer-c-receive-archives.sh` ní àkókò àkókò lórí C.
- Ṣe `computer-c-write-to-tape.sh` ní àkókò àkókò lórí C pẹ̀lú ẹrọ teepu tó tọ́.
- Ṣe `computer-c-inventory-tape.sh` lórí C nígbà tí o bá nílò table-of-contents marker-ní-marker.
- Ṣe `computer-c-restore-archive-from-tape.sh` lórí C nígbà tí o bá nílò láti gba archive kan pàtó padà fún àyẹ̀wò.

Gbogbo àwọn skripti pipeline tún ń fi àwọn ìfiránṣẹ́ iṣiṣẹ́ ránṣẹ́ sí syslog nípasẹ̀ `logger` (fún àpẹẹrẹ, tí a lè rí ní rsyslog/journaling) ní àfikún sí àbájáde console.

### Fífi ránṣẹ́ sí ọ̀pọ̀ olupin láti Kọ̀ǹpútà B

`computer-b-send-archives.sh` ń ṣe atilẹyin fún mejeeji ipo olupin kan ṣoṣo àti ipo olupin púpọ̀:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Àwọn àṣàyàn yíyan olupin ní ẹgbẹ́ client:

- Pese olupin kan nínú arguments láti dì í mọ́ Kọ̀ǹpútà C kan ṣoṣo.
- Pese ọ̀pọ̀ olupin láti jẹ́ kí fallback lè ṣiṣẹ́.
- Ṣètò `PREFERRED_SERVER=user@host` láti yan olupin pàtó kan nínú àkójọ tí a pèsè.

Àwọn àṣàyàn mímú ipo busy lórí Kọ̀ǹpútà B:

- `REMOTE_BUSY_MARKER` (àìyẹ́padà: `.busy`): fáìlì àmì tí a ń ṣàyẹ̀wò ní ẹgbẹ́ jijìn.
- `BUSY_RETRY_SECONDS` (àìyẹ́padà: `60`): àkókò ìdúró láàárín àwọn ìgbìyànjú tuntun nígbà tí olupin bá busy.
- `BUSY_MAX_RETRIES` (àìyẹ́padà: `10`): iye tó pọ̀jùlọ fún àwọn ìgbìyànjú tuntun fún olupin kọ̀ọ̀kan.

### Ìtẹ̀jáde ipo busy láti Kọ̀ǹpútà C

`computer-c-write-to-tape.sh` ń dá busy marker sílẹ̀ nígbà tí ó bá ń kọ archive sí teepu gan-an, ó sì máa ń yọ ọ́ kúrò nígbà tí kò bá sí iṣẹ́.

- `BUSY_MARKER` (àìyẹ́padà: `<received_dir>/.busy`)

Tọ́ka `REMOTE_BUSY_MARKER` lórí Kọ̀ǹpútà B sí ibi marker tí Kọ̀ǹpútà C ń lò.

### Ààbò teepu àti ìwà fífikún sí òpin lórí Kọ̀ǹpútà C

Kí a tó kọ archive kọ̀ọ̀kan, `computer-c-write-to-tape.sh` máa ń ṣàyẹ̀wò agbára teepu tàbí ẹrọ tó wà, ó sì nílò ó kéré tán:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Àwọn variable tó ṣe pàtàkì:

- `TAPE_SAFETY_MARGIN_BYTES` (àìyẹ́padà: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override fún àyè tó dájú pé ó wà)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ó ń jẹ́ kí a kọ bí a kò bá lè mọ àyè)

Fún àwọn ẹrọ teepu gidi, onkọ̀wé máa ń lọ sí òpin data (`mt eom`/`mt eod`) kíkọ tó bẹ̀rẹ̀, nítorí náà a máa ń fi ọ̀pọ̀ archive kún un dípò kí a kọ lórí ohun tó ti wà lórí teepu tẹ́lẹ̀.

### Àwọn àmì àkókò tó rọrùn fún ènìyàn láti kà nínú orúkọ fáìlì

- Orúkọ àwọn log wákàtí máa ń rí báyìí: `rsyslog-2026-06-01T1600.log`
- Orúkọ archive ojoojúmọ́ máa ń rí báyìí: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Àwọn ààlà archive ojoojúmọ́ dá lórí àwọn fáìlì wákàtí àkọ́kọ́ àti ìkẹyìn gangan tí a fi sínú archive náà.
A ṣe àwọn orúkọ wọ̀nyí kí wọ́n lè rọrùn fún àwọn ènìyàn tí ń ṣàyẹ̀wò àwọn ferese ọjọ́ tàbí àkókò ìṣẹ̀lẹ̀ láti kà.
A yọ wákàtí tó ń lọ lọwọlọwọ kúrò ní ìdásílẹ̀ archive ní mọ̀ọ́mọ̀ kí a má bà a rán àwọn ìkọ̀wé tó ṣì ń lọ.

### Ìfíkun ìsàkóso OpenSSL fún àwọn archive ojoojúmọ́

`computer-b-daily-archive.sh` lè encrypt àwọn archive pẹ̀lú OpenSSL lẹ́yìn tí ó bá dá tarball sílẹ̀:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` fún symmetric encryption (`openssl enc`, cipher àìyẹ́padà `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` fún recipient-certificate encryption (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` láti yan cipher OpenSSL fún mejeeji ipo key-file àti certificate (àìyẹ́padà: `aes-256-gcm`).

Ọ̀kan péré nínú àwọn àṣàyàn wọ̀nyí ni a lè ṣètò ní àkókò kan. Àwọn output tí a encrypt máa ń lò `.tar.gz.enc`.
Fún ààbò, skripti náà máa ń kọ cipher tó rọrùn ju tàbí tí kì í ṣe AEAD, ó sì nílò cipher irú GCM/poly1305.

### Ìmúpadàbọ̀ archive láti teepu lórí Kọ̀ǹpútà C

Lo `computer-c-restore-archive-from-tape.sh` láti wa archive kan pàtó nípasẹ̀ wíwá àwọn fáìlì teepu ní títẹ̀lé láti ìbẹ̀rẹ̀:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Fún àwọn orúkọ archive bí `rsyslog-<start>_to_<end>.tar.gz` (tàbí `.tar.gz.enc`), skripti náà máa ń mọ ìbámu tó tọ́ nípa ṣíṣe àyẹ̀wò pé àwọn fáìlì wákàtí ààlà wà nínú payload tí a gba padà.
- Tí ìdárúkọ archive rẹ bá yàtọ̀, ṣètò `TARGET_MEMBER_GLOB` sí àpẹrẹ shell tó bá member kan mu tí ó gbọ́dọ̀ wà nínú archive náà.
- Tí archive kan bá jẹ́ encrypted, pese àwọn ètò decryption bí ó ṣe yẹ:
  - `OPENSSL_DECRYPT_KEY_FILE` (ipo symmetric `openssl enc`; cipher decryption àìyẹ́padà: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` àti `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (ipo decryption S/MIME)

A máa ń kọ output tí a gba padà gẹ́gẹ́ bí fáìlì `.tar.gz` plaintext kí a lè ṣàyẹ̀wò rẹ̀ pẹ̀lú àwọn irinṣẹ́ bí `tar -tzf`.

### Àkójọ table-of-contents teepu lórí Kọ̀ǹpútà C

Lo `computer-c-inventory-tape.sh` láti tẹ table-of-contents marker-ní-marker jáde:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Àwọn ọ̀wọ̀n output ní:

- `file_marker`: ipò marker fáìlì teepu tí ó bẹ̀rẹ̀ láti odo
- `status`: `ok`, `decrypted`, tàbí `unreadable`
- `encrypted`: bóyá a nílò decryption láti ṣàyẹ̀wò entry náà (`yes`/`no`)
- `archive_hint`: orúkọ irú archive tí a fojú dí rẹ̀ nígbà tí a bá lè mọ àwọn ààlà
- `first_member` / `last_member`: member tar àkọ́kọ́ àti ìkẹyìn tí a rí nínú marker náà
- `member_count`: iye àwọn member tar tí a rí nínú marker náà
- `bytes`: raw bytes tí a ka ní marker náà

Èyí máa ń jẹ́ kí olùṣàkóso mọ index marker tí a lè tọ̀ (`mt fsf <N>`) ṣáájú àwọn iṣẹ́ ìmúpadàbọ̀.

### Ìdánwò ìṣọ̀kan A/B/C tó dájú

Lo `scripts/test-computer-a-b-c-integration.sh` láti jẹ́risi ìṣọ̀kan láti ìbẹ̀rẹ̀ dé òpin fún Kọ̀ǹpútà A, B, àti C láìka àkókò tó ti kọjá sí:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Skripti yìí:

1. Ó ń fara wé A tí ń kọ log.
2. Ó ń ṣiṣẹ́ rotation àti ìdásílẹ̀ archive ojoojúmọ́ ti B.
3. Ó ń fara wé ìgbékalẹ̀ sí incoming ti C.
4. Ó ń ṣiṣẹ́ receive àti write-to-tape ti C.
5. Ó ń gba archive padà láti teepu, ó sì ń jẹ́risi akoonu.

Ó ń lò àmì ọjọ́ tó dídúró (`TEST_DAY_STAMP`, àìyẹ́padà `20260101`) kí ìhùwàsí lè tún ṣe, kí ó sì má bà a so mọ́ ọjọ́ tàbí àkókò ìsinsìnyí.

### Ìdádúró wákàtí 72 pẹ̀lú ààbò fún data tí a kò tíì jẹ́risi

Báyìí, àìyẹ́padà àwọn skripti ni ferese ìdádúró wákàtí 72:

- `computer-b-hourly-rotate.sh` máa ń yọ àwọn log wákàtí àtijọ́ kúrò nígbà tí marker ìjẹ́risi `.taped` àgbègbè tó bá wọn mu bá wà nìkan.
- `computer-b-send-archives.sh` máa ń yọ àwọn archive àgbègbè àtijọ́ kúrò nígbà tí mejeeji marker ìjẹ́risi `.sent` àti `.taped` àgbègbè bá wà.
- `computer-c-write-to-tape.sh` máa ń yọ àwọn archive àtijọ́ kúrò nìkan tí wọ́n bá ti ní marker `.taped` tẹ́lẹ̀.

Nítorí náà, àwọn fáìlì tí a kò tíì fi ránṣẹ́ dáadáa tí a sì kò tíì gbasilẹ sórí teepu máa ń wà níbẹ̀ bó tilẹ̀ jẹ́ pé wọ́n ti dàgbà ju `RETENTION_HOURS` (àìyẹ́padà `72`) lọ.
Lórí Kọ̀ǹpútà B, ìmúkúrò àgbègbè nílò àwọn marker `.taped` àgbègbè (fún àpẹẹrẹ láti inú ìgbésẹ̀ sync-back tàbí ìlànà ìjẹ́risi pẹ̀lú ọwọ́).
Lórí Kọ̀ǹpútà C, ọjọ́-ori ìdádúró ni a ń wọn láti àkókò àtúnṣe marker `.taped` (ní ìgbà gbogbo a máa ń ṣètò rẹ̀ ní àsìkò tí a ṣàṣeyọrí nínú kikọ sí teepu).

## Àwòrán Ilana

- [Àwòrán Mermaid àtẹ̀lé àti ìpò fún A/B/C](pipeline-diagrams/README.yo.md)
