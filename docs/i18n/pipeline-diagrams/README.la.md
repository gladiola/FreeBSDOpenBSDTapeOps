# Diagrammata cursus A/B/C (Latina)

[← README (Latina)](../README.la.md)

Hoc exemplar locale diagrammata cursus cum README locali respondenti coniungit.

## Diagramma status eventuum

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A eventus rsyslog emittit

    A_WritingLogs --> B_HourlyRotate : cron horarium / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log horarium rotatum creatum est
    B_WaitMoreLogs --> B_DailyArchive : cron cotidianum / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (vel .tar.gz.enc) creatum est

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : translatio scp ad Computer C
    B_SendArchives --> B_RetryLater : C occupatus est (signum .busy) vel translatio deficit
    B_RetryLater --> B_SendArchives : tempus iterandi

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : receptum + in ordinem missum
    C_ReceiveValidate --> C_Reject : archivum invalidum

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archivum taeniae additum + signum .taped
    C_WriteTape --> C_WaitTape : nulla taenia/spatium/error
    C_WaitTape --> C_WriteTape : iteratio in cursu proximo

    C_Taped --> C_Inventory : ad petitionem / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : ad petitionem / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : archivum recuperatum in exitu
```

## Diagramma ordinis

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (fons rsyslog)
    participant B as Computer B (archivatio/missio)
    participant C as Computer C (receptio/taenia)
    participant T as Instrumentum taeniae

    Note over A,B: Ingestio/rotatio horaria
    A->>B: Eventus rsyslog continue mittuntur
    B->>B: computer-b-hourly-rotate.sh (horarie)

    Note over B: Confectio cotidiana
    B->>B: computer-b-daily-archive.sh (cotidie)
    B->>B: Creatio .tar.gz (vel .tar.gz.enc)

    Note over B,C: Translatio ad unum vel plures servitores C
    B->>C: computer-b-send-archives.sh per scp
    alt C occupatus est (signum .busy)
        C-->>B: Indicium occupationis
        B->>B: Exspectatio/iteratio/servitor subsidiarius
    else Translatio accepta est
        C-->>B: Archivum receptum est
    end

    Note over C: Receptio et ordo
    C->>C: computer-c-receive-archives.sh
    alt Archivum validum est
        C->>C: In ordinem scripturae in taeniam mitte
    else Archivum invalidum est
        C->>C: Reice + errorem in log scribe
    end

    Note over C,T: Ansa scripturae in taeniam
    C->>C: computer-c-write-to-tape.sh
    C->>T: Ad finem datorum pete + archivum adde
    T-->>C: Scriptura felix
    C->>C: .taped nota (et emunda secundum retentionem)

    opt Inventarium ab operatore
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Index marker per marker
    end

    opt Petitio restitutionis ab operatore
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Onus archivi ad marker congruentem
        C-->>A: .tar.gz recuperatum ad inspectionem
    end
```

[← README (Latina)](../README.la.md)
