# A/B/C Pyplyn Diagramme (Afrikaans)

[← README (Afrikaans)](../README.af.md)

Hierdie gelokaliseerde kopie koppel die pyplyndiagramme aan die ooreenstemmende gelokaliseerde README.

## Gebeurtenis-toestanddiagram

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Rekenaar A stuur rsyslog-gebeure uit

    A_WritingLogs --> B_HourlyRotate : uurlikse cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : geroteerde uurlikse log geskep
    B_WaitMoreLogs --> B_DailyArchive : daaglikse cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (of .tar.gz.enc) geproduseer

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-oordrag na Rekenaar C
    B_SendArchives --> B_RetryLater : C besig (.busy-merker) of oordragfout
    B_RetryLater --> B_SendArchives : herprobeervenster

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : aanvaar + in waglys
    C_ReceiveValidate --> C_Reject : ongeldige argief

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : argief by band gevoeg + .taped-merker
    C_WriteTape --> C_WaitTape : geen band/spasie/fout
    C_WaitTape --> C_WriteTape : herprobeer by volgende lopie

    C_Taped --> C_Inventory : op aanvraag / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : op aanvraag / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : herstelde argiefuitvoer
```

## Volgordediagram

```mermaid
sequenceDiagram
    autonumber
    participant A as Rekenaar A (rsyslog-bron)
    participant B as Rekenaar B (argiveer/stuur)
    participant C as Rekenaar C (ontvang/band)
    participant T as Bandtoestel

    Note over A,B: Uurlikse inname/rotasie
    A->>B: Stuur rsyslog-gebeure deurlopend
    B->>B: computer-b-hourly-rotate.sh (uurliks)

    Note over B: Daaglikse verpakking
    B->>B: computer-b-daily-archive.sh (daagliks)
    B->>B: Skep .tar.gz (of .tar.gz.enc)

    Note over B,C: Oordrag na een of meer C-bedieners
    B->>C: computer-b-send-archives.sh via scp
    alt C is besig (.busy-merker)
        C-->>B: Besig-aanduiding
        B->>B: Wag/herprobeer/rugsteunbediener
    else Oordrag aanvaar
        C-->>B: Argief ontvang
    end

    Note over C: Inname en waglys
    C->>C: computer-c-receive-archives.sh
    alt Argief geldig
        C->>C: Waglys vir bandskryf
    else Argief ongeldig
        C->>C: Weier + log fout
    end

    Note over C,T: Band-opname-lus
    C->>C: computer-c-write-to-tape.sh
    C->>T: Soek einde-van-data + voeg argief by
    T-->>C: Skryf suksesvol
    C->>C: Merk .taped (en skoonmaak volgens retention)

    opt Operateur-inventaris
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Merker-vir-merker inhoudsopgawe
    end

    opt Operateur-herstelversoek
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Argieflading by ooreenstemmende merker
        C-->>A: Herstelde .tar.gz vir inspeksie
    end
```

[← README (Afrikaans)](../README.af.md)
