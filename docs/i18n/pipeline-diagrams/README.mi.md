# Ngā hoahoa paipa A/B/C (Te Reo Māori)

[← README (Te Reo Māori)](../README.mi.md)

Ka hono tēnei kape kua whakamāoritia i ngā hoahoa paipa ki te README kua whakamāoritia e hāngai ana.

## Hoahoa āhua takahanga

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Ka tuku a Computer A i ngā takahanga rsyslog

    A_WritingLogs --> B_HourlyRotate : cron ia hāora / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : kua hangaia te rākau taki hāora kua hurihia
    B_WaitMoreLogs --> B_DailyArchive : cron ia rā / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : kua hangaia te .tar.gz (rānei .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : whakawhitinga scp ki Computer C
    B_SendArchives --> B_RetryLater : kei te pukumahi a C (tohu .busy) rānei kua hē te whakawhitinga
    B_RetryLater --> B_SendArchives : wā whakamātau anō

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : kua whakaaetia + kua whakaurua ki te rārangi
    C_ReceiveValidate --> C_Reject : kōnae pūranga muhu

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : kua tāpirihia te pūranga ki te rīpene + tohu .taped
    C_WriteTape --> C_WaitTape : kāore he rīpene/wāhi/hapa
    C_WaitTape --> C_WriteTape : whakamātau anō i te oma e whai ake

    C_Taped --> C_Inventory : i te tono / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : i te tono / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : putanga pūranga kua whakahokia mai
```

## Hoahoa raupapa

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (pūtake rsyslog)
    participant B as Computer B (pūranga/tuku)
    participant C as Computer C (whiwhi/rīpene)
    participant T as Pūrere rīpene

    Note over A,B: Whakauru/hurihanga ia hāora
    A->>B: Tuku tonu i ngā takahanga rsyslog
    B->>B: computer-b-hourly-rotate.sh (ia hāora)

    Note over B: Tākai ia rā
    B->>B: computer-b-daily-archive.sh (ia rā)
    B->>B: Waihanga .tar.gz (rānei .tar.gz.enc)

    Note over B,C: Whakawhiti ki tētahi, ki ētahi atu tūmau C rānei
    B->>C: computer-b-send-archives.sh mā te scp
    alt Kei te pukumahi a C (tohu .busy)
        C-->>B: Tohu pukumahi
        B->>B: Tatari/whakamātau anō/tūmau tūāpapa
    else Kua whakaaetia te whakawhitinga
        C-->>B: Kua tae mai te pūranga
    end

    Note over C: Whiwhinga me te rārangi
    C->>C: computer-c-receive-archives.sh
    alt He whaitake te pūranga
        C->>C: Tāpiri ki te rārangi mō te tuhi ki te rīpene
    else He muhu te pūranga
        C->>C: Whakakāhoretia + taki hapa
    end

    Note over C,T: Porowhita tuhi rīpene
    C->>C: computer-c-write-to-tape.sh
    C->>T: Rapu i te pito raraunga + tāpiri pūranga
    T-->>C: I angitū te tuhi
    C->>C: Tohu .taped (me te horoi e ai ki te retention)

    opt Rārangi taonga a te kaiwhakahaere
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marker ki marker
    end

    opt Tono whakaora a te kaiwhakahaere
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Payload pūranga i te marker i taurite
        C-->>A: .tar.gz kua whakahokia mō te arotake
    end
```

[← README (Te Reo Māori)](../README.mi.md)
