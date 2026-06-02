# A/B/C Pipeline Diagrams (Norsk)

[← README (Norsk)](../README.no.md)

Denne lokaliserte kopien kobler pipeline-diagrammene til den tilsvarende lokaliserte README-en.

## Hendelses-tilstandsdiagram

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Datamaskin A sender ut rsyslog-hendelser

    A_WritingLogs --> B_HourlyRotate : timebasert cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : rotert timelogg opprettet
    B_WaitMoreLogs --> B_DailyArchive : daglig cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (eller .tar.gz.enc) opprettet

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-overføring til Datamaskin C
    B_SendArchives --> B_RetryLater : C opptatt (.busy-markør) eller overføringsfeil
    B_RetryLater --> B_SendArchives : nytt forsøk-vindu

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : godkjent + satt i kø
    C_ReceiveValidate --> C_Reject : ugyldig arkiv

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arkiv lagt til på tape + .taped-markør
    C_WriteTape --> C_WaitTape : ingen tape/plass/feil
    C_WaitTape --> C_WriteTape : prøv igjen ved neste kjøring

    C_Taped --> C_Inventory : ved behov / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : ved behov / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : utdata fra gjenopprettet arkiv
```

## Sekvensdiagram

```mermaid
sequenceDiagram
    autonumber
    participant A as Datamaskin A (rsyslog-kilde)
    participant B as Datamaskin B (arkiv/send)
    participant C as Datamaskin C (motta/tape)
    participant T as Tape-enhet

    Note over A,B: Timebasert innsamling/rotasjon
    A->>B: Send rsyslog-hendelser kontinuerlig
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Daglig pakking
    B->>B: computer-b-daily-archive.sh
    B->>B: Opprett .tar.gz (eller .tar.gz.enc)

    Note over B,C: Overføring til én eller flere C-servere
    B->>C: computer-b-send-archives.sh via scp
    alt C er opptatt (.busy-markør)
        C-->>B: Opptatt-indikasjon
        B->>B: Vent/prøv igjen/reserveserver
    else Overføring godtatt
        C-->>B: Arkiv mottatt
    end

    Note over C: Mottak og kø
    C->>C: computer-c-receive-archives.sh
    alt Arkiv gyldig
        C->>C: Kø for skriving til tape
    else Arkiv ugyldig
        C->>C: Avvis + loggfør feil
    end

    Note over C,T: Loop for tapeopptak
    C->>C: computer-c-write-to-tape.sh
    C->>T: Søk til slutt på data + legg til arkiv
    T-->>C: Skriving vellykket
    C->>C: Merk .taped (og rydd etter retensjon)

    opt Operatørinventar
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC markør for markør
    end

    opt Operatørforespørsel om gjenoppretting
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Arkivert nyttelast ved matchende markør
        C-->>A: Gjenopprettet .tar.gz for inspeksjon
    end
```

[← README (Norsk)](../README.no.md)
