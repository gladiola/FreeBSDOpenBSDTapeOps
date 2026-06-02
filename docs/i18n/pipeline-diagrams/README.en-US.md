# A/B/C Pipeline Diagrams (US English)

[← README (US English)](../README.en-US.md)

This localized copy links the pipeline diagrams to the corresponding localized README.

## Event State Diagram

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A emits rsyslog events

    A_WritingLogs --> B_HourlyRotate : hourly cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : rotated hourly log created
    B_WaitMoreLogs --> B_DailyArchive : daily cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (or .tar.gz.enc) produced

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp transfer to Computer C
    B_SendArchives --> B_RetryLater : C busy (.busy marker) or transfer failure
    B_RetryLater --> B_SendArchives : retry window

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : accepted + queued
    C_ReceiveValidate --> C_Reject : invalid archive

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archive appended to tape + .taped marker
    C_WriteTape --> C_WaitTape : no tape/space/error
    C_WaitTape --> C_WriteTape : next run retry

    C_Taped --> C_Inventory : on demand / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : on demand / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : recovered archive output
```

## Sequence Diagram

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (rsyslog source)
    participant B as Computer B (archive/ship)
    participant C as Computer C (receive/tape)
    participant T as Tape Device

    Note over A,B: Hourly ingestion/rotation
    A->>B: Send rsyslog events continuously
    B->>B: computer-b-hourly-rotate.sh (hourly)

    Note over B: Daily packaging
    B->>B: computer-b-daily-archive.sh (daily)
    B->>B: Create .tar.gz (or .tar.gz.enc)

    Note over B,C: Transfer to one or more C servers
    B->>C: computer-b-send-archives.sh via scp
    alt C is busy (.busy marker)
        C-->>B: Busy indication
        B->>B: Wait/retry/fallback server
    else Transfer accepted
        C-->>B: Archive received
    end

    Note over C: Intake and queue
    C->>C: computer-c-receive-archives.sh
    alt Archive valid
        C->>C: Queue for tape write
    else Archive invalid
        C->>C: Reject + log error
    end

    Note over C,T: Tape recording loop
    C->>C: computer-c-write-to-tape.sh
    C->>T: Seek end-of-data + append archive
    T-->>C: Write success
    C->>C: Mark .taped (and cleanup per retention)

    opt Operator inventory
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Marker-by-marker TOC
    end

    opt Operator restore request
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Archived payload at matched marker
        C-->>A: Recovered .tar.gz for inspection
    end
```

[← README (US English)](../README.en-US.md)
