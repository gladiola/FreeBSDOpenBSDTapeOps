# A/B/C Pipeline Diagrams (Nederlands)

[← README (Nederlands)](../README.nl.md)

Deze gelokaliseerde kopie koppelt de pijplijndiagrammen aan de bijbehorende gelokaliseerde README.

## Gebeurtenis-statusdiagram

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A stuurt rsyslog-gebeurtenissen uit

    A_WritingLogs --> B_HourlyRotate : uurlijkse cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : geroteerd uurlog gemaakt
    B_WaitMoreLogs --> B_DailyArchive : dagelijkse cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (of .tar.gz.enc) gemaakt

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-overdracht naar Computer C
    B_SendArchives --> B_RetryLater : C bezet (.busy-marker) of overdrachtsfout
    B_RetryLater --> B_SendArchives : venster voor opnieuw proberen

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : geaccepteerd + in wachtrij
    C_ReceiveValidate --> C_Reject : ongeldig archief

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archief toegevoegd aan tape + .taped-marker
    C_WriteTape --> C_WaitTape : geen tape/ruimte/fout
    C_WaitTape --> C_WriteTape : opnieuw proberen bij volgende run

    C_Taped --> C_Inventory : op aanvraag / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : op aanvraag / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : uitvoer van hersteld archief
```

## Sequentiediagram

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (rsyslog-bron)
    participant B as Computer B (archiveren/verzenden)
    participant C as Computer C (ontvangen/tape)
    participant T as Tape-apparaat

    Note over A,B: Uurlijkse inname/rotatie
    A->>B: Stuur rsyslog-gebeurtenissen continu
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Dagelijkse verpakking
    B->>B: computer-b-daily-archive.sh
    B->>B: Maak .tar.gz (of .tar.gz.enc)

    Note over B,C: Overdracht naar een of meer C-servers
    B->>C: computer-b-send-archives.sh via scp
    alt C is bezet (.busy-marker)
        C-->>B: Bezetmelding
        B->>B: Wachten/opnieuw proberen/fallback-server
    else Overdracht geaccepteerd
        C-->>B: Archief ontvangen
    end

    Note over C: Inname en wachtrij
    C->>C: computer-c-receive-archives.sh
    alt Archief geldig
        C->>C: In wachtrij voor schrijven naar tape
    else Archief ongeldig
        C->>C: Afwijzen + fout loggen
    end

    Note over C,T: Tape-opnamelus
    C->>C: computer-c-write-to-tape.sh
    C->>T: Ga naar einde van data + archief toevoegen
    T-->>C: Schrijven geslaagd
    C->>C: Markeer .taped (en opschonen volgens retentie)

    opt Operator-inventaris
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marker voor marker
    end

    opt Herstelverzoek van operator
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Gearchiveerde payload bij overeenkomende marker
        C-->>A: Herstelde .tar.gz voor inspectie
    end
```

[← README (Nederlands)](../README.nl.md)
