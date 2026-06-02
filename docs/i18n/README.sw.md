# FreeBSDOpenBSDTapeOps (Kiswahili)

Hati za shell zinazoshirikisha mtumiaji zinazopitia shughuli za kawaida za tepu ya sumaku kwa kutumia `mt` na `tar`.

## Faharasa ya Nyaraka za Lugha

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


## Skripti

| Skripti | Mfumo lengwa |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Skripti zote mbili hutekeleza mfuatano uleule wa shughuli:

1. Muombe mtumiaji athibitishe kuwa tepu imeingizwa.
2. Rudisha tepu mwanzo.
3. Chapisha hali ya tepu.
4. Orodhesha yaliyomo kwenye kumbukumbu katika nafasi za faili 0, 1, 2, na 3 kwa kutumia `tar t`.
5. Weka tepu katika hali ya offline.

Kila hatua husimama na kusubiri mtumiaji abonyeze **Enter** kabla ya kuendelea, hivyo skripti zinafaa kama maonyesho ya mwingiliano au uelekezaji wa hatua kwa hatua.

## Tofauti Kati ya Skripti Mbili

### 1. Njia ya kifaa cha tepu

Skripti hizi hulenga nodi tofauti za kifaa cha tepu:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Zote mbili ni nodi za kifaa zisizorudisha tepu mwanzo (kiambishi awali `n`), hivyo nafasi ya tepu huhifadhiwa kati ya amri na skripti hudhibiti uwekaji nafasi moja kwa moja kwa `mt rewind` na `mt fsf`.

### 2. Hatua ya kupakia tepu

- **FreeBSD**: Hutoa `mt -f /dev/nsa0 load` wakati wa kuanza ili kupakia kimekanika katriji ya tepu kwenye kifaa kabla ya kurudisha mwanzo.
- **OpenBSD**: Huruka amri ya `load` kwa sababu `mt(1)` ya OpenBSD haiungi mkono amri ndogo ya `load`. Skripti ya OpenBSD hudhani tepu tayari ipo kwenye kifaa na huendelea moja kwa moja kurudisha mwanzo.

## Skripti za Msururu wa Kumbukumbu za OpenBSD A-kwa-B-kwa-C

Saraka ya `scripts/` inatoa skripti kwa hali ambapo Kompyuta B ya OpenBSD hupokea ingizo za rsyslog kutoka Kompyuta A, huzikusanya kila siku, huzituma kwa mojawapo ya seva kadhaa za Kompyuta C, na Kompyuta C huziandika kwenye tepu.

| Skripti | Madhumuni |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Huunda kumbukumbu iliyozungushwa kila saa kutoka faili ya sasa ya ingizo la rsyslog kwenye Kompyuta B. |
| `scripts/computer-b-daily-archive.sh` | Hufunga siku moja (`YYYYMMDD`) ya kumbukumbu za kila saa kuwa kumbukumbu ya `.tar.gz` yenye muda mbalimbali kwenye Kompyuta B, huku ikiondoa saa ya sasa ili kuepuka migongano ya uandishi unaoendelea. |
| `scripts/computer-b-send-archives.sh` | Hutuma kumbukumbu za kila siku ambazo hazijatumwa (`.tar.gz` na hiari `.tar.gz.enc`) kutoka Kompyuta B kwenda seva moja au zaidi za Kompyuta C kupitia `scp`. |
| `scripts/computer-c-receive-archives.sh` | Huthibitisha kumbukumbu za maandishi wazi zinazoingia na kuweka kumbukumbu za maandishi wazi au zilizosimbwa kwenye foleni kwa ajili ya tepu. |
| `scripts/computer-c-write-to-tape.sh` | Huandika kumbukumbu za maandishi wazi au zilizosimbwa zilizo kwenye foleni kwenye tepu, hukagua nafasi, huongeza mwishoni kwa usalama, na huzitia alama kuwa zimerekodiwa. |
| `scripts/computer-c-inventory-tape.sh` | Huchapisha jedwali la yaliyomo kwenye tepu kulingana na alama za faili ili waendeshaji waweze kupata kumbukumbu haraka. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Huchanganua nafasi za faili za tepu kutafuta kumbukumbu iliyoombwa, husimbua inapohitajika, na huhifadhi data iliyopatikana kwenye faili. |
| `scripts/test-computer-a-b-c-integration.sh` | Huendesha jaribio la ujumuishaji la ndani la A→B→C lenye matokeo thabiti (likijumuisha urejeshaji kutoka tepu) lisilotegemea muda wa saa. |

Ratiba ya kawaida:

- Endesha `computer-b-hourly-rotate.sh` kila saa (cron kwenye B).
- Endesha `computer-b-daily-archive.sh` mara moja kwa siku (cron kwenye B).
- Endesha `computer-b-send-archives.sh` baada ya uundaji wa kumbukumbu (cron kwenye B).
- Endesha `computer-c-receive-archives.sh` mara kwa mara kwenye C.
- Endesha `computer-c-write-to-tape.sh` mara kwa mara kwenye C ukiwa na kifaa sahihi cha tepu.
- Endesha `computer-c-inventory-tape.sh` kwenye C unapohitaji jedwali la yaliyomo alama-kwa-alama.
- Endesha `computer-c-restore-archive-from-tape.sh` kwenye C unapohitaji kurejesha kumbukumbu maalum kwa ukaguzi.

Skripti zote za msururu pia hutuma ujumbe wa uendeshaji kwenye syslog kupitia `logger` (kwa mfano, unaoonekana kupitia rsyslog/journaling) pamoja na matokeo ya kwenye konsoli.

### Utumaji kwa seva nyingi kutoka Kompyuta B

`computer-b-send-archives.sh` inaunga mkono hali ya seva moja na hali ya seva nyingi:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Chaguo za upande wa mteja za kuchagua seva:

- Toa seva moja kwenye hoja ili kuifunga kwa Kompyuta C moja.
- Toa seva nyingi ili kuruhusu fallback.
- Weka `PREFERRED_SERVER=user@host` ili kuchagua seva moja maalum kutoka kwenye orodha iliyotolewa.

Chaguo za kushughulikia hali ya busy kwenye Kompyuta B:

- `REMOTE_BUSY_MARKER` (chaguo-msingi: `.busy`): faili ya alama inayokaguliwa upande wa mbali.
- `BUSY_RETRY_SECONDS` (chaguo-msingi: `60`): muda wa kusubiri kati ya majaribio tena huku seva ikiwa busy.
- `BUSY_MAX_RETRIES` (chaguo-msingi: `10`): idadi ya juu ya majaribio tena kwa kila seva.

### Uchapishaji wa hali busy kutoka Kompyuta C

`computer-c-write-to-tape.sh` huunda alama ya busy wakati inaandika kikamilifu kumbukumbu kwenye tepu na huiondoa inapokuwa haina shughuli.

- `BUSY_MARKER` (chaguo-msingi: `<received_dir>/.busy`)

Elekeza `REMOTE_BUSY_MARKER` kwenye Kompyuta B kwenye eneo la alama linalotumiwa na Kompyuta C.

### Usalama wa tepu na tabia ya kuongeza mwishoni kwenye Kompyuta C

Kabla ya kuandika kila kumbukumbu, `computer-c-write-to-tape.sh` hukagua uwezo wa tepu au kifaa unaopatikana na huhitaji angalau:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Vigeuzi husika:

- `TAPE_SAFETY_MARGIN_BYTES` (chaguo-msingi: `10485760`)
- `TAPE_AVAILABLE_BYTES` (kuondoa juu ya chaguo-msingi kwa nafasi inayojulikana kupatikana)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (huruhusu kuandika ikiwa nafasi haiwezi kutambuliwa)

Kwa vifaa halisi vya tepu, mwandishi huenda hadi mwisho wa data (`mt eom`/`mt eod`) kabla ya kuandika, hivyo kumbukumbu nyingi huongezwa mwishoni badala ya kuandika juu ya yaliyomo awali ya tepu.

### Mihuri ya muda inayosomeka na binadamu katika majina ya faili

- Kumbukumbu za kila saa huitwa kama: `rsyslog-2026-06-01T1600.log`
- Kumbukumbu za kila siku huitwa kama: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Vipindi vya kumbukumbu za kila siku vinategemea faili halisi za kwanza na za mwisho za kila saa zilizojumuishwa kwenye kumbukumbu.
Majina haya yamekusudiwa yasomeke kwa watu wanaochunguza vipindi vya tarehe au saa ya matukio.
Saa ya sasa imeondolewa kwa makusudi katika uundaji wa kumbukumbu ili uandishi unaoendelea usitumwe.

### Usimbaji wa hiari wa OpenSSL kwa kumbukumbu za kila siku

`computer-b-daily-archive.sh` inaweza kusimba kumbukumbu kwa OpenSSL baada ya kuunda tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` kwa usimbaji sawia (`openssl enc`, cipher ya chaguo-msingi `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` kwa usimbaji wa cheti cha mpokeaji (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` ili kuchagua cipher ya OpenSSL kwa hali zote za faili ya ufunguo na cheti (chaguo-msingi: `aes-256-gcm`).

Moja tu ya chaguo hizi inaweza kuwekwa kwa wakati mmoja. Matokeo yaliyosimbwa hutumia `.tar.gz.enc`.
Kwa usalama, skripti hukataa chaguo dhaifu au zisizo za AEAD za cipher na huhitaji cipher za daraja la GCM/poly1305.

### Urejeshaji wa kumbukumbu kutoka tepu kwenye Kompyuta C

Tumia `computer-c-restore-archive-from-tape.sh` kupata kumbukumbu maalum kwa kutafuta faili za tepu kwa mpangilio kuanzia mwanzo:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Kwa majina ya kumbukumbu kama `rsyslog-<start>_to_<end>.tar.gz` (au `.tar.gz.enc`), skripti hutambua ulinganifu sahihi kwa kukagua kwamba faili za kila saa za mipaka zipo katika mzigo uliorejeshwa.
- Ikiwa uundaji wako wa majina ya kumbukumbu ni tofauti, weka `TARGET_MEMBER_GLOB` kwenye mchoro wa shell unaolingana na mwanachama ambaye lazima awepo kwenye kumbukumbu.
- Ikiwa kumbukumbu imesimbwa, toa mipangilio ya usimbuaji kadiri inavyohitajika:
  - `OPENSSL_DECRYPT_KEY_FILE` (hali sawia ya `openssl enc`; cipher ya chaguo-msingi ya usimbuaji: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` na `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (hali ya usimbuaji ya S/MIME)

Matokeo yaliyorejeshwa huandikwa kama faili ya `.tar.gz` ya maandishi wazi ili yaweze kukaguliwa kwa zana kama `tar -tzf`.

### Hesabu ya jedwali la yaliyomo la tepu kwenye Kompyuta C

Tumia `computer-c-inventory-tape.sh` kuchapisha jedwali la yaliyomo alama-kwa-alama:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Safu za matokeo zinajumuisha:

- `file_marker`: nafasi ya alama ya faili ya tepu inayohesabiwa kuanzia sifuri
- `status`: `ok`, `decrypted`, au `unreadable`
- `encrypted`: kama usimbuaji ulihitajika kukagua ingizo (`yes`/`no`)
- `archive_hint`: jina la aina ya kumbukumbu lililodhaniwa wakati mipaka inaweza kutambuliwa
- `first_member` / `last_member`: wanachama wa kwanza na wa mwisho wa tar walioonekana katika alama hiyo
- `member_count`: idadi ya wanachama wa tar waliopatikana katika alama hiyo
- `bytes`: baiti ghafi zilizosomwa katika alama hiyo

Hii humwezesha mwendeshaji kutambua faharasa ya alama ya kutafuta (`mt fsf <N>`) kabla ya shughuli za urejeshaji.

### Jaribio la ujumuishaji la A/B/C lenye matokeo thabiti

Tumia `scripts/test-computer-a-b-c-integration.sh` kuthibitisha ujumuishaji wa mwisho-hadi-mwisho wa Kompyuta A, B, na C bila kujali muda uliopita:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Skripti hii:

1. Huiga A ikiandika kumbukumbu.
2. Huendesha mzunguko na uundaji wa kumbukumbu wa B.
3. Huiga uhamisho kwenda kwenye ingizo la C.
4. Huendesha mapokezi ya C pamoja na uandishi kwenye tepu.
5. Hurejesha kumbukumbu kutoka tepu na kuthibitisha yaliyomo.

Inatumia muhuri wa siku uliowekwa (`TEST_DAY_STAMP`, chaguo-msingi `20260101`) ili tabia iweze kurudiwa na isifungwe kwa tarehe au saa ya sasa.

### Uhifadhi wa saa 72 wenye usalama kwa data isiyothibitishwa

Skripti sasa hutumia kwa chaguo-msingi dirisha la uhifadhi la saa 72:

- `computer-b-hourly-rotate.sh` huondoa kumbukumbu za zamani za kila saa tu wakati alama inayolingana ya uthibitisho ya ndani ya `.taped` ipo.
- `computer-b-send-archives.sh` huondoa kumbukumbu za zamani za ndani tu wakati alama za uthibitisho za `.sent` na za ndani za `.taped` zote zipo.
- `computer-c-write-to-tape.sh` huondoa kumbukumbu za zamani tu ambazo tayari zina alama za `.taped`.

Kwa hiyo, faili ambazo bado hazijatumwa na kurekodiwa kwa mafanikio kwenye tepu huhifadhiwa hata zikiwa za zamani kuliko `RETENTION_HOURS` (chaguo-msingi `72`).
Kwenye Kompyuta B, usafishaji wa ndani unahitaji alama za ndani za `.taped` (kwa mfano kutoka hatua ya kusawazisha kurudi au mchakato wa kuthibitisha kwa mkono).
Kwenye Kompyuta C, umri wa uhifadhi hupimwa kutoka muda wa marekebisho wa alama ya `.taped` (kwa kawaida huwekwa wakati wa kuandika tepu kwa mafanikio).

## Michoro ya Mlolongo

- [Michoro ya Mermaid ya mfuatano na hali ya A/B/C](pipeline-diagrams/README.sw.md)
