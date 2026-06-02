# FreeBSDOpenBSDTapeOps (ไทย)

สคริปต์เชลล์แบบโต้ตอบที่พาใช้งานขั้นตอนทั่วไปของเทปแม่เหล็กด้วย `mt` และ `tar`.

## ดัชนีเอกสารภาษา

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


## สคริปต์

| สคริปต์ | ระบบปฏิบัติการเป้าหมาย |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

ทั้งสองสคริปต์ทำงานตามลำดับเดียวกัน:

1. ขอให้ผู้ใช้ยืนยันว่าใส่เทปแล้ว.
2. รีไวน์เทปกลับต้น.
3. แสดงสถานะเทป.
4. แสดงรายการเนื้อหาของอาร์ไคฟ์ที่ตำแหน่งไฟล์ 0, 1, 2 และ 3 ด้วย `tar t`.
5. นำเทปออกจากโหมดใช้งาน (offline).

แต่ละขั้นจะหยุดและรอให้ผู้ใช้กด **Enter** ก่อนดำเนินการต่อ ทำให้เหมาะกับการสาธิตแบบโต้ตอบหรือการสอนแบบทีละขั้น.

## ความแตกต่างระหว่างสองสคริปต์

### 1. พาธของอุปกรณ์เทป

สคริปต์ใช้โหนดอุปกรณ์เทปคนละตัว:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

ทั้งสองเป็นอุปกรณ์แบบไม่รีไวน์อัตโนมัติ (คำนำหน้า `n`) จึงคงตำแหน่งเทปไว้ระหว่างคำสั่ง และสคริปต์ควบคุมตำแหน่งเองด้วย `mt rewind` และ `mt fsf`.

### 2. ขั้นตอนโหลดเทป

- **FreeBSD**: เรียก `mt -f /dev/nsa0 load` ตอนเริ่ม เพื่อโหลดตลับเทปเข้าไดรฟ์เชิงกลก่อนรีไวน์.
- **OpenBSD**: ข้ามคำสั่ง `load` เพราะ `mt(1)` บน OpenBSD ไม่รองรับ subcommand `load`. สคริปต์ OpenBSD จึงสมมติว่าใส่เทปไว้แล้วและรีไวน์ทันที.

## สคริปต์ไปป์ไลน์ล็อก OpenBSD A-to-B-to-C

ไดเรกทอรี `scripts/` มีสคริปต์สำหรับสถานการณ์ที่คอมพิวเตอร์ OpenBSD B รับ rsyslog จากคอมพิวเตอร์ A, จัดกลุ่มรายวัน, ส่งไปยังหนึ่งในหลายเซิร์ฟเวอร์คอมพิวเตอร์ C และให้คอมพิวเตอร์ C เขียนลงเทป.

| สคริปต์ | วัตถุประสงค์ |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | สร้างไฟล์ล็อกแบบหมุนรายชั่วโมงจากไฟล์ rsyslog ที่ใช้งานอยู่บนคอมพิวเตอร์ B. |
| `scripts/computer-b-daily-archive.sh` | รวมล็อกรายชั่วโมงของหนึ่งวัน (`YYYYMMDD`) เป็นอาร์ไคฟ์ `.tar.gz` แบบมีช่วงเวลา บนคอมพิวเตอร์ B โดยไม่นำชั่วโมงปัจจุบันเข้าไปเพื่อลดปัญหาชนกับการเขียนที่กำลังทำงาน. |
| `scripts/computer-b-send-archives.sh` | ส่งอาร์ไคฟ์รายวันที่ยังไม่ส่ง (`.tar.gz` และตัวเลือก `.tar.gz.enc`) จากคอมพิวเตอร์ B ไปยังคอมพิวเตอร์ C หนึ่งหรือหลายเครื่องผ่าน `scp`. |
| `scripts/computer-c-receive-archives.sh` | ตรวจสอบอาร์ไคฟ์ plaintext ที่เข้ามา และเข้าคิวอาร์ไคฟ์ plaintext/เข้ารหัสเพื่อเขียนลงเทป. |
| `scripts/computer-c-write-to-tape.sh` | เขียนอาร์ไคฟ์ plaintext หรือเข้ารหัสที่อยู่ในคิวลงเทป ตรวจพื้นที่ วางต่อท้ายอย่างปลอดภัย และทำเครื่องหมายว่าเขียนแล้ว. |
| `scripts/computer-c-inventory-tape.sh` | พิมพ์สารบัญเทปตาม file marker เพื่อให้ผู้ปฏิบัติงานหาอาร์ไคฟ์ได้เร็ว. |
| `scripts/computer-c-restore-archive-from-tape.sh` | สแกนตำแหน่งไฟล์บนเทปเพื่อหาอาร์ไคฟ์ที่ต้องการ ถอดรหัสเมื่อจำเป็น และบันทึกข้อมูลกู้คืนลงไฟล์. |
| `scripts/test-computer-a-b-c-integration.sh` | รันทดสอบการเชื่อมต่อ A→B→C แบบกำหนดผลได้แน่นอนในเครื่องเดียว (รวมการกู้คืนจากเทป) โดยไม่ขึ้นกับเวลาจริง. |

ตารางเวลาที่ใช้บ่อย:

- รัน `computer-b-hourly-rotate.sh` ทุกชั่วโมง (cron บน B).
- รัน `computer-b-daily-archive.sh` วันละครั้ง (cron บน B).
- รัน `computer-b-send-archives.sh` หลังสร้างอาร์ไคฟ์ (cron บน B).
- รัน `computer-c-receive-archives.sh` เป็นระยะบน C.
- รัน `computer-c-write-to-tape.sh` เป็นระยะบน C โดยระบุอุปกรณ์เทปที่ถูกต้อง.
- รัน `computer-c-inventory-tape.sh` บน C เมื่อต้องการสารบัญแบบ marker-by-marker.
- รัน `computer-c-restore-archive-from-tape.sh` บน C เมื่อต้องการกู้อาร์ไคฟ์เฉพาะรายการเพื่อตรวจสอบ.

สคริปต์ไปป์ไลน์ทั้งหมดส่งข้อความปฏิบัติการไปยัง syslog ผ่าน `logger` (เช่นดูได้จาก rsyslog/journaling) เพิ่มเติมจากข้อความที่แสดงในคอนโซล.

### การส่งหลายเซิร์ฟเวอร์จากคอมพิวเตอร์ B

`computer-b-send-archives.sh` รองรับทั้งโหมดเซิร์ฟเวอร์เดียวและหลายเซิร์ฟเวอร์:

- เซิร์ฟเวอร์เดียว: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- หลายเซิร์ฟเวอร์: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

ตัวเลือกฝั่งไคลเอนต์สำหรับเลือกเซิร์ฟเวอร์:

- ระบุเซิร์ฟเวอร์เดียวในอาร์กิวเมนต์เพื่อบังคับไปที่คอมพิวเตอร์ C เครื่องเดียว.
- ระบุหลายเซิร์ฟเวอร์เพื่อรองรับ fallback.
- ตั้งค่า `PREFERRED_SERVER=user@host` เพื่อเลือกเซิร์ฟเวอร์เฉพาะจากรายการที่ให้มา.

ตัวเลือกจัดการสถานะ busy บนคอมพิวเตอร์ B:

- `REMOTE_BUSY_MARKER` (ค่าเริ่มต้น: `.busy`): ไฟล์ marker ที่ตรวจสอบฝั่งปลายทาง.
- `BUSY_RETRY_SECONDS` (ค่าเริ่มต้น: `60`): เวลารอระหว่างการลองใหม่เมื่อเซิร์ฟเวอร์ไม่ว่าง.
- `BUSY_MAX_RETRIES` (ค่าเริ่มต้น: `10`): จำนวนครั้งลองใหม่สูงสุดต่อเซิร์ฟเวอร์.

### การเผยแพร่สถานะ busy จากคอมพิวเตอร์ C

`computer-c-write-to-tape.sh` จะสร้าง busy marker ขณะกำลังเขียนอาร์ไคฟ์ลงเทป และลบออกเมื่อว่าง.

- `BUSY_MARKER` (ค่าเริ่มต้น: `<received_dir>/.busy`)

ตั้งค่า `REMOTE_BUSY_MARKER` บนคอมพิวเตอร์ B ให้ชี้ไปยังตำแหน่ง marker ที่คอมพิวเตอร์ C ใช้.

### ความปลอดภัยของเทปและพฤติกรรมการต่อท้ายบนคอมพิวเตอร์ C

ก่อนเขียนแต่ละอาร์ไคฟ์ `computer-c-write-to-tape.sh` จะตรวจความจุเทป/อุปกรณ์ที่มี และต้องมีอย่างน้อย:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

ตัวแปรที่เกี่ยวข้อง:

- `TAPE_SAFETY_MARGIN_BYTES` (ค่าเริ่มต้น: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override สำหรับพื้นที่ว่างที่ทราบแน่ชัด)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (อนุญาตให้เขียนแม้ตรวจพื้นที่ไม่ได้)

สำหรับอุปกรณ์เทปจริง ตัวเขียนจะเลื่อนไปท้ายข้อมูล (`mt eom`/`mt eod`) ก่อนเขียน จึงเป็นการต่อท้ายหลายอาร์ไคฟ์แทนการเขียนทับข้อมูลเก่า.

### ชื่อไฟล์ที่มี timestamp อ่านง่าย

- ล็อกรายชั่วโมงตั้งชื่อแบบ: `rsyslog-2026-06-01T1600.log`
- อาร์ไคฟ์รายวันตั้งชื่อแบบ: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

ช่วงเวลาของอาร์ไคฟ์รายวันอิงจากไฟล์รายชั่วโมงไฟล์แรกและสุดท้ายที่ถูกรวมจริง.
ชื่อนี้ออกแบบให้คนอ่านเข้าใจง่ายเมื่อไล่ดูช่วงวัน/เวลาของเหตุการณ์.
ชั่วโมงปัจจุบันถูกตัดออกโดยตั้งใจ เพื่อไม่ส่งข้อมูลที่กำลังถูกเขียนอยู่.

### การเข้ารหัส OpenSSL แบบเลือกใช้สำหรับอาร์ไคฟ์รายวัน

`computer-b-daily-archive.sh` สามารถเข้ารหัสอาร์ไคฟ์ด้วย OpenSSL หลังสร้าง tarball แล้ว:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` สำหรับการเข้ารหัสแบบ symmetric (`openssl enc`, cipher ค่าเริ่มต้น `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` สำหรับการเข้ารหัสด้วยใบรับรองผู้รับ (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` สำหรับเลือก OpenSSL cipher ทั้งโหมด key-file และ certificate (ค่าเริ่มต้น: `aes-256-gcm`).

ตั้งค่าได้ครั้งละตัวเลือกเดียวเท่านั้น เอาต์พุตที่เข้ารหัสจะใช้ `.tar.gz.enc`.
เพื่อความปลอดภัย สคริปต์จะปฏิเสธ cipher ที่อ่อนแอหรือไม่ใช่ AEAD และบังคับใช้ cipher กลุ่ม GCM/poly1305.

### การกู้อาร์ไคฟ์จากเทปบนคอมพิวเตอร์ C

ใช้ `computer-c-restore-archive-from-tape.sh` เพื่อหาอาร์ไคฟ์ที่ต้องการ โดยค้นไฟล์บนเทปจากต้นไปตามลำดับ:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- สำหรับชื่ออาร์ไคฟ์เช่น `rsyslog-<start>_to_<end>.tar.gz` (หรือ `.tar.gz.enc`) สคริปต์จะระบุรายการที่ถูกต้องโดยตรวจว่าไฟล์รายชั่วโมงขอบเขตมีอยู่ใน payload ที่กู้คืน.
- หากรูปแบบการตั้งชื่ออาร์ไคฟ์ต่างออกไป ให้ตั้ง `TARGET_MEMBER_GLOB` เป็นแพทเทิร์น shell ของ member ที่ต้องมีในอาร์ไคฟ์.
- หากอาร์ไคฟ์ถูกเข้ารหัส ให้กำหนดค่าถอดรหัสตามต้องการ:
  - `OPENSSL_DECRYPT_KEY_FILE` (โหมด symmetric `openssl enc`; decrypt cipher ค่าเริ่มต้น: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` และ `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (โหมดถอดรหัส S/MIME)

เอาต์พุตที่กู้คืนจะถูกเขียนเป็นไฟล์ `.tar.gz` แบบ plaintext เพื่อให้ตรวจได้ด้วยเครื่องมืออย่าง `tar -tzf`.

### การทำ inventory สารบัญเทปบนคอมพิวเตอร์ C

ใช้ `computer-c-inventory-tape.sh` เพื่อพิมพ์สารบัญแบบ marker-by-marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

คอลัมน์เอาต์พุตประกอบด้วย:

- `file_marker`: ตำแหน่ง file marker ของเทปแบบเริ่มที่ศูนย์
- `status`: `ok`, `decrypted` หรือ `unreadable`
- `encrypted`: ต้องถอดรหัสเพื่อตรวจ entry หรือไม่ (`yes`/`no`)
- `archive_hint`: ชื่อแนวอาร์ไคฟ์ที่อนุมานได้เมื่อระบุขอบเขตได้
- `first_member` / `last_member`: tar member ตัวแรกและตัวสุดท้ายที่พบใน marker นั้น
- `member_count`: จำนวน tar member ที่พบใน marker นั้น
- `bytes`: จำนวนไบต์ดิบที่อ่านได้ใน marker นั้น

ข้อมูลนี้ช่วยให้ผู้ปฏิบัติงานระบุ marker index ที่ต้อง seek (`mt fsf <N>`) ก่อนทำการกู้คืน.

### การทดสอบรวมระบบ A/B/C แบบกำหนดผลได้แน่นอน

ใช้ `scripts/test-computer-a-b-c-integration.sh` เพื่อตรวจสอบการทำงานครบเส้นทางของคอมพิวเตอร์ A, B และ C โดยไม่ขึ้นกับเวลาที่ผ่านไป:

```sh
scripts/test-computer-a-b-c-integration.sh
```

สคริปต์นี้จะ:

1. จำลองให้ A เขียนล็อก.
2. รันการหมุนล็อกและสร้างอาร์ไคฟ์รายวันบน B.
3. จำลองการโอนไปยังโฟลเดอร์ incoming ของ C.
4. รัน receive + write-to-tape บน C.
5. กู้อาร์ไคฟ์จากเทปและตรวจสอบเนื้อหา.

สคริปต์ใช้ day stamp คงที่ (`TEST_DAY_STAMP`, ค่าเริ่มต้น `20260101`) จึงทำซ้ำผลได้และไม่ผูกกับวัน/เวลาปัจจุบัน.

### การเก็บรักษา 72 ชั่วโมง พร้อมความปลอดภัยสำหรับข้อมูลที่ยังไม่ยืนยัน

สคริปต์ตั้งค่าเริ่มต้นเป็นหน้าต่างการเก็บรักษา 72 ชั่วโมง:

- `computer-b-hourly-rotate.sh` จะลบล็อกเก่ารายชั่วโมงเฉพาะเมื่อมี `.taped` confirmation marker ในเครื่องที่ตรงกัน.
- `computer-b-send-archives.sh` จะลบอาร์ไคฟ์เก่าในเครื่องเฉพาะเมื่อมีทั้ง `.sent` และ `.taped` confirmation marker ในเครื่อง.
- `computer-c-write-to-tape.sh` จะลบเฉพาะอาร์ไคฟ์เก่าที่มี `.taped` marker แล้ว.

ผลคือไฟล์ที่ยังส่งไม่สำเร็จหรือยังไม่ถูกบันทึกลงเทปจะยังถูกเก็บไว้ แม้เก่ากว่า `RETENTION_HOURS` (ค่าเริ่มต้น `72`).
บนคอมพิวเตอร์ B การล้างข้อมูลในเครื่องต้องมี `.taped` marker ในเครื่อง (เช่นจากขั้นตอน sync-back หรือการยืนยันด้วยมือ).
บนคอมพิวเตอร์ C อายุการเก็บรักษาจะนับจากเวลาแก้ไขของ `.taped` marker (ปกติถูกตั้งตอนเขียนเทปสำเร็จ).

## แผนภาพไปป์ไลน์

- [แผนภาพลำดับและสถานะ Mermaid ของ A/B/C](pipeline-diagrams/README.th.md)
