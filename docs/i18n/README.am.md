# FreeBSDOpenBSDTapeOps (አማርኛ)

በ`mt` እና `tar` ተጠቅሞ የተለመዱ የማግኔቲክ ቴፕ ስራዎችን ደረጃ በደረጃ የሚያሳዩ በይነተገናኝ shell ስክሪፖች።

## የቋንቋ ሰነዶች ማውጫ

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


## ስክሪፖች

| ስክሪፕ | ዒላማ ስርዓተ ክወና |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

ሁለቱም ስክሪፖች ተመሳሳይ ተከታታይ ስራዎችን ያከናውናሉ፦

1. ቴፕ መጫኑን ለተጠቃሚው ያረጋግጣሉ።
2. ቴፕን ይጠቀልላሉ።
3. የቴፕ ሁኔታ ያትማሉ።
4. `tar t` ተጠቅሞ በፋይል ቦታዎች 0፣ 1፣ 2 እና 3 ያሉ ማህደሮች ይዘት ይዘረዝራሉ።
5. ቴፕን ከስራ ውጭ ያደርጋሉ።

እያንዳንዱ ደረጃ ቆምና ተጠቃሚው **Enter** እስኪጫን ይጠብቃሉ፤ ስለዚህ ስክሪፖቹ እንደ በይነተገናኝ ማሳያዎች ወይም ሚመራ ጉዞዎች ተስማሚ ናቸው።

## በሁለቱ ስክሪፖች መካከል ያሉ ልዩነቶች

### 1. የቴፕ መሳሪያ መስመር

ስክሪፖቹ የተለያዩ የቴፕ መሳሪያ ኖዶችን ዒላማ ያደርጋሉ፦

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

ሁለቱም ቀጥተኛ ያልሆነ ሪዋይንድ ኖዶች ናቸው (`n` ቅድመ ቅጥያ)፣ ስለዚህ በትዕዛዞች መካከል የቴፕ ቦታ ይቆያል፤ ስክሪፖቹ ደግሞ ቦታ ቁጥጥርን በ`mt rewind` እና `mt fsf` ይቆጣጠራሉ።

### 2. የቴፕ መጫን ደረጃ

- **FreeBSD**: ቴፕ ካሴቱን ወደ ድራይቭ ሜካኒካዊ ሁኔታ ለመጫን ከሪዋይንድ በፊት በጀምሪያ `mt -f /dev/nsa0 load` ይሰጣሉ።
- **OpenBSD**: OpenBSD ​`mt(1)` `load` ንዑስ ትዕዛዝ ስለማይደግፍ የ`load` ትዕዛዝ ይዘለላሉ። የ OpenBSD ስክሪፕ ቴፕ አስቀድሞ በድራይቩ ውስጥ እንዳለ ይቆጥርና ቀጥታ ወደ ሪዋይንድ ይሄዳሉ።

## OpenBSD A-ሀ-B-ወደ-C የምዝግብ ማስታወሻ የቧንቧ መስመር ስክሪፖች

`scripts/` ማውጫ OpenBSD ኮምፒዩተር B ከኮምፒዩተር A rsyslog ግቤቶች ሲቀበል፣ በቀን ሲጠቅልለው፣ ወደ አንዱ ከበርካታ ኮምፒዩተር C ሰርቨሮች ሲልከው፣ እና ኮምፒዩተር C ወደ ቴፕ ሲጽፈው ለሚሆነው ሁኔታ ስክሪፖችን ያቀርባሉ።

| ስክሪፕ | ዓላማ |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | በኮምፒዩተር B ላይ ካለው ንቁ rsyslog ግቤት ፋይል በሰዓት የሚሽከረከር ምዝግብ ማስታወሻ ይፈጥራሉ። |
| `scripts/computer-b-daily-archive.sh` | አንድ ቀን (`YYYYMMDD`) የሰዓታዊ ምዝግብ ማስታወሻዎችን ወደ ጊዜ ልዩነት ያለው `.tar.gz` ማህደር ወደ ኮምፒዩተር B ያጠቃልሉ፤ ንቁ የጽሁፍ ቅሬታን ለማስቀረት ወቅታዊ ሰዓቱን ይዘለላሉ። |
| `scripts/computer-b-send-archives.sh` | ያልተላኩ ዕለታዊ ማህደሮች (`.tar.gz` እና አማራጭ `.tar.gz.enc`) ከኮምፒዩተር B ወደ አንድ ወይም ብዙ ኮምፒዩተር C ሰርቨሮች በ`scp` ይልካሉ። |
| `scripts/computer-c-receive-archives.sh` | የሚመጡ ጽሁፍ ማህደሮችን ያረጋግጣሉ፤ ጽሁፍ/ምስጢር ማህደሮችን ለቴፕ ይሰለፋሉ። |
| `scripts/computer-c-write-to-tape.sh` | የሰለፉ ጽሁፍ ወይም ምስጢር ማህደሮችን ወደ ቴፕ ይጽፋሉ፤ ቦታ ይፈትሻሉ፤ ደህና ሁኔታ ላይ ያያይዛሉ፤ ተቀዳ ብለው ያስምሩባቸዋሉ። |
| `scripts/computer-c-inventory-tape.sh` | ኦፕሬተሮች ማህደሮችን በፍጥነት እንዲያገኙ የቴፕ ማውጫ ሠንጠረዥ በፋይል ምልክቶች ያትማሉ። |
| `scripts/computer-c-restore-archive-from-tape.sh` | ለተጠየቀ ማህደር የቴፕ ፋይል ቦታዎችን ይቃኛሉ፤ አስፈላጊ ሲሆን ምስጢር ይፈቱ፤ ተመለሱ ዳታ ወደ ፋይል ይቀምሩ። |
| `scripts/test-computer-a-b-c-integration.sh` | ሰዓት ቆጣሪ ወቅት ሳያስፈልግ ወሳኝ ሃቀኛ ሃቅ A→B→C ውህደት ፈተና (ቴፕ ወደ ቦታ መልስ ጨምሮ) ያካሂዱ። |

የተለመደ ጊዜ ቅደም ተከተል፦

- `computer-b-hourly-rotate.sh` በሰዓት ያካሂዱ (B ላይ cron)።
- `computer-b-daily-archive.sh` በቀን አንድ ጊዜ ያካሂዱ (B ላይ cron)።
- `computer-b-send-archives.sh` ማህደር ከተፈጠረ በኋላ ያካሂዱ (B ላይ cron)።
- `computer-c-receive-archives.sh` ወቅቱን በጠብቆ C ላይ ያካሂዱ።
- `computer-c-write-to-tape.sh` ትክክለኛ ቴፕ መሳሪያ ይዘው ወቅቱን በጠብቆ C ላይ ያካሂዱ።
- `computer-c-inventory-tape.sh` ምልክት-በምልክት ማውጫ ሠንጠረዥ ሲያስፈልጋችሁ C ላይ ያካሂዱ።
- `computer-c-restore-archive-from-tape.sh` ለምርመራ የተወሰነ ማህደር ሲፈልጉ C ላይ ያካሂዱ።

ሁሉም የቧንቧ መስመር ስክሪፖች በተጨማሪም ሥራ ነክ መልዕክቶችን ወደ syslog በ`logger` ይልካሉ (ለምሳሌ፣ rsyslog/journaling በኩል ይታዩ)፤ ይህ ከኮንሶል ውጤት በተጨማሪ ነው።

### ከኮምፒዩተር B ወደ ብዙ ሰርቨሮች ልኬት

`computer-b-send-archives.sh` ለአንድ ሰርቨር ሁናቴ እና ለብዙ ሰርቨሮች ሁናቴ ደጋፊ ነው፦

- አንድ ሰርቨር፦ `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- ብዙ ሰርቨሮች፦ `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

ከደንበኛ ወገን የሰርቨር ምርጫ አማራጮች፦

- ወደ አንድ ኮምፒዩተር C ለመቆለፍ አንድ ሰርቨር ይስጡ።
- ወደ ኋላ ለመውደቅ ብዙ ሰርቨሮች ይስጡ።
- ከተሰጡ ዝርዝሮች ውስጥ አንድ ሰርቨር ለመምረጥ `PREFERRED_SERVER=user@host` ያዘጋጁ።

በኮምፒዩተር B ላይ ሥራ ብዛት አቆጣጠር አማራጮች፦

- `REMOTE_BUSY_MARKER` (ነባሪ፦ `.busy`)፦ ከርቀት ወገን የሚፈተሽ ምልክት ፋይል።
- `BUSY_RETRY_SECONDS` (ነባሪ፦ `60`)፦ ሰርቨሩ ሲጠመድ በሙከራዎች መካከል የመጠበቅ ጊዜ።
- `BUSY_MAX_RETRIES` (ነባሪ፦ `10`)፦ በሰርቨር ከፍተኛ የሙከራ ሙከራ ቁጥር።

### ከኮምፒዩተር C የሥራ ብዛት ሁኔታ ማሳወቅ

`computer-c-write-to-tape.sh` ማህደሮችን ወደ ቴፕ በንቃት ሲጽፍ የሥራ ብዛት ምልክት ይፈጥራሉ፤ ሲቀዘቅዙ ያስወግዱታሉ።

- `BUSY_MARKER` (ነባሪ፦ `<received_dir>/.busy`)

ኮምፒዩተር C የሚጠቀምበትን ምልክት ቦታ ወደ `REMOTE_BUSY_MARKER` ኮምፒዩተር B ላይ ያቅናሉ።

### በኮምፒዩተር C ላይ የቴፕ ደህንነት እና ማያያዝ ባህሪ

እያንዳንዱን ማህደር ከመጻፉ በፊት፣ `computer-c-write-to-tape.sh` የሚገኝ የቴፕ/መሳሪያ አቅም ፈትሾ ቢያንስ የሚከተለው ሊኖር ይጠይቃሉ፦

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

ተዛማጅ ተለዋዋጮች፦

- `TAPE_SAFETY_MARGIN_BYTES` (ነባሪ፦ `10485760`)
- `TAPE_AVAILABLE_BYTES` (ለሚታወቅ ነፃ ቦታ ሥልጣን)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ቦታ ሊታወቅ ካልቻለ ጽሁፍ ይፍቀዱ)

ለእውነተኛ ቴፕ መሳሪያዎች ጸሐፊው ከመጻፉ በፊት ወደ ዳታ ፍጻሜ (`mt eom`/`mt eod`) ይፈልጉ ስለዚህ ብዙ ማህደሮች ከቀዳሚ ቴፕ ይዘቶች ፋንታ ተጨምሮ ይቀመጣሉ።

### በፋይል ስሞች ውስጥ ሰው-ሊያነበው የሚችል ጊዜ ምልክቶች

- ሰዓታዊ ምዝግብ ማስታወሻዎች እንደሚከተለው ይሰየሙ፦ `rsyslog-2026-06-01T1600.log`
- ዕለታዊ ማህደሮች እንደሚከተለው ይሰየሙ፦ `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

ዕለታዊ ማህደር ወሰኖች በማህደሩ ውስጥ ከተካተቱ ትክክለኛ የመጀመሪያ እና የመጨረሻ ሰዓታዊ ፋይሎች ላይ ተመርኩዘዋሉ።
እነዚህ ስሞች ለክስተት ቀን/ጊዜ መስኮቶች ሲፈልጉ ሰዎች ቀላሉ ንባብ እንዲሆናቸው ታቅዶ ተሰሯል።
ወቅታዊ ሰዓቱ ሆን ብሎ ከማህደር ፈጠራ ሲዘለል ንቁ ጽሁፍ አይተላለፍም።

### ለዕለታዊ ማህደሮች አማራጭ OpenSSL ምስጢር

`computer-b-daily-archive.sh` ታርቦሉን ከፈጠረ በኋላ ማህደሮችን ምስጢር ማድረግ ይችላሉ፦

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` ለተምሳሌታዊ ምስጢር (`openssl enc`፤ ነባሪ ምስጠራ `aes-256-gcm`)።
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` ለተቀባይ-ምስክርወረቀት ምስጢር (`openssl smime`)።
- `OPENSSL_ENCRYPT_CIPHER` ለቁልፍ-ፋይል እና ምስክርወረቀት ሁናቴዎች OpenSSL ምስጠራ ለመምረጥ (ነባሪ፦ `aes-256-gcm`)።

ከእነዚህ አማራጮች ውስጥ አንዱ ብቻ በአንድ ጊዜ ሊዘጋጅ ይችላሉ። ምስጢር ውጤቶች `.tar.gz.enc` ይጠቀማሉ።
ደህንነት ሲባል ስክሪፕቱ ደካማ ወይም AEAD-ያልሆኑ ምስጠራ ምርጫዎችን ይቃወምና GCM/poly1305-ክፍል ምስጠራዎችን ይጠይቃሉ።

### ከቴፕ ላይ ማህደር ማዳን በኮምፒዩተር C

`computer-c-restore-archive-from-tape.sh` ተጠቅሞ ከጀምሪያ ቴፕ ፋይሎችን ቅደም ተከተል ፈትሾ የተወሰነ ማህደር ያግኙ፦

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- `rsyslog-<start>_to_<end>.tar.gz` (ወይም `.tar.gz.enc`) ያሉ ማህደር ስሞች ሲሆን፣ ስክሪፕቱ የተዳነ ጭነት ውስጥ ወሰናዊ ሰዓታዊ ፋይሎች እንዳሉ ፈትሾ ትክክለኛ ዛሙ ይለያሉ።
- ማህደር ስምዎ የተለዩ ከሆነ፣ ማህደሩ ውስጥ ሊኖር የሚገባ አባልን የሚዛሙ shell ቅርጸ ምልክት `TARGET_MEMBER_GLOB` ያዘጋጁ።
- ማህደሩ ምስጢር ከሆነ ምስጢር የመፍቻ ቅንብሮቹን አስፈላጊ ሁኖ ይስጡ፦
  - `OPENSSL_DECRYPT_KEY_FILE` (ተምሳሌታዊ `openssl enc` ሁናቴ፤ ነባሪ ምስጢር ፍቻ ምስጠራ፦ `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` እና `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME ምስጢር ፍቻ ሁናቴ)

ተዳነ ውጤቱ ጽሁፍ `.tar.gz` ፋይል ሆኖ ይቀምራሉ ስለዚህ `tar -tzf` ያሉ መሳሪያዎች ሊፈትሹት ይችላሉ።

### በኮምፒዩተር C ላይ የቴፕ ማውጫ ሠንጠረዥ ቆጠራ

`computer-c-inventory-tape.sh` ተጠቅሞ ምልክት-በምልክት ማውጫ ሠንጠረዥ ያትሙ፦

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

ውጤቱ ዓምዶቹ የሚከተሉትን ያካትታሉ፦

- `file_marker`፦ ዜሮ ከሚጀምር ቴፕ ፋይል ምልክት ቦታ
- `status`፦ `ok`፣ `decrypted`፣ ወይም `unreadable`
- `encrypted`፦ ግቤቱ ለመፈተሽ ምስጢር ፍቻ ያስፈለገ ወይም አይደለ (`yes`/`no`)
- `archive_hint`፦ ወሰኖቹ ሲታወቁ የተቀነሰ ማህደር-ዓይነት ስም
- `first_member` / `last_member`፦ ያ ምልክት ውስጥ ታዩ የመጀመሪያ እና የመጨረሻ tar አባሎች
- `member_count`፦ ያ ምልክት ውስጥ ተገኙ tar አባሎች ቁጥር
- `bytes`፦ ያ ምልክት ላይ ተነበቡ ጥሬ ባይቶች

ይህ ኦፕሬተሩ ከማስተላለፍ ስራ በፊት ሊፈልጉት የሚፈልጉትን ምልክት ጠቋሚ (`mt fsf <N>`) እንዲለዩ ያስችላሉ።

### ወሳኝ A/B/C ውህደት ፈተና

`scripts/test-computer-a-b-c-integration.sh` ተጠቅሞ ያለፈ ጊዜ ሳይጠቀሙ የኮምፒዩተሮች A፣ B እና C ጫፍ-ወደ-ጫፍ ውህደት ያረጋግጡ፦

```sh
scripts/test-computer-a-b-c-integration.sh
```

ይህ ስክሪፕ፦

1. A ምዝግብ ማስታወሻ ሲጽፍ ይምስላሉ።
2. B ሽክርክሪት እና ዕለታዊ ማህደር ፈጠራ ያካሂዳሉ።
3. C ወደሚቀበለው ዝውውር ይምስላሉ።
4. C ቀበላ + ወደ ቴፕ ጽሁፍ ያካሂዳሉ።
5. ማህደሩን ከቴፕ ይመልሱና ይዘቱን ያረጋግጣሉ።

ባህሪ ሊደገም የሚችል እና ወቅታዊ ቀን/ጊዜ ሳይገደብ ቋሚ ቀን ምልክት ይጠቀማሉ (`TEST_DAY_STAMP`፤ ነባሪ `20260101`)።

### ያልተረጋገጡ ዳታዎች ደህንነቱ የተጠበቀ ከ72-ሰዓት ማቆያ

ስክሪፖቹ አሁን ነባሪ 72-ሰዓት ማቆያ ወቅት ይጠቀማሉ፦

- `computer-b-hourly-rotate.sh` አሮጌ ሰዓታዊ ምዝግብ ማስታወሻዎችን ሲያስወግዱ ተዛማጅ ሃቅ `.taped` ማረጋገጫ ምልክት ሲኖር ብቻ ነው።
- `computer-b-send-archives.sh` አሮጌ ሃቅ ማህደሮችን ሲያስወግዱ `.sent` እና ሃቅ `.taped` ማረጋገጫ ምልክቶች ሲኖሩ ብቻ ነው።
- `computer-c-write-to-tape.sh` አሮጌ ማህደሮችን ሲያስወግዱ `.taped` ምልክቶች ቀደም ሲሉ ሲኖሯቸው ብቻ ነው።

ስለዚህ ወደ ቴፕ ተላልፎ ተቀዳ ስኬት ያልተረጋገጡ ፋይሎች ከ`RETENTION_HOURS` (ነባሪ `72`) ሲበልጡ ሳይቀም ይቆያሉ።
ኮምፒዩተር B ላይ ሃቅ ጽዳት ሃቅ `.taped` ምልክቶች ይጠይቃሉ (ለምሳሌ ተመልሶ-ማስተላለፍ ደረጃ ወይም ዕጅ-ማረጋገጫ ሂደት)።
ኮምፒዩተር C ላይ ማቆያ እድሜ ከ`.taped` ምልክት ማሻሻያ ጊዜ ይለካሉ (ብዙውን ጊዜ ስኬታማ ቴፕ ጽሁፍ ጊዜ ይዘጋጃሉ)።

## የፓይፕላይን ንድፎች

- [የA/B/C Mermaid የቅደም ተከተል እና የሁኔታ ንድፎች](pipeline-diagrams/README.am.md)
