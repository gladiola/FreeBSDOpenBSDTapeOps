# Nā Kiʻikuhi Paipu A/B/C (ʻŌlelo Hawaiʻi)

[← README (ʻŌlelo Hawaiʻi)](../README.haw.md)

Hoʻohui kēia kope i unuhi ʻia i nā kiʻikuhi paipu me ka README i unuhi like ʻia.

## Kiʻikuhi kūlana hanana

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Hoʻouna ʻo Computer A i nā hanana rsyslog

    A_WritingLogs --> B_HourlyRotate : cron i kēlā me kēia hola / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : hana ʻia ka log hola i huli ʻia
    B_WaitMoreLogs --> B_DailyArchive : cron i kēlā me kēia lā / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : hana ʻia ka .tar.gz (a i ʻole .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : hoʻoili scp i Computer C
    B_SendArchives --> B_RetryLater : paʻa ʻo C (hōʻailona .busy) a i ʻole hāʻule ka hoʻoili
    B_RetryLater --> B_SendArchives : puka manawa hoʻāʻo hou

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : ʻae ʻia + hoʻokomo i ka lālani
    C_ReceiveValidate --> C_Reject : waihona hewa

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : hoʻopili ʻia ka waihona i ka lipine + hōʻailona .taped
    C_WriteTape --> C_WaitTape : ʻaʻohe lipine/wahi/hewa
    C_WaitTape --> C_WriteTape : hoʻāʻo hou i ka holo aʻe

    C_Taped --> C_Inventory : ma ke noi / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : ma ke noi / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : puka mai ka waihona i hoʻihoʻi ʻia
```

## Kiʻikuhi kaʻina

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (kumu rsyslog)
    participant B as Computer B (waihona/hoʻouna)
    participant C as Computer C (loaʻa/lipine)
    participant T as Mea lipine

    Note over A,B: Hoʻokomo/hoʻohuli i kēlā me kēia hola
    A->>B: Hoʻouna mau i nā hanana rsyslog
    B->>B: computer-b-hourly-rotate.sh (i kēlā me kēia hola)

    Note over B: Hoʻopili i kēlā me kēia lā
    B->>B: computer-b-daily-archive.sh (i kēlā me kēia lā)
    B->>B: Hana i ka .tar.gz (a i ʻole .tar.gz.enc)

    Note over B,C: Hoʻoili i hoʻokahi a i ʻole he nui nā kikowaena C
    B->>C: computer-b-send-archives.sh ma o scp
    alt Paʻa ʻo C (hōʻailona .busy)
        C-->>B: Hōʻike paʻa
        B->>B: Kali/hoʻāʻo hou/kikowaena kākoʻo
    else ʻAe ʻia ka hoʻoili
        C-->>B: Loaʻa ka waihona
    end

    Note over C: Loaʻa a me ka lālani
    C->>C: computer-c-receive-archives.sh
    alt Pololei ka waihona
        C->>C: Hoʻokomo i ka lālani no ke kākau lipine
    else Hewa ka waihona
        C->>C: Hōʻole + kākau i ka hewa i ka log
    end

    Note over C,T: Pōʻai kākau lipine
    C->>C: computer-c-write-to-tape.sh
    C->>T: Hele i ka hopena o ka ʻikepili + hoʻopili i ka waihona
    T-->>C: Kūleʻa ke kākau
    C->>C: Kau i .taped (a hoʻomaʻemaʻe e like me ka retention)

    opt Inventori a ka mea lawelawe
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marker ma marker
    end

    opt Noi hoʻihoʻi a ka mea lawelawe
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Payload waihona ma ka marker i kūlike
        C-->>A: .tar.gz i hoʻihoʻi ʻia no ka nānā
    end
```

[← README (ʻŌlelo Hawaiʻi)](../README.haw.md)
