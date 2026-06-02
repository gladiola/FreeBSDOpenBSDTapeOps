# Michoro ya Mlolongo wa A/B/C (Kiswahili)

[← README (Kiswahili)](../README.sw.md)

Nakala hii iliyotafsiriwa inaunganisha michoro ya mlolongo na README iliyotafsiriwa inayolingana.

## Mchoro wa Hali za Matukio

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Kompyuta A hutuma matukio ya rsyslog

    A_WritingLogs --> B_HourlyRotate : cron ya kila saa / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : logi ya saa iliyozungushwa imeundwa
    B_WaitMoreLogs --> B_DailyArchive : cron ya kila siku / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (au .tar.gz.enc) imetengenezwa

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : uhamisho wa scp kwenda Kompyuta C
    B_SendArchives --> B_RetryLater : C iko busy (alama .busy) au uhamisho umeshindwa
    B_RetryLater --> B_SendArchives : dirisha la kujaribu tena

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : imekubaliwa + imewekwa foleni
    C_ReceiveValidate --> C_Reject : arkivu batili

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arkivu imeongezwa kwenye tepu + alama .taped
    C_WriteTape --> C_WaitTape : hakuna tepu/nafasi/kosa
    C_WaitTape --> C_WriteTape : jaribu tena kwenye mzunguko unaofuata

    C_Taped --> C_Inventory : kwa mahitaji / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : kwa mahitaji / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : matokeo ya arkivu iliyorejeshwa
```

## Mchoro wa Mfuatano

```mermaid
sequenceDiagram
    autonumber
    participant A as Kompyuta A (chanzo cha rsyslog)
    participant B as Kompyuta B (kuhifadhi/kutuma)
    participant C as Kompyuta C (kupokea/tepu)
    participant T as Kifaa cha Tepu

    Note over A,B: Uingizaji/uzungushaji wa kila saa
    A->>B: Tuma matukio ya rsyslog mfululizo
    B->>B: computer-b-hourly-rotate.sh (kila saa)

    Note over B: Ufungashaji wa kila siku
    B->>B: computer-b-daily-archive.sh (kila siku)
    B->>B: Tengeneza .tar.gz (au .tar.gz.enc)

    Note over B,C: Uhamisho kwa seva moja au zaidi za C
    B->>C: computer-b-send-archives.sh kupitia scp
    alt C iko busy (alama .busy)
        C-->>B: ishara ya busy
        B->>B: subiri/jaribu tena/seva mbadala
    else Uhamisho umekubaliwa
        C-->>B: Arkivu imepokelewa
    end

    Note over C: Upokeaji na foleni
    C->>C: computer-c-receive-archives.sh
    alt Arkivu ni halali
        C->>C: Weka foleni ya kuandika tepu
    else Arkivu si halali
        C->>C: Kataa + andika kosa kwenye logi
    end

    Note over C,T: Mzunguko wa kurekodi tepu
    C->>C: computer-c-write-to-tape.sh
    C->>T: Tafuta mwisho wa data + ongeza arkivu
    T-->>C: Uandishi umefanikiwa
    C->>C: Weka alama .taped (na safisha kulingana na retention)

    opt Ukaguzi wa mwendeshaji
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Yaliyomo kwa alama moja baada ya nyingine
    end

    opt Ombi la kurejesha la mwendeshaji
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Mzigo wa arkivu kwenye alama iliyolingana
        C-->>A: .tar.gz iliyorejeshwa kwa ukaguzi
    end
```

[← README (Kiswahili)](../README.sw.md)
