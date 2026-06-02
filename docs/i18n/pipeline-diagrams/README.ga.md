# A/B/C Pipeline Diagrams (Gaeilge)

[← README (Gaeilge)](../README.ga.md)

Nascann an chóip logánaithe seo na léaráidí píblíne leis an README logánaithe comhfhreagrach.

## Léaráid staid imeachtaí

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Astaíonn Ríomhaire A imeachtaí rsyslog

    A_WritingLogs --> B_HourlyRotate : cron in aghaidh na huaire / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : cruthaíodh loga uair-rothlaithe
    B_WaitMoreLogs --> B_DailyArchive : cron laethúil / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (nó .tar.gz.enc) ginte

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : aistriú scp chuig Ríomhaire C
    B_SendArchives --> B_RetryLater : C gnóthach (marcóir .busy) nó teip aistrithe
    B_RetryLater --> B_SendArchives : fuinneog atrialach

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : glactha + curtha sa scuaine
    C_ReceiveValidate --> C_Reject : cartlann neamhbhailí

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : cartlann curtha le téip + marcóir .taped
    C_WriteTape --> C_WaitTape : gan téip/spás/earráid
    C_WaitTape --> C_WriteTape : triail arís sa chéad rith eile

    C_Taped --> C_Inventory : ar éileamh / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : ar éileamh / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : aschur cartlainne aisghafa
```

## Léaráid seichimh

```mermaid
sequenceDiagram
    autonumber
    participant A as Ríomhaire A (foinse rsyslog)
    participant B as Ríomhaire B (cartlannú/seoladh)
    participant C as Ríomhaire C (fáil/téip)
    participant T as Gléas téipe

    Note over A,B: Ionsú/rothlú in aghaidh na huaire
    A->>B: Seol imeachtaí rsyslog go leanúnach
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Pacáistiú laethúil
    B->>B: computer-b-daily-archive.sh
    B->>B: Cruthaigh .tar.gz (nó .tar.gz.enc)

    Note over B,C: Aistriú chuig freastalaí C amháin nó níos mó
    B->>C: computer-b-send-archives.sh trí scp
    alt Tá C gnóthach (marcóir .busy)
        C-->>B: Tásc gnóthach
        B->>B: Fan/atriail/freastalaí cúltaca
    else Aistriú glactha
        C-->>B: Cartlann faighte
    end

    Note over C: Iontráil agus scuaine
    C->>C: computer-c-receive-archives.sh
    alt Cartlann bhailí
        C->>C: Cuir sa scuaine le scríobh ar théip
    else Cartlann neamhbhailí
        C->>C: Diúltaigh + logáil earráid
    end

    Note over C,T: Lúb taifeadta téipe
    C->>C: computer-c-write-to-tape.sh
    C->>T: Téigh go deireadh na sonraí + cuir cartlann leis
    T-->>C: Scríobh rathúil
    C->>C: Marcáil .taped (agus glanadh de réir coinneála)

    opt Fardal oibreora
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marcóir ar mharcóir
    end

    opt Iarratas aisghabhála oibreora
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Luchtú cartlainne ag marcóir meaitseála
        C-->>A: .tar.gz aisghafa le haghaidh iniúchta
    end
```

[← README (Gaeilge)](../README.ga.md)
