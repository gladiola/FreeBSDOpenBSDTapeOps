# Dyagram Pipeline A/B/C (Kreyòl Ayisyen)

[← README (Kreyòl Ayisyen)](../README.ht.md)

Kopi lokalize sa a konekte dyagram pipeline yo ak README lokalize ki koresponn lan.

## Dyagram Eta Evènman

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Òdinatè A emèt evènman rsyslog

    A_WritingLogs --> B_HourlyRotate : cron chak èdtan / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log èdtan ki vire a kreye
    B_WaitMoreLogs --> B_DailyArchive : cron chak jou / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (oswa .tar.gz.enc) pwodwi

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transfè scp pou Òdinatè C
    B_SendArchives --> B_RetryLater : C okipe (.busy marker) oswa echèk transfè
    B_RetryLater --> B_SendArchives : fenèt pou rekòmanse eseye

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : aksepte + mete nan keu
    C_ReceiveValidate --> C_Reject : achiv pa valab

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : achiv ajoute sou bann + makè .taped
    C_WriteTape --> C_WaitTape : pa gen bann/espas/erè
    C_WaitTape --> C_WriteTape : eseye ankò nan pwochen kouri a

    C_Taped --> C_Inventory : lè yo mande / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : lè yo mande / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : sòti achiv retabli
```

## Dyagram Sekans

```mermaid
sequenceDiagram
    autonumber
    participant A as Òdinatè A (sous rsyslog)
    participant B as Òdinatè B (achiv/voye)
    participant C as Òdinatè C (resevwa/bann)
    participant T as Aparèy Bann

    Note over A,B: Antre/rotasyon chak èdtan
    A->>B: Voye evènman rsyslog san rete
    B->>B: computer-b-hourly-rotate.sh (chak èdtan)

    Note over B: Anbalaj chak jou
    B->>B: computer-b-daily-archive.sh (chak jou)
    B->>B: Kreye .tar.gz (oswa .tar.gz.enc)

    Note over B,C: Transfè pou youn oswa plizyè sèvè C
    B->>C: computer-b-send-archives.sh atravè scp
    alt C okipe (.busy marker)
        C-->>B: endikasyon okipe
        B->>B: tann/eseye ankò/sèvè sekou
    else transfè a aksepte
        C-->>B: achiv resevwa
    end

    Note over C: Antre ak keu
    C->>C: computer-c-receive-archives.sh
    alt achiv la valab
        C->>C: mete nan keu pou ekri sou bann
    else achiv la pa valab
        C->>C: rejte + anrejistre erè
    end

    Note over C,T: Boukl anrejistreman bann
    C->>C: computer-c-write-to-tape.sh
    C->>T: chèche fen done + ajoute achiv
    T-->>C: ekriti reyisi
    C->>C: make .taped (epi netwaye selon retention)

    opt envantè operatè
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC makè-pa-makè
    end

    opt demann retablisman operatè
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: chaj achiv sou makè ki matche
        C-->>A: .tar.gz retabli pou enspeksyon
    end
```

[← README (Kreyòl Ayisyen)](../README.ht.md)
