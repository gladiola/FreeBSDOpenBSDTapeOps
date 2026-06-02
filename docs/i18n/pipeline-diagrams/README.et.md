# A/B/C Pipeline Diagrams (Eesti)

[← README (Eesti)](../README.et.md)

See lokaliseeritud koopia seob torujuhtme diagrammid vastava lokaliseeritud README-ga.

## Sündmuste olekudiagramm

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Arvuti A saadab rsyslogi sündmusi

    A_WritingLogs --> B_HourlyRotate : tunnipõhine cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : loodi pööratud tunnilogi
    B_WaitMoreLogs --> B_DailyArchive : igapäevane cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (või .tar.gz.enc) loodud

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-edastus Arvutisse C
    B_SendArchives --> B_RetryLater : C on hõivatud (.busy marker) või edastusviga
    B_RetryLater --> B_SendArchives : uuesti proovimise aken

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : vastu võetud + järjekorda pandud
    C_ReceiveValidate --> C_Reject : vigane arhiiv

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arhiiv lisatud lindile + .taped marker
    C_WriteTape --> C_WaitTape : linti/ruumi pole/viga
    C_WaitTape --> C_WriteTape : proovi järgmises käivituses uuesti

    C_Taped --> C_Inventory : nõudmisel / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : nõudmisel / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : taastatud arhiivi väljund
```

## Järjestusdiagramm

```mermaid
sequenceDiagram
    autonumber
    participant A as Arvuti A (rsyslogi allikas)
    participant B as Arvuti B (arhiiv/saatmine)
    participant C as Arvuti C (vastuvõtt/lint)
    participant T as Lindiseade

    Note over A,B: Tunnipõhine vastuvõtt/pööramine
    A->>B: Saada rsyslogi sündmusi pidevalt
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Igapäevane pakkimine
    B->>B: computer-b-daily-archive.sh
    B->>B: Loo .tar.gz (või .tar.gz.enc)

    Note over B,C: Edastus ühele või mitmele C-serverile
    B->>C: computer-b-send-archives.sh kaudu scp
    alt C on hõivatud (.busy marker)
        C-->>B: Hõivatuse teade
        B->>B: Oota/proovi uuesti/varuserver
    else Edastus vastu võetud
        C-->>B: Arhiiv vastu võetud
    end

    Note over C: Vastuvõtt ja järjekord
    C->>C: computer-c-receive-archives.sh
    alt Arhiiv kehtiv
        C->>C: Pane lindile kirjutamise järjekorda
    else Arhiiv vigane
        C->>C: Lükka tagasi + logi viga
    end

    Note over C,T: Lindile kirjutamise tsükkel
    C->>C: computer-c-write-to-tape.sh
    C->>T: Liigu andmete lõppu + lisa arhiiv
    T-->>C: Kirjutamine õnnestus
    C->>C: Märgi .taped (ja puhasta säilitusreegli järgi)

    opt Operaatori inventuur
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marker markeri kaupa
    end

    opt Operaatori taastamispäring
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Arhiveeritud sisu sobival markeril
        C-->>A: Taastatud .tar.gz kontrolliks
    end
```

[← README (Eesti)](../README.et.md)
