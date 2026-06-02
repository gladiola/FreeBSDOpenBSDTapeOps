# FreeBSDOpenBSDTapeOps (Bahasa Melayu)

Skrip shell interaktif yang menerangkan operasi pita magnetik biasa menggunakan `mt` dan `tar`.

## Indeks Dokumentasi Bahasa

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


## Skrip

| Skrip | OS Sasaran |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Kedua-dua skrip melaksanakan urutan operasi yang sama:

1. Minta pengguna mengesahkan pita telah dimuatkan.
2. Undur semula pita ke awal.
3. Paparkan status pita.
4. Senaraikan kandungan arkib pada kedudukan fail 0, 1, 2, dan 3 menggunakan `tar t`.
5. Letakkan pita dalam mod luar talian.

Setiap langkah berhenti seketika dan menunggu pengguna menekan **Enter** sebelum meneruskan, menjadikan skrip ini sesuai sebagai demonstrasi interaktif atau panduan langkah demi langkah.

## Perbezaan Antara Dua Skrip

### 1. Laluan peranti pita

Skrip menyasarkan nod peranti pita yang berbeza:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Kedua-duanya ialah nod peranti tidak-undur semula (awalan `n`), jadi kedudukan pita dikekalkan antara arahan dan skrip mengawal kedudukan secara jelas dengan `mt rewind` dan `mt fsf`.

### 2. Langkah memuatkan pita

- **FreeBSD**: Menjalankan `mt -f /dev/nsa0 load` ketika permulaan untuk memuatkan kartrij pita secara mekanikal ke dalam pemacu sebelum undur semula.
- **OpenBSD**: Melangkau arahan `load` kerana `mt(1)` pada OpenBSD tidak menyokong subarahan `load`. Skrip OpenBSD menganggap pita sudah berada dalam pemacu dan terus melakukan undur semula.

## Skrip Paip Log OpenBSD A-ke-B-ke-C

Direktori `scripts/` menyediakan skrip untuk senario di mana Komputer B OpenBSD menerima entri rsyslog daripada Komputer A, membungkusnya setiap hari, menghantarnya ke salah satu daripada beberapa pelayan Komputer C, dan Komputer C menulisnya ke pita.

| Skrip | Tujuan |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Mencipta log putaran setiap jam daripada fail input rsyslog aktif pada Komputer B. |
| `scripts/computer-b-daily-archive.sh` | Membungkus log setiap jam untuk satu hari (`YYYYMMDD`) ke dalam arkib `.tar.gz` berjulatan masa pada Komputer B, tidak termasuk jam semasa untuk mengelak konflik tulis aktif. |
| `scripts/computer-b-send-archives.sh` | Menghantar arkib harian yang belum dihantar (`.tar.gz` dan pilihan `.tar.gz.enc`) daripada Komputer B ke satu atau lebih pelayan Komputer C melalui `scp`. |
| `scripts/computer-c-receive-archives.sh` | Mengesahkan arkib plaintext masuk dan memasukkan arkib plaintext/tersulit ke dalam giliran untuk pita. |
| `scripts/computer-c-write-to-tape.sh` | Menulis arkib plaintext atau tersulit yang beratur ke pita, menyemak ruang, menambah secara selamat, dan menandakannya sebagai direkodkan. |
| `scripts/computer-c-inventory-tape.sh` | Mencetak senarai kandungan pita mengikut penanda fail supaya operator boleh mencari arkib dengan cepat. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Mengimbas kedudukan fail pita untuk arkib diminta, menyahsulit bila perlu, dan menyimpan data dipulihkan ke fail. |
| `scripts/test-computer-a-b-c-integration.sh` | Menjalankan ujian integrasi tempatan A→B→C yang deterministik (termasuk pemulihan pita) yang tidak bergantung kepada masa jam sebenar. |

Jadual biasa:

- Jalankan `computer-b-hourly-rotate.sh` setiap jam (cron pada B).
- Jalankan `computer-b-daily-archive.sh` sekali sehari (cron pada B).
- Jalankan `computer-b-send-archives.sh` selepas arkib dicipta (cron pada B).
- Jalankan `computer-c-receive-archives.sh` secara berkala pada C.
- Jalankan `computer-c-write-to-tape.sh` secara berkala pada C dengan peranti pita yang betul.
- Jalankan `computer-c-inventory-tape.sh` pada C apabila anda memerlukan jadual kandungan penanda demi penanda.
- Jalankan `computer-c-restore-archive-from-tape.sh` pada C apabila anda perlu memulihkan arkib tertentu untuk pemeriksaan.

Semua skrip paip juga menghantar mesej operasi ke syslog melalui `logger` (contohnya boleh dilihat melalui rsyslog/journaling) selain output konsol.

### Penghantaran multi-pelayan dari Komputer B

`computer-b-send-archives.sh` menyokong mod pelayan tunggal dan mod multi-pelayan:

- Pelayan tunggal: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-pelayan: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Pilihan pemilihan pelayan di sisi klien:

- Sediakan satu pelayan dalam argumen untuk mengunci kepada satu Komputer C.
- Sediakan beberapa pelayan untuk membolehkan fallback.
- Tetapkan `PREFERRED_SERVER=user@host` untuk memilih satu pelayan tertentu daripada senarai yang diberi.

Pilihan pengendalian keadaan sibuk pada Komputer B:

- `REMOTE_BUSY_MARKER` (lalai: `.busy`): fail penanda yang diperiksa pada sisi jauh.
- `BUSY_RETRY_SECONDS` (lalai: `60`): masa tunggu antara cubaan semula ketika pelayan sibuk.
- `BUSY_MAX_RETRIES` (lalai: `10`): bilangan maksimum cubaan semula bagi setiap pelayan.

### Penerbitan keadaan sibuk daripada Komputer C

`computer-c-write-to-tape.sh` mencipta penanda sibuk semasa aktif menulis arkib ke pita dan membuangnya apabila melahu.

- `BUSY_MARKER` (lalai: `<received_dir>/.busy`)

Halakan `REMOTE_BUSY_MARKER` pada Komputer B ke lokasi penanda yang digunakan oleh Komputer C.

### Keselamatan pita dan tingkah laku append pada Komputer C

Sebelum menulis setiap arkib, `computer-c-write-to-tape.sh` menyemak kapasiti pita/peranti yang tersedia dan memerlukan sekurang-kurangnya:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Pemboleh ubah berkaitan:

- `TAPE_SAFETY_MARGIN_BYTES` (lalai: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override untuk ruang tersedia yang diketahui)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (membenarkan penulisan jika ruang tidak dapat dikesan)

Untuk peranti pita sebenar, penulis mencari hujung data (`mt eom`/`mt eod`) sebelum menulis, jadi berbilang arkib akan ditambah (append) dan bukannya menimpa kandungan pita terdahulu.

### Cap masa mudah baca manusia dalam nama fail

- Log setiap jam dinamakan seperti: `rsyslog-2026-06-01T1600.log`
- Arkib harian dinamakan seperti: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Julat arkib harian berdasarkan fail jam pertama dan terakhir yang benar-benar dimasukkan dalam arkib.
Nama ini bertujuan supaya mudah dibaca manusia ketika meneliti julat tarikh/masa kejadian.
Jam semasa sengaja dikecualikan daripada penciptaan arkib supaya penulisan aktif tidak dihantar.

### Penyulitan OpenSSL pilihan untuk arkib harian

`computer-b-daily-archive.sh` boleh menyulitkan arkib menggunakan OpenSSL selepas menghasilkan tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` untuk penyulitan simetri (`openssl enc`, sifir lalai `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` untuk penyulitan sijil penerima (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` untuk memilih sifir OpenSSL bagi mod key-file dan sijil (lalai: `aes-256-gcm`).

Hanya satu daripada pilihan ini boleh ditetapkan pada satu masa. Output tersulit menggunakan `.tar.gz.enc`.
Demi keselamatan, skrip menolak pilihan sifir lemah atau bukan AEAD dan memerlukan sifir kelas GCM/poly1305.

### Pemulihan arkib daripada pita pada Komputer C

Gunakan `computer-c-restore-archive-from-tape.sh` untuk mencari arkib tertentu dengan mengimbas fail pita mengikut turutan dari awal:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Untuk nama arkib seperti `rsyslog-<start>_to_<end>.tar.gz` (atau `.tar.gz.enc`), skrip mengenal pasti padanan yang betul dengan memeriksa bahawa fail sempadan jam wujud dalam muatan data yang dipulihkan.
- Jika penamaan arkib anda berbeza, tetapkan `TARGET_MEMBER_GLOB` kepada corak shell yang sepadan dengan ahli yang mesti wujud dalam arkib.
- Jika arkib tersulit, berikan tetapan nyahsulit mengikut keperluan:
  - `OPENSSL_DECRYPT_KEY_FILE` (mod simetri `openssl enc`; sifir nyahsulit lalai: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` dan `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mod nyahsulit S/MIME)

Output dipulihkan ditulis sebagai fail `.tar.gz` plaintext supaya boleh diperiksa dengan alat seperti `tar -tzf`.

### Inventori jadual kandungan pita pada Komputer C

Gunakan `computer-c-inventory-tape.sh` untuk mencetak jadual kandungan penanda demi penanda:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Lajur output merangkumi:

- `file_marker`: kedudukan penanda fail pita berasaskan sifar
- `status`: `ok`, `decrypted`, atau `unreadable`
- `encrypted`: sama ada nyahsulit diperlukan untuk memeriksa entri (`yes`/`no`)
- `archive_hint`: nama gaya arkib yang dianggar apabila sempadan dapat dikenal pasti
- `first_member` / `last_member`: ahli tar pertama dan terakhir yang dilihat pada penanda tersebut
- `member_count`: bilangan ahli tar yang ditemui pada penanda tersebut
- `bytes`: bait mentah dibaca pada penanda tersebut

Ini membolehkan operator mengenal pasti indeks penanda untuk dicari (`mt fsf <N>`) sebelum operasi pemulihan.

### Ujian integrasi A/B/C yang deterministik

Gunakan `scripts/test-computer-a-b-c-integration.sh` untuk mengesahkan integrasi hujung ke hujung Komputer A, B, dan C tanpa mengira masa berlalu:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Skrip ini:

1. Mensimulasikan A menulis log.
2. Menjalankan putaran B dan penciptaan arkib harian.
3. Mensimulasikan pemindahan ke incoming C.
4. Menjalankan receive C + write-to-tape.
5. Memulihkan arkib daripada pita dan mengesahkan kandungan.

Ia menggunakan cap hari tetap (`TEST_DAY_STAMP`, lalai `20260101`) supaya tingkah laku boleh diulang dan tidak terikat pada tarikh/masa semasa.

### Pengekalan 72 jam dengan keselamatan untuk data belum disahkan

Skrip kini lalai kepada tetingkap pengekalan 72 jam:

- `computer-b-hourly-rotate.sh` hanya membuang log jam lama apabila penanda pengesahan `.taped` tempatan yang sepadan wujud.
- `computer-b-send-archives.sh` hanya membuang arkib tempatan lama apabila kedua-dua penanda `.sent` dan `.taped` tempatan wujud.
- `computer-c-write-to-tape.sh` hanya membuang arkib lama yang sudah mempunyai penanda `.taped`.

Akibatnya, fail yang belum berjaya dihantar dan direkodkan ke pita akan dikekalkan walaupun lebih lama daripada `RETENTION_HOURS` (lalai `72`).
Pada Komputer B, pembersihan tempatan memerlukan penanda `.taped` tempatan (contohnya daripada langkah sync-back atau proses pengesahan manual).
Pada Komputer C, umur pengekalan diukur daripada masa ubah suai penanda `.taped` (biasanya ditetapkan pada masa penulisan pita berjaya).

## Rajah Pipeline

- [Rajah urutan dan keadaan Mermaid A/B/C](pipeline-diagrams/README.ms.md)
