# Ata o le paipa A/B/C (Gagana Samoa)

[← README (Gagana Samoa)](../README.sm.md)

E fesoʻotaʻi e lenei kopi ua faaliliuina ata o le paipa ma le README ua faaliliuina e fetaui.

## Ata o tulaga o mea tutupu

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : E auina atu e Computer A mea tutupu rsyslog

    A_WritingLogs --> B_HourlyRotate : cron i itula ta‘itasi / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : ua faia le log itula ua rotate
    B_WaitMoreLogs --> B_DailyArchive : cron i aso ta‘itasi / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : ua faia le .tar.gz (po o le .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : fesiitaiga scp i le Computer C
    B_SendArchives --> B_RetryLater : ua pisi C (marker .busy) po o le toilalo o le fesiitaiga
    B_RetryLater --> B_SendArchives : faamalama toe taumafai

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : taliaina + tuu i le laina
    C_ReceiveValidate --> C_Reject : faila teu e lē aoga

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : ua faaopoopo le faila teu i le lipine + marker .taped
    C_WriteTape --> C_WaitTape : leai se lipine/nofoaga/sese
    C_WaitTape --> C_WriteTape : toe taumafai i le tamo‘ega sosoo

    C_Taped --> C_Inventory : i le talosaga / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : i le talosaga / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : faila teu ua toe maua i le taunuuga
```

## Ata o le faasologa

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (punavai rsyslog)
    participant B as Computer B (teuina/lafo)
    participant C as Computer C (taliaina/lipine)
    participant T as Masini lipine

    Note over A,B: Ulufale/rotate i itula ta‘itasi
    A->>B: Auina pea mea tutupu rsyslog
    B->>B: computer-b-hourly-rotate.sh (i itula ta‘itasi)

    Note over B: Faapipi‘i i aso ta‘itasi
    B->>B: computer-b-daily-archive.sh (i aso ta‘itasi)
    B->>B: Fai le .tar.gz (po o le .tar.gz.enc)

    Note over B,C: Fesiitai i se tasi pe sili atu server C
    B->>C: computer-b-send-archives.sh e ala i le scp
    alt Ua pisi C (marker .busy)
        C-->>B: Faailo o le pisi
        B->>B: Faatali/toe taumafai/server sui
    else Ua taliaina le fesiitaiga
        C-->>B: Ua maua le faila teu
    end

    Note over C: Taliaina ma le laina
    C->>C: computer-c-receive-archives.sh
    alt E aoga le faila teu
        C->>C: Tuu i le laina mo le tusi i le lipine
    else E lē aoga le faila teu
        C->>C: Teena + log le sese
    end

    Note over C,T: Taamilosaga tusi lipine
    C->>C: computer-c-write-to-tape.sh
    C->>T: Saili le faai‘uga o faamatalaga + faaopoopo le faila teu
    T-->>C: Ua manuia le tusiga
    C->>C: Faailoga .taped (ma faamamā e tusa ma le retention)

    opt Inventory a le operator
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marker i marker
    end

    opt Talosaga toe faafo‘i a le operator
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Payload teu i le marker ua fetaui
        C-->>A: .tar.gz ua toe maua mo le siaki
    end
```

[← README (Gagana Samoa)](../README.sm.md)
