# A/B/C Pipeline Diagrams (Bahasa Indonesia)

[← README (Bahasa Indonesia)](../README.id.md)

Salinan terlokalisasi ini menautkan diagram pipeline ke README terlokalisasi yang sesuai.

## Diagram Status Peristiwa

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Komputer A mengirim peristiwa rsyslog

    A_WritingLogs --> B_HourlyRotate : cron per jam / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log rotasi per jam dibuat
    B_WaitMoreLogs --> B_DailyArchive : cron harian / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (atau .tar.gz.enc) dihasilkan

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transfer scp ke Komputer C
    B_SendArchives --> B_RetryLater : C sibuk (.busy marker) atau transfer gagal
    B_RetryLater --> B_SendArchives : jendela coba ulang

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : diterima + masuk antrean
    C_ReceiveValidate --> C_Reject : arsip tidak valid

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arsip ditambahkan ke pita + .taped marker
    C_WriteTape --> C_WaitTape : tidak ada pita/ruang/error
    C_WaitTape --> C_WriteTape : coba lagi pada run berikutnya

    C_Taped --> C_Inventory : sesuai kebutuhan / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : sesuai kebutuhan / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : keluaran arsip yang dipulihkan
```

## Diagram Urutan

```mermaid
sequenceDiagram
    autonumber
    participant A as Komputer A (sumber rsyslog)
    participant B as Komputer B (arsip/kirim)
    participant C as Komputer C (terima/pita)
    participant T as Perangkat Pita

    Note over A,B: Ingesti/rotasi per jam
    A->>B: Kirim peristiwa rsyslog terus-menerus
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Pengemasan harian
    B->>B: computer-b-daily-archive.sh
    B->>B: Buat .tar.gz (atau .tar.gz.enc)

    Note over B,C: Transfer ke satu atau lebih server C
    B->>C: computer-b-send-archives.sh via scp
    alt C sibuk (.busy marker)
        C-->>B: indikasi sibuk
        B->>B: tunggu/coba ulang/server fallback
    else transfer diterima
        C-->>B: arsip diterima
    end

    Note over C: Penerimaan dan antrean
    C->>C: computer-c-receive-archives.sh
    alt arsip valid
        C->>C: Masukkan antrean tulis ke pita
    else arsip tidak valid
        C->>C: Tolak + log error
    end

    Note over C,T: Loop perekaman pita
    C->>C: computer-c-write-to-tape.sh
    C->>T: Cari akhir data + tambahkan arsip
    T-->>C: tulis berhasil
    C->>C: Tandai .taped (dan bersihkan sesuai retensi)

    opt Inventaris operator
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC per marker
    end

    opt Permintaan pemulihan operator
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: payload arsip di marker yang cocok
        C-->>A: .tar.gz hasil pemulihan untuk inspeksi
    end
```

[← README (Bahasa Indonesia)](../README.id.md)
