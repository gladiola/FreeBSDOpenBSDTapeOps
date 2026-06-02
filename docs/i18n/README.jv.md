# FreeBSDOpenBSDTapeOps (Basa Jawa)

Skrip shell interaktif kanggo nuntun operasi pita magnetik sing umum nganggo `mt` lan `tar`.

## Indeks Dokumentasi Basa

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

| Skrip | OS Tujuan |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Kaloro skrip nindakake urutan operasi sing padha:

1. Nyuwun pangguna kanggo ngonfirmasi manawa pita wis dimuat.
2. Rewind pita bali menyang wiwitan.
3. Nampilake status pita.
4. Ndhaptar isi arsip ing posisi file 0, 1, 2, lan 3 nganggo `tar t`.
5. Nggawa pita menyang mode offline.

Saben langkah mandheg lan ngenteni pangguna mencet **Enter** sadurunge nerusake, dadi skrip iki cocog kanggo demo interaktif utawa pandhuan langkah-demi-langkah.

## Bedane Rong Skrip

### 1. Jalur piranti pita

Skrip iki target node piranti pita sing beda:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Loro-lorone node piranti non-rewinding (prefiks `n`), mula posisi pita tetep dijaga antar perintah lan skrip ngatur posisi kanthi cetha nganggo `mt rewind` lan `mt fsf`.

### 2. Langkah muat pita

- **FreeBSD**: Nglakokake `mt -f /dev/nsa0 load` nalika startup kanggo muat kartrid pita kanthi mekanis menyang drive sadurunge rewind.
- **OpenBSD**: Nglangkahi perintah `load` amarga `mt(1)` ing OpenBSD ora ndhukung subperintah `load`. Skrip OpenBSD nganggep pita wis ana ing drive lan langsung rewind.

## Skrip Pipeline Log OpenBSD A-menyang-B-menyang-C

Direktori `scripts/` nyedhiyakake skrip kanggo skenario nalika Komputer B OpenBSD nampa entri rsyslog saka Komputer A, nglumpukake saben dina, ngirim menyang salah siji saka sawetara server Komputer C, lan Komputer C nulis menyang pita.

| Skrip | Tujuan |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Nggawe log rotasi saben jam saka file input rsyslog aktif ing Komputer B. |
| `scripts/computer-b-daily-archive.sh` | Ngemasi log saben jam sak dina (`YYYYMMDD`) dadi arsip `.tar.gz` adhedhasar rentang wektu ing Komputer B, ora kalebu jam saiki supaya ora tabrakan karo tulis aktif. |
| `scripts/computer-b-send-archives.sh` | Ngirim arsip saben dina sing durung terkirim (`.tar.gz` lan opsional `.tar.gz.enc`) saka Komputer B menyang siji utawa luwih server Komputer C liwat `scp`. |
| `scripts/computer-c-receive-archives.sh` | Mriksa arsip plaintext sing mlebu lan ngantreni arsip plaintext/enkripsi kanggo pita. |
| `scripts/computer-c-write-to-tape.sh` | Nulis arsip plaintext utawa enkripsi sing ana ing antrian menyang pita, mriksa ruang, nambah kanthi aman, lan menehi tandha wis kacathet. |
| `scripts/computer-c-inventory-tape.sh` | Nyithak daftar isi pita adhedhasar file marker supaya operator bisa cepet nemokake arsip. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Mindhai posisi file pita kanggo arsip sing dijaluk, dekripsi yen perlu, banjur nyimpen data asil pulih menyang file. |
| `scripts/test-computer-a-b-c-integration.sh` | Mbukak uji integrasi lokal A→B→C sing deterministik (kalebu restore pita) lan ora gumantung wektu jam nyata. |

Jadwal umum:

- Mbukak `computer-b-hourly-rotate.sh` saben jam (cron ing B).
- Mbukak `computer-b-daily-archive.sh` sepisan saben dina (cron ing B).
- Mbukak `computer-b-send-archives.sh` sawise nggawe arsip (cron ing B).
- Mbukak `computer-c-receive-archives.sh` kanthi periodik ing C.
- Mbukak `computer-c-write-to-tape.sh` kanthi periodik ing C nganggo piranti pita sing bener.
- Mbukak `computer-c-inventory-tape.sh` ing C nalika butuh daftar isi marker-by-marker.
- Mbukak `computer-c-restore-archive-from-tape.sh` ing C nalika butuh mulihake arsip tartamtu kanggo inspeksi.

Kabèh skrip pipeline uga ngirim pesen operasional menyang syslog liwat `logger` (umpamane katon ing rsyslog/journaling) saliyane output konsol.

### Pengiriman multi-server saka Komputer B

`computer-b-send-archives.sh` ndhukung mode server tunggal lan mode multi-server:

- Server tunggal: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Pilihan milih server ing sisi klien:

- Wenehake siji server ing argumen kanggo nge-pin menyang siji Komputer C.
- Wenehake sawetara server kanggo ngidini fallback.
- Setel `PREFERRED_SERVER=user@host` kanggo milih siji server tartamtu saka dhaptar sing diwenehake.

Pilihan penanganan kondisi sibuk ing Komputer B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): file marker sing dicek ing sisi remote.
- `BUSY_RETRY_SECONDS` (default: `60`): wektu ngenteni antar retry nalika server sibuk.
- `BUSY_MAX_RETRIES` (default: `10`): jumlah maksimal retry saben server.

### Publikasi status sibuk saka Komputer C

`computer-c-write-to-tape.sh` nggawe busy marker nalika aktif nulis arsip menyang pita lan mbusak nalika idle.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Arahake `REMOTE_BUSY_MARKER` ing Komputer B menyang lokasi marker sing digunakake Komputer C.

### Keamanan pita lan prilaku append ing Komputer C

Sadurunge nulis saben arsip, `computer-c-write-to-tape.sh` mriksa kapasitas pita/piranti sing kasedhiya lan mbutuhake paling ora:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variabel sing gegandhengan:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override kanggo ruang kasedhiya sing wis dingerteni)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ngidini nulis yen ruang ora bisa dideteksi)

Kanggo piranti pita nyata, writer nggoleki end-of-data (`mt eom`/`mt eod`) sadurunge nulis, mula sawetara arsip bakal di-append tinimbang nimpa isi pita lawas.

### Timestamp sing gampang diwaca ing jeneng file

- Log saben jam dijenengi kaya: `rsyslog-2026-06-01T1600.log`
- Arsip saben dina dijenengi kaya: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Rentang arsip saben dina adhedhasar file saben jam pisanan lan pungkasan sing tenan kalebu ing arsip.
Jeneng iki dimaksudake supaya gampang diwaca manungsa nalika nelusuri rentang tanggal/wektu kedadeyan.
Jam saiki disengaja ora dilebokake ing pembuatan arsip supaya tulis aktif ora terkirim.

### Enkripsi OpenSSL opsional kanggo arsip saben dina

`computer-b-daily-archive.sh` bisa ngenkripsi arsip nganggo OpenSSL sawise nggawe tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` kanggo enkripsi simetris (`openssl enc`, cipher default `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` kanggo enkripsi sertifikat panampa (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` kanggo milih cipher OpenSSL kanggo mode key-file lan sertifikat (default: `aes-256-gcm`).

Mung siji opsi iki sing bisa disetel ing wektu sing padha. Output terenkripsi nganggo `.tar.gz.enc`.
Kanggo keamanan, skrip nolak pilihan cipher sing ringkih utawa non-AEAD lan mbutuhake cipher kelas GCM/poly1305.

### Mulihake arsip saka pita ing Komputer C

Gunakake `computer-c-restore-archive-from-tape.sh` kanggo nemokake arsip tartamtu kanthi mindhai file pita saka awal kanthi urut:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Kanggo jeneng arsip kaya `rsyslog-<start>_to_<end>.tar.gz` (utawa `.tar.gz.enc`), skrip ngenali kecocokan sing bener kanthi mriksa manawa file hourly boundary ana ing payload sing dipulihake.
- Yen jeneng arsip sampeyan beda, setel `TARGET_MEMBER_GLOB` dadi pola shell sing cocog karo member sing wajib ana ing arsip.
- Yen arsip terenkripsi, wenehake setelan dekripsi yen perlu:
  - `OPENSSL_DECRYPT_KEY_FILE` (mode simetris `openssl enc`; default decrypt cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` lan `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mode dekripsi S/MIME)

Output asil pulih ditulis dadi file `.tar.gz` plaintext supaya bisa dipriksa nganggo alat kaya `tar -tzf`.

### Inventaris daftar isi pita ing Komputer C

Gunakake `computer-c-inventory-tape.sh` kanggo nyithak daftar isi marker-by-marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Kolom output kalebu:

- `file_marker`: posisi file marker pita basis-nol
- `status`: `ok`, `decrypted`, utawa `unreadable`
- `encrypted`: apa dekripsi dibutuhake kanggo mriksa entri (`yes`/`no`)
- `archive_hint`: jeneng gaya arsip asil inferensi nalika boundary bisa dikenali
- `first_member` / `last_member`: member tar pisanan lan pungkasan sing katon ing marker kasebut
- `member_count`: jumlah member tar sing ditemokake ing marker kasebut
- `bytes`: byte mentah sing diwaca ing marker kasebut

Iki mbantu operator ngenali indeks marker sing kudu di-seek (`mt fsf <N>`) sadurunge operasi restore.

### Uji integrasi A/B/C sing deterministik

Gunakake `scripts/test-computer-a-b-c-integration.sh` kanggo validasi integrasi end-to-end Komputer A, B, lan C tanpa gumantung wektu sing wis liwati:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Skrip iki:

1. Nyesimulasi A nulis log.
2. Mbukak rotasi B lan pembuatan arsip saben dina.
3. Nyesimulasi transfer menyang incoming C.
4. Mbukak receive C + write-to-tape.
5. Mulihake arsip saka pita lan validasi isi.

Skrip iki nggunakake cap dina tetep (`TEST_DAY_STAMP`, default `20260101`) supaya prilaku bisa diulang lan ora gumantung tanggal/wektu saiki.

### Retensi 72 jam kanthi safety kanggo data sing durung dikonfirmasi

Skrip saiki default menyang jendhela retensi 72 jam:

- `computer-b-hourly-rotate.sh` mung mbusak log hourly lawas yen ana marker konfirmasi `.taped` lokal sing cocog.
- `computer-b-send-archives.sh` mung mbusak arsip lokal lawas yen marker `.sent` lan marker konfirmasi `.taped` lokal loro-lorone ana.
- `computer-c-write-to-tape.sh` mung mbusak arsip lawas sing wis duwe marker `.taped`.

Akibate, file sing durung kasil ditransmisikake lan direkam menyang pita tetep disimpen sanajan luwih lawas tinimbang `RETENTION_HOURS` (default `72`).
Ing Komputer B, pembersihan lokal mbutuhake marker `.taped` lokal (umpamane saka langkah sync-back utawa proses konfirmasi manual).
Ing Komputer C, umur retensi diukur saka wektu modifikasi marker `.taped` (biasane disetel nalika tape write sukses).
