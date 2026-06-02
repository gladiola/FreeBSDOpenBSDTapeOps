# A/B/C Pipeline Diagrams (Basa Jawa)

[← README (Basa Jawa)](../README.jv.md)

Salinan terlokalisasi iki nyambungake diagram pipeline menyang README terlokalisasi sing cocog.

## Diagram Status Kedadeyan

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Komputer A ngirim kedadeyan rsyslog

    A_WritingLogs --> B_HourlyRotate : cron saben jam / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log rotasi saben jam wis digawe
    B_WaitMoreLogs --> B_DailyArchive : cron saben dina / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (utawa .tar.gz.enc) wis digawe

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transfer scp menyang Komputer C
    B_SendArchives --> B_RetryLater : C sibuk (.busy marker) utawa transfer gagal
    B_RetryLater --> B_SendArchives : wektu nyoba maneh

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : ditampa + mlebu antrian
    C_ReceiveValidate --> C_Reject : arsip ora valid

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arsip ditambah menyang tape + .taped marker
    C_WriteTape --> C_WaitTape : ora ana tape/ruang/error
    C_WaitTape --> C_WriteTape : nyoba maneh ing run sabanjure

    C_Taped --> C_Inventory : yen perlu / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : yen perlu / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : output arsip sing dipulihake
```

## Diagram Urutan

```mermaid
sequenceDiagram
    autonumber
    participant A as Komputer A (sumber rsyslog)
    participant B as Komputer B (arsip/kirim)
    participant C as Komputer C (nampa/tape)
    participant T as Piranti Tape

    Note over A,B: Ingesti/rotasi saben jam
    A->>B: Kirim kedadeyan rsyslog terus-terusan
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Paket saben dina
    B->>B: computer-b-daily-archive.sh
    B->>B: Gawe .tar.gz (utawa .tar.gz.enc)

    Note over B,C: Transfer menyang siji utawa luwih server C
    B->>C: computer-b-send-archives.sh liwat scp
    alt C sibuk (.busy marker)
        C-->>B: tandha sibuk
        B->>B: ngenteni/nyoba maneh/server fallback
    else transfer ditampa
        C-->>B: arsip ditampa
    end

    Note over C: Panampa lan antrian
    C->>C: computer-c-receive-archives.sh
    alt arsip valid
        C->>C: Mlebu antrian nulis tape
    else arsip ora valid
        C->>C: Tolak + log error
    end

    Note over C,T: Loop rekaman tape
    C->>C: computer-c-write-to-tape.sh
    C->>T: Nyang pungkasan data + tambah arsip
    T-->>C: nulis sukses
    C->>C: Tandhai .taped (lan resik manut retensi)

    opt Inventaris operator
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC saben marker
    end

    opt Panjaluk mulihake saka operator
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: payload arsip ing marker sing cocog
        C-->>A: .tar.gz sing dipulihake kanggo dipriksa
    end
```

[← README (Basa Jawa)](../README.jv.md)
