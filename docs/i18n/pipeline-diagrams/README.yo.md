# Àwòrán Ilana A/B/C (Yorùbá)

[← README (Yorùbá)](../README.yo.md)

Ẹ̀dà ìtúmọ̀ yìí so àwọn àwòrán ilana pọ̀ mọ README ìtúmọ̀ tó bá a mu.

## Àwòrán Ìpò Ìṣẹ̀lẹ̀

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Kọ̀ǹpútà A ń ṣejáde àwọn ìṣẹ̀lẹ̀ rsyslog

    A_WritingLogs --> B_HourlyRotate : cron wákàtí kọọkan / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : a ti ṣẹda log wákàtí tí a yi padà
    B_WaitMoreLogs --> B_DailyArchive : cron ojoojúmọ́ / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : a ti ṣe .tar.gz (tàbí .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : gígbe scp sí Kọ̀ǹpútà C
    B_SendArchives --> B_RetryLater : C ń ṣiṣẹ́ lọwọ (.busy marker) tàbí ìkùnà gígbe
    B_RetryLater --> B_SendArchives : àkókò ìgbìyànjú lẹ́ẹ̀kansi

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : a gba + a fi sínú ìtòsọ́nà
    C_ReceiveValidate --> C_Reject : archive kò bófin mu

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : a fi archive kún téépù + àmì .taped
    C_WriteTape --> C_WaitTape : kò sí téépù/àyè/àṣìṣe
    C_WaitTape --> C_WriteTape : tún gbìyànjú ní ìṣiṣẹ́ tó kàn

    C_Taped --> C_Inventory : lórí ìbéèrè / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : lórí ìbéèrè / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : ìjáde archive tí a gba padà
```

## Àwòrán Àtẹ̀lé

```mermaid
sequenceDiagram
    autonumber
    participant A as Kọ̀ǹpútà A (orisun rsyslog)
    participant B as Kọ̀ǹpútà B (ìpamọ́/fífiranṣẹ́)
    participant C as Kọ̀ǹpútà C (gbigba/téépù)
    participant T as Ẹ̀rọ Téépù

    Note over A,B: Gbigba/yíyí padà lọ́ọ̀rẹ̀ẹ̀rẹ̀ wákàtí
    A->>B: Firanṣẹ́ ìṣẹ̀lẹ̀ rsyslog ní àtẹ̀síwájú
    B->>B: computer-b-hourly-rotate.sh (wákàtí kọọkan)

    Note over B: Ìdìpọ̀ ojoojúmọ́
    B->>B: computer-b-daily-archive.sh (ojoojúmọ́)
    B->>B: Ṣẹda .tar.gz (tàbí .tar.gz.enc)

    Note over B,C: Gbigbe sí olupin C kan tàbí púpọ̀
    B->>C: computer-b-send-archives.sh nípasẹ̀ scp
    alt C ń ṣiṣẹ́ lọwọ (.busy marker)
        C-->>B: ìfihàn pé ó ń ṣiṣẹ́ lọwọ
        B->>B: dúró/tún gbìyànjú/olupin àropò
    else a gba gígbe náà
        C-->>B: a gba archive náà
    end

    Note over C: Gbigba àti ìtòsọ́nà
    C->>C: computer-c-receive-archives.sh
    alt archive bófin mu
        C->>C: fi sí ìtòsọ́nà fún ìkọ̀wé téépù
    else archive kò bófin mu
        C->>C: kọ̀ + ṣàkọọlẹ̀ àṣìṣe
    end

    Note over C,T: Ìyípo ìkọ̀wé sí téépù
    C->>C: computer-c-write-to-tape.sh
    C->>T: wá òpin data + fi archive kún un
    T-->>C: ìkọ̀wé ṣàṣeyọrí
    C->>C: fi àmì .taped (kí o sì nu gẹ́gẹ́ bí retention)

    opt àkójọ oníṣiṣẹ́
        C->>T: computer-c-inventory-tape.sh
        T-->>C: àtòjọ akoonu nípa àmì kọọkan
    end

    opt ìbéèrè ìmúpada oníṣiṣẹ́
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: payload archive ní àmì tó bá mu
        C-->>A: .tar.gz tí a gba padà fún àyẹ̀wò
    end
```

[← README (Yorùbá)](../README.yo.md)
