# Zanen Bututun A/B/C (Hausa)

[← README (Hausa)](../README.ha.md)

Wannan kwafin da aka fassara yana haɗa zane-zanen bututun da README ɗin da aka fassara daidai.

## Zanen Yanayin Abubuwan Da Suka Faru

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Kwamfuta A tana fitar da abubuwan rsyslog

    A_WritingLogs --> B_HourlyRotate : cron na kowane awa / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : an ƙirƙiri log ɗin awa da aka juya
    B_WaitMoreLogs --> B_DailyArchive : cron na kullum / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : an samar da .tar.gz (ko .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : canjin scp zuwa Kwamfuta C
    B_SendArchives --> B_RetryLater : C yana aiki (.busy marker) ko canja wuri ya gaza
    B_RetryLater --> B_SendArchives : lokacin sake gwadawa

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : an karɓa + an saka a jere
    C_ReceiveValidate --> C_Reject : archive mara inganci

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : an haɗa archive zuwa tef + alamar .taped
    C_WriteTape --> C_WaitTape : babu tef/wuri/kuskure
    C_WaitTape --> C_WriteTape : sake gwadawa a gudu na gaba

    C_Taped --> C_Inventory : idan an buƙata / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : idan an buƙata / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : fitar archive da aka dawo da shi
```

## Zanen Jere

```mermaid
sequenceDiagram
    autonumber
    participant A as Kwamfuta A (tushen rsyslog)
    participant B as Kwamfuta B (ajiya/aikawa)
    participant C as Kwamfuta C (karɓa/tef)
    participant T as Na’urar Tef

    Note over A,B: Shigarwa/juyawa na kowane awa
    A->>B: Aika abubuwan rsyslog ba tare da tsayawa ba
    B->>B: computer-b-hourly-rotate.sh (kowane awa)

    Note over B: Kunshin kullum
    B->>B: computer-b-daily-archive.sh (kullum)
    B->>B: Ƙirƙiri .tar.gz (ko .tar.gz.enc)

    Note over B,C: Canja wuri zuwa sabar C ɗaya ko fiye
    B->>C: computer-b-send-archives.sh ta scp
    alt C yana aiki (.busy marker)
        C-->>B: sakon aiki
        B->>B: jira/sake gwadawa/sabar madadin
    else an amince da canja wurin
        C-->>B: an karɓi archive
    end

    Note over C: Karɓa da jere
    C->>C: computer-c-receive-archives.sh
    alt archive yana da inganci
        C->>C: saka a jeren rubuta tef
    else archive mara inganci
        C->>C: ƙi + rubuta kuskure a log
    end

    Note over C,T: Madawarin rubuta tef
    C->>C: computer-c-write-to-tape.sh
    C->>T: nemo ƙarshen bayanai + haɗa archive
    T-->>C: rubutu ya yi nasara
    C->>C: sanya .taped (da tsaftacewa bisa retention)

    opt ƙididdigar mai aiki
        C->>T: computer-c-inventory-tape.sh
        T-->>C: jadawalin abun ciki alama-bayan-alama
    end

    opt buƙatar dawo da bayanai ta mai aiki
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: abubuwan archive a alamar da ta dace
        C-->>A: .tar.gz da aka dawo domin dubawa
    end
```

[← README (Hausa)](../README.ha.md)
