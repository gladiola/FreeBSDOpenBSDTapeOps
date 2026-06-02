# A/B/C Pipeline Diagrams (Svenska)

[← README (Svenska)](../README.sv.md)

Den här lokaliserade kopian länkar pipeline-diagrammen till motsvarande lokaliserade README.

## Tillståndsdiagram för händelser

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Dator A skickar rsyslog-händelser

    A_WritingLogs --> B_HourlyRotate : timvis cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : roterad timlogg skapad
    B_WaitMoreLogs --> B_DailyArchive : daglig cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (eller .tar.gz.enc) skapad

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-överföring till Dator C
    B_SendArchives --> B_RetryLater : C upptagen (.busy-markör) eller överföringsfel
    B_RetryLater --> B_SendArchives : försöksfönster

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : accepterad + köad
    C_ReceiveValidate --> C_Reject : ogiltigt arkiv

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arkiv tillagt på band + .taped-markör
    C_WriteTape --> C_WaitTape : ingen band/enhet plats/fel
    C_WaitTape --> C_WriteTape : försök igen vid nästa körning

    C_Taped --> C_Inventory : vid behov / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : vid behov / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : återställd arkivutdata
```

## Sekvensdiagram

```mermaid
sequenceDiagram
    autonumber
    participant A as Dator A (rsyslog-källa)
    participant B as Dator B (arkiv/skicka)
    participant C as Dator C (ta emot/band)
    participant T as Bandenhet

    Note over A,B: Timvis inmatning/rotation
    A->>B: Skicka rsyslog-händelser kontinuerligt
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Daglig paketering
    B->>B: computer-b-daily-archive.sh
    B->>B: Skapa .tar.gz (eller .tar.gz.enc)

    Note over B,C: Överföring till en eller flera C-servrar
    B->>C: computer-b-send-archives.sh via scp
    alt C är upptagen (.busy-markör)
        C-->>B: Upptagen-indikation
        B->>B: Vänta/försök igen/reservserver
    else Överföring accepterad
        C-->>B: Arkiv mottaget
    end

    Note over C: Mottagning och kö
    C->>C: computer-c-receive-archives.sh
    alt Arkiv giltigt
        C->>C: Köa för bandskrivning
    else Arkiv ogiltigt
        C->>C: Avvisa + logga fel
    end

    Note over C,T: Bandinspelningsslinga
    C->>C: computer-c-write-to-tape.sh
    C->>T: Sök till slutet av data + lägg till arkiv
    T-->>C: Skrivning lyckades
    C->>C: Markera .taped (och rensa enligt retention)

    opt Operatörsinventering
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC markör för markör
    end

    opt Operatörens återställningsbegäran
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Arkiverad last vid matchande markör
        C-->>A: Återställd .tar.gz för inspektion
    end
```

[← README (Svenska)](../README.sv.md)
