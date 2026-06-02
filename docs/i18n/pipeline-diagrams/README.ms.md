# A/B/C Pipeline Diagrams (Bahasa Melayu)

[← README (Bahasa Melayu)](../README.ms.md)

Salinan setempat ini memautkan rajah pipeline kepada README setempat yang sepadan.

## Rajah Keadaan Peristiwa

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Komputer A mengeluarkan peristiwa rsyslog

    A_WritingLogs --> B_HourlyRotate : cron setiap jam / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log putaran setiap jam dicipta
    B_WaitMoreLogs --> B_DailyArchive : cron harian / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (atau .tar.gz.enc) dihasilkan

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : pemindahan scp ke Komputer C
    B_SendArchives --> B_RetryLater : C sibuk (.busy marker) atau pemindahan gagal
    B_RetryLater --> B_SendArchives : tetingkap cuba semula

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : diterima + dimasukkan ke baris gilir
    C_ReceiveValidate --> C_Reject : arkib tidak sah

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arkib ditambah ke pita + .taped marker
    C_WriteTape --> C_WaitTape : tiada pita/ruang/ralat
    C_WaitTape --> C_WriteTape : cuba semula pada run seterusnya

    C_Taped --> C_Inventory : atas permintaan / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : atas permintaan / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : output arkib dipulihkan
```

## Rajah Urutan

```mermaid
sequenceDiagram
    autonumber
    participant A as Komputer A (sumber rsyslog)
    participant B as Komputer B (arkib/hantar)
    participant C as Komputer C (terima/pita)
    participant T as Peranti Pita

    Note over A,B: Pengambilan/putaran setiap jam
    A->>B: Hantar peristiwa rsyslog secara berterusan
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Pembungkusan harian
    B->>B: computer-b-daily-archive.sh
    B->>B: Cipta .tar.gz (atau .tar.gz.enc)

    Note over B,C: Pindah ke satu atau lebih pelayan C
    B->>C: computer-b-send-archives.sh melalui scp
    alt C sibuk (.busy marker)
        C-->>B: petunjuk sibuk
        B->>B: tunggu/cuba semula/pelayan sandaran
    else pemindahan diterima
        C-->>B: arkib diterima
    end

    Note over C: Penerimaan dan baris gilir
    C->>C: computer-c-receive-archives.sh
    alt arkib sah
        C->>C: Masukkan ke baris gilir tulis pita
    else arkib tidak sah
        C->>C: Tolak + log ralat
    end

    Note over C,T: Gelung rakaman pita
    C->>C: computer-c-write-to-tape.sh
    C->>T: Pergi ke hujung data + tambah arkib
    T-->>C: tulisan berjaya
    C->>C: Tanda .taped (dan bersih ikut retensi)

    opt Inventori operator
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC setiap marker
    end

    opt Permintaan pulih operator
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: payload arkib pada marker sepadan
        C-->>A: .tar.gz yang dipulihkan untuk semakan
    end
```

[← README (Bahasa Melayu)](../README.ms.md)
