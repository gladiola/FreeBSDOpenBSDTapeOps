# A/B/C Pipeline Diagrams (Tagalog)

[← README (Tagalog)](../README.tl.md)

Iniuugnay ng lokalisadong kopyang ito ang mga diagram ng pipeline sa katugmang lokalisadong README.

## Diagram ng Estado ng Kaganapan

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Naglalabas ang Computer A ng mga rsyslog event

    A_WritingLogs --> B_HourlyRotate : oras-oras na cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : nalikha ang inikot na oras-oras na log
    B_WaitMoreLogs --> B_DailyArchive : araw-araw na cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : nalikha ang .tar.gz (o .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : paglipat sa Computer C gamit ang scp
    B_SendArchives --> B_RetryLater : abala ang C (.busy marker) o bigong transfer
    B_RetryLater --> B_SendArchives : oras ng muling pagsubok

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : tinanggap + naka-queue
    C_ReceiveValidate --> C_Reject : hindi valid na archive

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : idinagdag ang archive sa tape + .taped marker
    C_WriteTape --> C_WaitTape : walang tape/espasyo/error
    C_WaitTape --> C_WriteTape : muling subok sa susunod na run

    C_Taped --> C_Inventory : kapag kailangan / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : kapag kailangan / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : output ng naibalik na archive
```

## Diagram ng Pagkakasunod-sunod

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (pinagmulan ng rsyslog)
    participant B as Computer B (archive/padala)
    participant C as Computer C (tanggap/tape)
    participant T as Tape Device

    Note over A,B: Oras-oras na pagtanggap/rotation
    A->>B: Patuloy na magpadala ng rsyslog event
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Araw-araw na pag-package
    B->>B: computer-b-daily-archive.sh
    B->>B: Lumikha ng .tar.gz (o .tar.gz.enc)

    Note over B,C: Ilipat sa isa o higit pang C server
    B->>C: computer-b-send-archives.sh via scp
    alt Abala ang C (.busy marker)
        C-->>B: pahiwatig na abala
        B->>B: hintay/muling subok/fallback server
    else tinanggap ang transfer
        C-->>B: natanggap ang archive
    end

    Note over C: Pagtanggap at pila
    C->>C: computer-c-receive-archives.sh
    alt valid ang archive
        C->>C: I-queue para sa pagsulat sa tape
    else hindi valid ang archive
        C->>C: Tanggihan + error log
    end

    Note over C,T: Loop ng pagrekord sa tape
    C->>C: computer-c-write-to-tape.sh
    C->>T: Pumunta sa dulo ng data + idagdag ang archive
    T-->>C: matagumpay ang sulat
    C->>C: Lagyan ng .taped (at linisin ayon sa retention)

    opt Imbentaryo ng operator
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC kada marker
    end

    opt Kahilingan ng operator na mag-restore
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: payload ng archive sa tugmang marker
        C-->>A: Naibalik na .tar.gz para sa inspeksiyon
    end
```

[← README (Tagalog)](../README.tl.md)
