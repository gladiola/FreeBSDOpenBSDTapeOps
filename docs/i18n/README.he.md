# FreeBSDOpenBSDTapeOps (עברית)

סקריפטי מעטפת אינטראקטיביים שמובילים צעד אחר צעד דרך פעולות נפוצות של סרט מגנטי באמצעות `mt` ו-`tar`.

## אינדקס תיעוד שפות

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


## סקריפטים

| סקריפט | מערכת הפעלה יעד |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

שני הסקריפטים מבצעים את אותו רצף פעולות:

1. מבקשים מהמשתמש לאשר שהסרט נטען.
2. מלפפים את הסרט להתחלה.
3. מדפיסים את מצב הסרט.
4. מציגים את תוכן הארכיונים במיקומי הקבצים 0, 1, 2 ו-3 באמצעות `tar t`.
5. מעבירים את הסרט למצב לא מקוון.

כל שלב נעצר וממתין שהמשתמש ילחץ על **Enter** לפני ההמשך, ולכן הסקריפטים מתאימים להדגמות אינטראקטיביות או לסיורים מודרכים.

## ההבדלים בין שני הסקריפטים

### 1. נתיב התקן הסרט

הסקריפטים מכוונים לצמתי התקן סרט שונים:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

שניהם צומתי התקן ללא ליפוף אוטומטי (הקידומת `n`), ולכן מיקום הסרט נשמר בין הפקודות והסקריפטים שולטים במיקום באופן מפורש באמצעות `mt rewind` ו-`mt fsf`.

### 2. שלב טעינת הסרט

- **FreeBSD**: מפעיל את `mt -f /dev/nsa0 load` בעת האתחול כדי לטעון מכנית את קלטת הסרט לכונן לפני הליפוף.
- **OpenBSD**: מדלג על הפקודה `load` משום ש-`mt(1)` של OpenBSD אינו תומך בתת-פקודה `load`. סקריפט OpenBSD מניח שהסרט כבר נמצא בכונן וממשיך ישירות לליפוף.

## סקריפטי צינור לוגים OpenBSD A-to-B-to-C

הספרייה `scripts/` מספקת סקריפטים לתרחיש שבו OpenBSD Computer B מקבל רשומות rsyslog מ-Computer A, מאגד אותן מדי יום, שולח אותן לאחד מכמה שרתי Computer C, ו-Computer C כותב אותן לסרט.

| סקריפט | מטרה |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | יוצר לוג מחזורי שעתי מתוך קובץ הקלט הפעיל של rsyslog ב-Computer B. |
| `scripts/computer-b-daily-archive.sh` | מאגד יום אחד (`YYYYMMDD`) של לוגים שעתיים לארכיון `.tar.gz` בעל טווח זמנים ב-Computer B, תוך החרגת השעה הנוכחית כדי להימנע מהתנגשויות כתיבה פעילות. |
| `scripts/computer-b-send-archives.sh` | שולח ארכיונים יומיים שלא נשלחו (`.tar.gz` ו-`.tar.gz.enc` אופציונלי) מ-Computer B לשרת Computer C אחד או יותר דרך `scp`. |
| `scripts/computer-c-receive-archives.sh` | מאמת ארכיוני טקסט-גלוי נכנסים ומכניס ארכיוני טקסט-גלוי/מוצפנים לתור עבור סרט. |
| `scripts/computer-c-write-to-tape.sh` | כותב ארכיוני טקסט-גלוי או מוצפנים שנמצאים בתור לסרט, בודק מקום, מבצע הוספה בצורה בטוחה ומסמן אותם כ-נרשמו. |
| `scripts/computer-c-inventory-tape.sh` | מדפיס תוכן עניינים של הסרט לפי file marker כדי שמפעילים יוכלו לאתר ארכיונים במהירות. |
| `scripts/computer-c-restore-archive-from-tape.sh` | סורק את מיקומי הקבצים בסרט עבור ארכיון מבוקש, מבצע פענוח בעת הצורך ושומר את הנתונים ששוחזרו לקובץ. |
| `scripts/test-computer-a-b-c-integration.sh` | מריץ בדיקת אינטגרציה מקומית דטרמיניסטית A→B→C (כולל שחזור מהסרט) שאינה תלויה ב-תזמון לפי שעון אמיתי. |

תזמון טיפוסי:

- הריצו את `computer-b-hourly-rotate.sh` בכל שעה (cron על B).
- הריצו את `computer-b-daily-archive.sh` פעם ביום (cron על B).
- הריצו את `computer-b-send-archives.sh` לאחר יצירת הארכיון (cron על B).
- הריצו את `computer-c-receive-archives.sh` מעת לעת על C.
- הריצו את `computer-c-write-to-tape.sh` מעת לעת על C עם התקן הסרט הנכון.
- הריצו את `computer-c-inventory-tape.sh` על C כאשר אתם צריכים תוכן עניינים לפי סמן-אחר-סמן.
- הריצו את `computer-c-restore-archive-from-tape.sh` על C כאשר אתם צריכים לשחזר ארכיון מסוים לבדיקה.

כל סקריפטי הצינור פולטים גם הודעות תפעוליות ל-syslog דרך `logger` (לדוגמה, כפי שניתן לראות דרך rsyslog/יומנון) בנוסף לפלט הקונסול.

### שליחה מרובת שרתים מ-Computer B

`computer-b-send-archives.sh` תומך גם ב-מצב שרת יחיד וגם ב-מצב ריבוי שרתים:

- שרת יחיד: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- כמה שרתים: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

אפשרויות בחירת שרת בצד הלקוח:

- ספקו שרת אחד בארגומנטים כדי להצמיד ל-Computer C יחיד.
- ספקו כמה שרתים כדי לאפשר מעבר גיבוי.
- הגדירו `PREFERRED_SERVER=user@host` כדי לבחור שרת מסוים אחד מתוך הרשימה שסופקה.

אפשרויות טיפול ב-תפוס ב-Computer B:

- `REMOTE_BUSY_MARKER` (ברירת מחדל: `.busy`): קובץ סמן שנבדק בצד המרוחק.
- `BUSY_RETRY_SECONDS` (ברירת מחדל: `60`): זמן ההמתנה בין ניסיונות חוזרים בזמן שהשרת תפוס.
- `BUSY_MAX_RETRIES` (ברירת מחדל: `10`): מספר ניסיונות החזרה המרבי לכל שרת.

### פרסום מצב תפוסה מ-Computer C

`computer-c-write-to-tape.sh` יוצר סמן תפוסה בזמן כתיבה פעילה של ארכיונים לסרט ומסיר אותו כשהמערכת במצב סרק.

- `BUSY_MARKER` (ברירת מחדל: `<received_dir>/.busy`)

כוונו את `REMOTE_BUSY_MARKER` ב-Computer B אל מיקום הסמן שבו משתמש Computer C.

### בטיחות הסרט והתנהגות הוספה ב-Computer C

לפני כתיבת כל ארכיון, `computer-c-write-to-tape.sh` בודק קיבולת זמינה של הסרט/ההתקן ודורש לפחות:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

משתנים רלוונטיים:

- `TAPE_SAFETY_MARGIN_BYTES` (ברירת מחדל: `10485760`)
- `TAPE_AVAILABLE_BYTES` (עקיפה עבור מקום פנוי ידוע)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (מאפשר כתיבה אם לא ניתן לזהות את המקום)

עבור התקני סרט אמיתיים, סקריפט הכתיבה נע לסוף הנתונים (`mt eom`/`mt eod`) לפני הכתיבה, כך שכמה ארכיונים מתווספים במקום לדרוס תוכן קיים על הסרט.

### חותמות זמן קריאות לאדם בשמות קבצים

- לוגים שעתיים נקראים כך: `rsyslog-2026-06-01T1600.log`
- ארכיונים יומיים נקראים כך: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

טווחי הארכיון היומיים מבוססים על קובצי השעה הראשונים והאחרונים שנכללים בפועל בארכיון.
שמות אלה נועדו להיות קריאים לאנשים שסורקים חלונות תאריך/שעה של אירועים.
השעה הנוכחית מוחרגת בכוונה מיצירת הארכיון כדי שכתיבות פעילות לא יועברו.

### הצפנת OpenSSL אופציונלית עבור ארכיונים יומיים

`computer-b-daily-archive.sh` יכול להצפין ארכיונים באמצעות OpenSSL לאחר יצירת ארכיון tar:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` עבור הצפנה סימטרית (`openssl enc`, צופן ברירת מחדל `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` עבור הצפנה באמצעות תעודת נמען (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` לבחירת OpenSSL צופן הן במצב קובץ מפתח והן במצב אישור (ברירת מחדל: `aes-256-gcm`).

ניתן להגדיר רק אחת מהאפשרויות האלה בכל פעם. קובצי פלט מוצפנים משתמשים ב-`.tar.gz.enc`.
מטעמי אבטחה, הסקריפט דוחה בחירות צופן חלשות או שאינן AEAD ודורש צפנים מסוג GCM/poly1305.

### שחזור ארכיון מהסרט ב-Computer C

השתמשו ב-`computer-c-restore-archive-from-tape.sh` כדי לאתר ארכיון מסוים על ידי חיפוש קובצי הסרט לפי הסדר מההתחלה:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- עבור שמות ארכיון כמו `rsyslog-<start>_to_<end>.tar.gz` (או `.tar.gz.enc`), הסקריפט מזהה את ההתאמה הנכונה על ידי בדיקה שקובצי השעה שבגבולות קיימים בנתונים ששוחזרו.
- אם שמות הארכיון שלכם שונים, הגדירו `TARGET_MEMBER_GLOB` כתבנית מעטפת שתואמת לפריט שחייב להיות קיים בארכיון.
- אם ארכיון מוצפן, ספקו הגדרות פענוח לפי הצורך:
  - `OPENSSL_DECRYPT_KEY_FILE` (מצב סימטרי `openssl enc`; צופן פענוח ברירת מחדל: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` ו-`OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (מצב פענוח S/MIME)

הפלט ששוחזר נכתב כקובץ טקסט-גלוי מסוג `.tar.gz` כדי שניתן יהיה לבדוק אותו עם כלים כמו `tar -tzf`.

### אינבנטוריזציית תוכן עניינים של הסרט ב-Computer C

השתמשו ב-`computer-c-inventory-tape.sh` כדי להדפיס תוכן עניינים סמן-אחר-סמן:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

עמודות הפלט כוללות:

- `file_marker`: מיקום סמן הקובץ המבוסס על אפס על הסרט
- `status`: `ok`, `decrypted` או `unreadable`
- `מוצפנים`: האם נדרש פענוח כדי לבדוק את הרשומה (`yes`/`no`)
- `archive_hint`: שם משוער בסגנון ארכיון כאשר ניתן לזהות גבולות
- `first_member` / `last_member`: חברי ה-tar הראשונים והאחרונים שנראו באותו סמן
- `member_count`: מספר חברי ה-tar שנמצאו באותו סמן
- `bytes`: הבתים הגולמיים שנקראו באותו סמן

כך מפעיל יכול לזהות את אינדקס הסמן שאליו יש להתקדם (`mt fsf <N>`) לפני פעולות שחזור.

### בדיקת אינטגרציה דטרמיניסטית A/B/C

השתמשו ב-`scripts/test-computer-a-b-c-integration.sh` כדי לאמת אינטגרציה מקצה לקצה של המחשבים A, B ו-C ללא תלות בזמן שחלף:

```sh
scripts/test-computer-a-b-c-integration.sh
```

סקריפט זה:

1. מדמה את A כותב לוגים.
2. מריץ את הסיבוב והיצירה של ארכיון יומי ב-B.
3. מדמה העברה אל C incoming.
4. מריץ ב-C את receive + write-to-tape.
5. משחזר את הארכיון מהסרט ומאמת את התוכן.

הוא משתמש בחותמת יום קבועה (`TEST_DAY_STAMP`, ברירת מחדל `20260101`) כדי שההתנהגות תהיה חוזרת על עצמה ולא קשורה לתאריך/שעה הנוכחיים.

### שמירה של 72 שעות עם הגנה על נתונים שלא אושרו

הסקריפטים משתמשים כעת כברירת מחדל בחלון שמירה של 72 שעות:

- `computer-b-hourly-rotate.sh` מסיר לוגים שעתיים ישנים רק כאשר קיים marker אישור מקומי תואם מסוג `.taped`.
- `computer-b-send-archives.sh` מסיר ארכיונים מקומיים ישנים רק כאשר קיימים גם marker אישור `.sent` וגם marker אישור מקומי `.taped`.
- `computer-c-write-to-tape.sh` מסיר רק ארכיונים ישנים שכבר יש להם markers מסוג `.taped`.

כתוצאה מכך, קבצים שעדיין לא הועברו ונרשמו בהצלחה על הסרט נשמרים גם כאשר הם ישנים יותר מ-`RETENTION_HOURS` (ברירת מחדל `72`).
ב-Computer B, ניקוי מקומי מחייב markers מקומיים מסוג `.taped` (לדוגמה, משלב סנכרון חוזר או מתהליך אישור ידני).
ב-Computer C, גיל ה-שמירה נמדד לפי זמן השינוי של marker `.taped` (בדרך כלל נקבע בזמן כתיבה מוצלחת לסרט).

## תרשימי צינור העיבוד

- [תרשימי Mermaid של רצף ומצבים עבור A/B/C](pipeline-diagrams/README.he.md)
