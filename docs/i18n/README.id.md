# FreeBSDOpenBSDTapeOps (Bahasa Indonesia)

Skrip shell interaktif yang memandu operasi pita magnetik umum menggunakan `mt` dan `tar`.

## Indeks Dokumentasi Bahasa

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


## Skrip

| Skrip | OS Target |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Kedua skrip menjalankan urutan operasi yang sama:

1. Meminta pengguna mengonfirmasi pita sudah dimuat.
2. Memundurkan pita ke awal.
3. Menampilkan status pita.
4. Menampilkan isi arsip pada posisi berkas 0, 1, 2, dan 3 dengan `tar t`.
5. Menjadikan pita offline.

Setiap langkah berhenti dan menunggu pengguna menekan **Enter** sebelum lanjut, sehingga skrip cocok untuk demo interaktif atau panduan langkah demi langkah.

## Perbedaan Antara Dua Skrip

### 1. Jalur perangkat pita

Skrip menargetkan node perangkat pita yang berbeda:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Keduanya adalah node perangkat non-rewinding (awalan `n`), sehingga posisi pita dipertahankan antarperintah dan skrip mengatur posisi secara eksplisit dengan `mt rewind` dan `mt fsf`.

### 2. Langkah memuat pita

- **FreeBSD**: Menjalankan `mt -f /dev/nsa0 load` saat startup untuk memuat kartrid pita ke drive secara mekanis sebelum rewind.
- **OpenBSD**: Melewati perintah `load` karena `mt(1)` OpenBSD tidak mendukung subperintah `load`. Skrip OpenBSD mengasumsikan pita sudah ada di drive dan langsung melakukan rewind.

## Skrip Pipeline Log OpenBSD A-ke-B-ke-C

Direktori `scripts/` menyediakan skrip untuk skenario ketika Komputer B OpenBSD menerima entri rsyslog dari Komputer A, membundelnya harian, mengirimkannya ke salah satu dari beberapa server Komputer C, lalu Komputer C menuliskannya ke pita.

| Skrip | Tujuan |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Membuat log rotasi per jam dari berkas input rsyslog aktif di Komputer B. |
| `scripts/computer-b-daily-archive.sh` | Membundel log per jam satu hari (`YYYYMMDD`) menjadi arsip `.tar.gz` dengan rentang waktu di Komputer B, tidak termasuk jam saat ini agar tidak konflik dengan penulisan aktif. |
| `scripts/computer-b-send-archives.sh` | Mengirim arsip harian yang belum terkirim (`.tar.gz` dan opsional `.tar.gz.enc`) dari Komputer B ke satu atau lebih server Komputer C melalui `scp`. |
| `scripts/computer-c-receive-archives.sh` | Memvalidasi arsip plaintext yang masuk dan mengantrikan arsip plaintext/terenkripsi untuk pita. |
| `scripts/computer-c-write-to-tape.sh` | Menulis arsip plaintext atau terenkripsi yang diantrikan ke pita, mengecek ruang, menambahkan dengan aman, dan menandainya telah direkam. |
| `scripts/computer-c-inventory-tape.sh` | Mencetak daftar isi pita berdasarkan marker berkas agar operator cepat menemukan arsip. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Memindai posisi berkas pita untuk arsip yang diminta, mendekripsi bila perlu, dan menyimpan data pemulihan ke berkas. |
| `scripts/test-computer-a-b-c-integration.sh` | Menjalankan uji integrasi lokal A→B→C yang deterministik (termasuk pemulihan pita) dan tidak bergantung pada waktu dinding. |

Penjadwalan umum:

- Jalankan `computer-b-hourly-rotate.sh` setiap jam (cron di B).
- Jalankan `computer-b-daily-archive.sh` sekali per hari (cron di B).
- Jalankan `computer-b-send-archives.sh` setelah pembuatan arsip (cron di B).
- Jalankan `computer-c-receive-archives.sh` secara berkala di C.
- Jalankan `computer-c-write-to-tape.sh` secara berkala di C dengan perangkat pita yang benar.
- Jalankan `computer-c-inventory-tape.sh` di C saat Anda memerlukan daftar isi per marker.
- Jalankan `computer-c-restore-archive-from-tape.sh` di C saat Anda perlu memulihkan arsip tertentu untuk inspeksi.

Semua skrip pipeline juga mengirim pesan operasional ke syslog melalui `logger` (misalnya terlihat via rsyslog/journaling) selain output konsol.

### Pengiriman multi-server dari Komputer B

`computer-b-send-archives.sh` mendukung mode server tunggal maupun multi-server:

- Server tunggal: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opsi pemilihan server di sisi klien:

- Berikan satu server pada argumen untuk mengunci ke satu Komputer C.
- Berikan beberapa server untuk memungkinkan fallback.
- Setel `PREFERRED_SERVER=user@host` untuk memilih satu server tertentu dari daftar yang diberikan.

Opsi penanganan status sibuk di Komputer B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): berkas penanda yang dicek di sisi remote.
- `BUSY_RETRY_SECONDS` (default: `60`): waktu tunggu antar percobaan saat server sibuk.
- `BUSY_MAX_RETRIES` (default: `10`): jumlah maksimum percobaan ulang per server.

### Publikasi status sibuk dari Komputer C

`computer-c-write-to-tape.sh` membuat penanda sibuk saat aktif menulis arsip ke pita dan menghapusnya saat idle.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Arahkan `REMOTE_BUSY_MARKER` di Komputer B ke lokasi penanda yang digunakan Komputer C.

### Keamanan pita dan perilaku append di Komputer C

Sebelum menulis tiap arsip, `computer-c-write-to-tape.sh` mengecek kapasitas pita/perangkat yang tersedia dan memerlukan setidaknya:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variabel terkait:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override untuk ruang tersedia yang sudah diketahui)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (mengizinkan penulisan jika ruang tidak dapat dideteksi)

Untuk perangkat pita nyata, penulis akan mencari ke akhir data (`mt eom`/`mt eod`) sebelum menulis, sehingga beberapa arsip ditambahkan (append) alih-alih menimpa isi pita sebelumnya.

### Timestamp yang mudah dibaca manusia pada nama file

- Log per jam dinamai seperti: `rsyslog-2026-06-01T1600.log`
- Arsip harian dinamai seperti: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Rentang arsip harian didasarkan pada berkas per jam pertama dan terakhir yang benar-benar ikut dalam arsip.
Nama-nama ini dimaksudkan agar mudah dibaca manusia saat menelusuri rentang tanggal/waktu kejadian.
Jam saat ini sengaja dikecualikan dari pembuatan arsip agar penulisan aktif tidak ikut terkirim.

### Enkripsi OpenSSL opsional untuk arsip harian

`computer-b-daily-archive.sh` dapat mengenkripsi arsip dengan OpenSSL setelah membuat tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` untuk enkripsi simetris (`openssl enc`, cipher default `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` untuk enkripsi sertifikat penerima (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` untuk memilih cipher OpenSSL pada mode key-file dan sertifikat (default: `aes-256-gcm`).

Hanya satu dari opsi ini yang boleh disetel pada saat yang sama. Output terenkripsi menggunakan `.tar.gz.enc`.
Demi keamanan, skrip menolak pilihan cipher lemah atau non-AEAD dan mewajibkan cipher kelas GCM/poly1305.

### Pemulihan arsip dari pita di Komputer C

Gunakan `computer-c-restore-archive-from-tape.sh` untuk menemukan arsip tertentu dengan mencari berkas pita berurutan dari awal:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Untuk nama arsip seperti `rsyslog-<start>_to_<end>.tar.gz` (atau `.tar.gz.enc`), skrip mengidentifikasi kecocokan yang benar dengan memeriksa bahwa berkas batas per jam ada di payload hasil pemulihan.
- Jika penamaan arsip Anda berbeda, setel `TARGET_MEMBER_GLOB` ke pola shell yang cocok dengan anggota yang wajib ada di arsip.
- Jika arsip terenkripsi, berikan pengaturan dekripsi sesuai kebutuhan:
  - `OPENSSL_DECRYPT_KEY_FILE` (mode simetris `openssl enc`; cipher dekripsi default: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` dan `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mode dekripsi S/MIME)

Output yang dipulihkan ditulis sebagai berkas `.tar.gz` plaintext agar dapat diperiksa dengan alat seperti `tar -tzf`.

### Inventaris daftar isi pita di Komputer C

Gunakan `computer-c-inventory-tape.sh` untuk mencetak daftar isi per marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Kolom output mencakup:

- `file_marker`: posisi marker berkas pita berbasis nol
- `status`: `ok`, `decrypted`, atau `unreadable`
- `encrypted`: apakah dekripsi diperlukan untuk memeriksa entri (`yes`/`no`)
- `archive_hint`: nama bergaya arsip yang diinferensikan saat batas dapat dikenali
- `first_member` / `last_member`: anggota tar pertama dan terakhir yang terlihat pada marker tersebut
- `member_count`: jumlah anggota tar yang ditemukan pada marker tersebut
- `bytes`: byte mentah yang dibaca pada marker tersebut

Ini memungkinkan operator menentukan indeks marker untuk dicari (`mt fsf <N>`) sebelum operasi pemulihan.

### Uji integrasi A/B/C yang deterministik

Gunakan `scripts/test-computer-a-b-c-integration.sh` untuk memvalidasi integrasi end-to-end Komputer A, B, dan C terlepas dari waktu yang berlalu:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Skrip ini:

1. Mensimulasikan A menulis log.
2. Menjalankan rotasi dan pembuatan arsip harian di B.
3. Mensimulasikan transfer ke incoming C.
4. Menjalankan penerimaan C + write-to-tape.
5. Memulihkan arsip dari pita dan memvalidasi konten.

Skrip ini menggunakan cap hari tetap (`TEST_DAY_STAMP`, default `20260101`) sehingga perilaku dapat diulang dan tidak terikat pada tanggal/waktu saat ini.

### Retensi 72 jam dengan keamanan untuk data yang belum terkonfirmasi

Skrip kini default ke jendela retensi 72 jam:

- `computer-b-hourly-rotate.sh` hanya menghapus log per jam lama saat ada penanda konfirmasi `.taped` lokal yang cocok.
- `computer-b-send-archives.sh` hanya menghapus arsip lokal lama saat penanda `.sent` dan penanda konfirmasi `.taped` lokal keduanya ada.
- `computer-c-write-to-tape.sh` hanya menghapus arsip lama yang sudah memiliki penanda `.taped`.

Akibatnya, berkas yang belum berhasil ditransmisikan dan direkam ke pita tetap dipertahankan walau lebih tua dari `RETENTION_HOURS` (default `72`).
Di Komputer B, pembersihan lokal memerlukan penanda `.taped` lokal (misalnya dari langkah sinkronisasi balik atau proses konfirmasi manual).
Di Komputer C, umur retensi diukur dari waktu modifikasi penanda `.taped` (biasanya disetel pada saat penulisan pita berhasil).

## Diagram Pipeline

- [Diagram urutan dan status Mermaid A/B/C](pipeline-diagrams/README.id.md)
