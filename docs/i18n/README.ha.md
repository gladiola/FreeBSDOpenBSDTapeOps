# FreeBSDOpenBSDTapeOps (Hausa)

Rubutattun shell masu hulɗa da mai amfani da ke bi ta ayyukan kaset na maganadisu na yau da kullum ta amfani da `mt` da `tar`.

## Fihirisar Takardun Harshe

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


## Rubutun shirye-shirye

| Rubutu | Tsarin aiki na nufi |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Duk rubutun biyu suna aiwatar da jerin ayyuka iri ɗaya:

1. Su nemi mai amfani ya tabbatar an loda kaset.
2. Su mayar da kaset zuwa farko.
3. Su buga matsayin kaset.
4. Su jera abubuwan cikin ajiyoyi a matsayoyin fayil 0, 1, 2, da 3 ta amfani da `tar t`.
5. Su sa kaset ya shiga yanayin offline.

Kowane mataki yana tsayawa yana jiran mai amfani ya danna **Enter** kafin a ci gaba, abin da ya sa rubutun suka dace da zanga-zangar hulɗa ko jagororin mataki-mataki.

## Bambance-Bambance Tsakanin Rubutun Biyu

### 1. Hanyar na'urar kaset

Rubutun suna nufin nodes daban-daban na na'urar kaset:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Dukansu nodes ne na na'ura marasa komawa farkon kai tsaye (gabanin `n`), saboda haka ana kiyaye matsayin kaset tsakanin umarni kuma rubutun suna sarrafa matsayi kai tsaye da `mt rewind` da `mt fsf`.

### 2. Matakin loda kaset

- **FreeBSD**: Yana fitar da `mt -f /dev/nsa0 load` a farawa don loda cartridge ɗin kaset cikin injin a jiki kafin a mayar da shi farko.
- **OpenBSD**: Yana tsallake umarnin `load` saboda `mt(1)` na OpenBSD ba ya goyon bayan ƙaramin umarnin `load`. Rubutun OpenBSD yana ɗaukar cewa kaset ɗin yana cikin injin tuni kuma yana wucewa kai tsaye zuwa mayar da shi farko.

## Rubutun bututun log na OpenBSD daga A zuwa B zuwa C

Kundin `scripts/` yana ba da rubutun don yanayin da Kwamfuta B ta OpenBSD ke karɓar shigarwar rsyslog daga Kwamfuta A, tana tattara su kullum, tana aika su zuwa ɗaya daga cikin sabobin Kwamfuta C da yawa, sannan Kwamfuta C ta rubuta su zuwa kaset.

| Rubutu | Manufa |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Yana ƙirƙirar log mai juyawa na awa ɗaya daga fayil ɗin shigarwar rsyslog mai aiki a Kwamfuta B. |
| `scripts/computer-b-daily-archive.sh` | Yana tattara rana guda (`YYYYMMDD`) ta log na awa-awa zuwa ajiyar `.tar.gz` mai kewayon lokaci a Kwamfuta B, yana cire awa ta yanzu don guje wa rikicin rubutu mai gudana. |
| `scripts/computer-b-send-archives.sh` | Yana aika ajiyoyin kullum da ba a aika ba (`.tar.gz` da kuma na zaɓi `.tar.gz.enc`) daga Kwamfuta B zuwa sabar Kwamfuta C ɗaya ko fiye ta hanyar `scp`. |
| `scripts/computer-c-receive-archives.sh` | Yana tabbatar da ajiyoyin rubutu a bayyane da ke shigowa kuma yana jera ajiyoyin rubutu a bayyane ko ɓoye don kaset. |
| `scripts/computer-c-write-to-tape.sh` | Yana rubuta ajiyoyin rubutu a bayyane ko ɓoye da ke kan jere zuwa kaset, yana duba sarari, yana ƙara su a ƙarshen cikin aminci, kuma yana yi musu alamar an rubuta. |
| `scripts/computer-c-inventory-tape.sh` | Yana buga teburin abubuwan cikin kaset bisa alamar fayil domin ma'aikata su iya gano ajiyoyi da sauri. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Yana duba matsayoyin fayil na kaset domin ajiyar da aka nema, yana buɗe ɓoyewa idan ya zama dole, kuma yana adana bayanan da aka dawo dasu zuwa fayil. |
| `scripts/test-computer-a-b-c-integration.sh` | Yana gudanar da gwajin haɗin gida na A→B→C mai tabbas (ciki har da dawo da kaset) wanda bai dogara da lokacin agogo ba. |

Tsarin jadawali na yau da kullum:

- Gudanar da `computer-b-hourly-rotate.sh` kowane awa (cron a kan B).
- Gudanar da `computer-b-daily-archive.sh` sau ɗaya a rana (cron a kan B).
- Gudanar da `computer-b-send-archives.sh` bayan ƙirƙirar ajiya (cron a kan B).
- Gudanar da `computer-c-receive-archives.sh` lokaci-lokaci a kan C.
- Gudanar da `computer-c-write-to-tape.sh` lokaci-lokaci a kan C tare da na'urar kaset da ta dace.
- Gudanar da `computer-c-inventory-tape.sh` a kan C lokacin da kake buƙatar teburin abubuwan ciki alama-da-alama.
- Gudanar da `computer-c-restore-archive-from-tape.sh` a kan C lokacin da kake buƙatar dawo da takamaiman ajiya don dubawa.

Dukkan rubutun bututun kuma suna fitar da saƙonnin aiki zuwa syslog ta hanyar `logger` (misali, ana iya gani ta rsyslog/journaling) ban da fitarwar console.

### Aikawa zuwa sabobi da yawa daga Kwamfuta B

`computer-b-send-archives.sh` yana goyon bayan yanayin sabar guda ɗaya da yanayin sabobi da yawa:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Zaɓuɓɓukan zaɓen sabar a ɓangaren kwastoma:

- Ka bayar da sabar guda ɗaya a cikin muhawara don kafe zuwa Kwamfuta C guda ɗaya.
- Ka bayar da sabobi da yawa don ba da damar fallback.
- Saita `PREFERRED_SERVER=user@host` don zaɓar takamaiman sabar guda ɗaya daga jerin da aka bayar.

Zaɓuɓɓukan kula da yanayin busy a Kwamfuta B:

- `REMOTE_BUSY_MARKER` (na tsoho: `.busy`): fayil ɗin alama da ake dubawa a ɓangaren nesa.
- `BUSY_RETRY_SECONDS` (na tsoho: `60`): lokacin jira tsakanin sake gwadawa yayin da sabar ke busy.
- `BUSY_MAX_RETRIES` (na tsoho: `10`): matsakaicin ƙoƙarin sake gwadawa ga kowace sabar.

### Buga yanayin busy daga Kwamfuta C

`computer-c-write-to-tape.sh` yana ƙirƙirar alamar busy yayin da yake rubuta ajiyoyi zuwa kaset a zahiri kuma yana cire ta idan babu aiki.

- `BUSY_MARKER` (na tsoho: `<received_dir>/.busy`)

Ka nuna `REMOTE_BUSY_MARKER` a Kwamfuta B zuwa wurin alamar da Kwamfuta C ke amfani da shi.

### Tsaron kaset da halin ƙara a ƙarshen a Kwamfuta C

Kafin rubuta kowace ajiya, `computer-c-write-to-tape.sh` yana duba ƙarfin kaset ko na'ura da yake samuwa kuma yana buƙatar aƙalla:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Mahimman canje-canje:

- `TAPE_SAFETY_MARGIN_BYTES` (na tsoho: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override don sanannen sarari da ake da shi)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (yana ba da damar rubutawa idan ba za a iya gano sarari ba)

Ga na'urorin kaset na gaske, mai rubutawa yana matsawa zuwa ƙarshen bayanai (`mt eom`/`mt eod`) kafin rubutu, saboda haka ana ƙara ajiyoyi da yawa a ƙarshen maimakon goge abubuwan da ke kaset a baya.

### Lokutan da mutum zai iya karantawa a cikin sunayen fayil

- Ana sanya wa log na awa-awa suna kamar haka: `rsyslog-2026-06-01T1600.log`
- Ana sanya wa ajiyoyin kullum suna kamar haka: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Kewayon ajiyar yau da kullum yana dogara ne da ainihin fayilolin awa na farko da na ƙarshe da aka haɗa a cikin ajiyar.
An yi nufin waɗannan sunaye su zama masu sauƙin karantawa ga mutanen da ke duba tagogin kwanan wata ko lokaci na abubuwan da suka faru.
An cire awa ta yanzu da gangan daga ƙirƙirar ajiya domin kada a aika rubuce-rubuce masu aiki.

### Zaɓin boye-boye na OpenSSL don ajiyoyin yau da kullum

`computer-b-daily-archive.sh` na iya ɓoye ajiyoyi da OpenSSL bayan ƙirƙirar tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` don ɓoyewar daidaito (`openssl enc`, cipher na tsoho `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` don ɓoyewar takardar shaidar mai karɓa (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` don zaɓar cipher na OpenSSL ga yanayin fayil ɗin maɓalli da na takardar shaida duka (na tsoho: `aes-256-gcm`).

Za a iya saita ɗaya kaɗai daga cikin waɗannan zaɓuɓɓuka a lokaci guda. Abubuwan fitarwa da aka ɓoye suna amfani da `.tar.gz.enc`.
Saboda tsaro, rubutun yana ƙin zaɓin cipher masu rauni ko waɗanda ba AEAD ba, kuma yana buƙatar ciphers na ajin GCM/poly1305.

### Dawo da ajiya daga kaset a Kwamfuta C

Yi amfani da `computer-c-restore-archive-from-tape.sh` don gano takamaiman ajiya ta hanyar binciken fayilolin kaset a jere tun daga farko:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Ga sunayen ajiya kamar `rsyslog-<start>_to_<end>.tar.gz` (ko `.tar.gz.enc`), rubutun yana gano daidaitaccen abin da ya dace ta duba cewa fayilolin awa na iyaka suna cikin abin da aka dawo da shi.
- Idan tsarin sunan ajiyarka ya bambanta, saita `TARGET_MEMBER_GLOB` zuwa tsarin shell da ya dace da wani memba wanda dole ne ya kasance a cikin ajiya.
- Idan an ɓoye ajiya, ka bayar da saitunan cire ɓoyewa idan ya zama dole:
  - `OPENSSL_DECRYPT_KEY_FILE` (yanayin daidaito na `openssl enc`; cipher cire ɓoyewa na tsoho: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` da `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (yanayin cire ɓoyewar S/MIME)

Ana rubuta abin da aka dawo da shi a matsayin fayil `.tar.gz` na rubutu a bayyane domin a iya duba shi da kayan aiki kamar `tar -tzf`.

### Ƙidayar teburin abubuwan cikin kaset a Kwamfuta C

Yi amfani da `computer-c-inventory-tape.sh` don buga teburin abubuwan ciki alama-da-alama:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Ginshiƙan fitarwa sun haɗa da:

- `file_marker`: matsayin alamar fayil na kaset da aka fara kirgawa daga sifili
- `status`: `ok`, `decrypted`, ko `unreadable`
- `encrypted`: ko an buƙaci cire ɓoyewa don duba shigarwar (`yes`/`no`)
- `archive_hint`: sunan irin ajiya da aka hango lokacin da za a iya gane iyakoki
- `first_member` / `last_member`: membobin tar na farko da na ƙarshe da aka gani a wannan alamar
- `member_count`: adadin membobin tar da aka samu a wannan alamar
- `bytes`: danyen bytes da aka karanta a wannan alamar

Wannan yana ba mai aiki damar gano index ɗin alamar da za a nema (`mt fsf <N>`) kafin ayyukan dawo wa.

### Gwajin haɗin A/B/C mai tabbas

Yi amfani da `scripts/test-computer-a-b-c-integration.sh` don tabbatar da haɗin kai daga ƙarshe zuwa ƙarshe na Kwamfutocin A, B, da C ba tare da la’akari da lokacin da ya wuce ba:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Wannan rubutun:

1. Yana kwaikwayon A tana rubuta log.
2. Yana gudanar da juyawar B da ƙirƙirar ajiyar yau da kullum.
3. Yana kwaikwayon canja wuri zuwa shigarwar C.
4. Yana gudanar da karɓar C da rubutu zuwa kaset.
5. Yana dawo da ajiya daga kaset kuma yana tabbatar da abin ciki.

Yana amfani da tambarin rana na dindindin (`TEST_DAY_STAMP`, na tsoho `20260101`) domin hali ya kasance mai maimaituwa kuma ba ya danganta da kwanan wata ko lokacin yanzu.

### Riƙewa na awanni 72 tare da tsaro ga bayanan da ba a tabbatar ba

Rubutun yanzu suna amfani da taga riƙewa na awanni 72 a matsayin tsoho:

- `computer-b-hourly-rotate.sh` yana cire tsoffin log na awa-awa ne kawai idan akwai alamar tabbatarwa ta gida ta `.taped` da ta dace.
- `computer-b-send-archives.sh` yana cire tsoffin ajiyoyin gida ne kawai idan akwai duka alamomin tabbatarwa na `.sent` da na gida `.taped`.
- `computer-c-write-to-tape.sh` yana cire tsoffin ajiyoyi ne kawai waɗanda tuni suna da alamomin `.taped`.

Sakamakon haka, ana riƙe fayilolin da ba a aika su cikin nasara kuma ba a rubuta su zuwa kaset ba ko da sun wuce `RETENTION_HOURS` (na tsoho `72`).
A Kwamfuta B, tsaftacewar gida tana buƙatar alamomin `.taped` na gida (misali daga matakin sync-back ko tsarin tabbatarwa da hannu).
A Kwamfuta C, ana auna shekarun riƙewa daga lokacin gyaran alamar `.taped` (yawanci ana saita shi a lokacin nasarar rubutu zuwa kaset).

## Zanen Bututun Aiki

- [Zanen Mermaid na jere da yanayi na A/B/C](pipeline-diagrams/README.ha.md)
