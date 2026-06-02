# A/B/C Pipeline Diagrams (Deutsch)

[← README (Deutsch)](../README.de.md)

Diese lokalisierte Version verknüpft die Pipeline-Diagramme mit der entsprechenden lokalisierten README.

## Ereignis-Zustandsdiagramm

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A erzeugt rsyslog-Ereignisse

    A_WritingLogs --> B_HourlyRotate : stündlicher cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : rotiertes Stundenlog erstellt
    B_WaitMoreLogs --> B_DailyArchive : täglicher cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (oder .tar.gz.enc) erstellt

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : scp-Übertragung zu Computer C
    B_SendArchives --> B_RetryLater : C beschäftigt (.busy-Marker) oder Übertragungsfehler
    B_RetryLater --> B_SendArchives : Wiederholfenster

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : akzeptiert + eingereiht
    C_ReceiveValidate --> C_Reject : ungültiges Archiv

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : Archiv an Band angehängt + .taped-Marker
    C_WriteTape --> C_WaitTape : kein Band/kein Platz/Fehler
    C_WaitTape --> C_WriteTape : Wiederholung beim nächsten Lauf

    C_Taped --> C_Inventory : bei Bedarf / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : bei Bedarf / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : wiederhergestellte Archiv-Ausgabe
```

## Sequenzdiagramm

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (rsyslog-Quelle)
    participant B as Computer B (Archivierung/Versand)
    participant C as Computer C (Empfang/Band)
    participant T as Bandgerät

    Note over A,B: Stündliche Aufnahme/Rotation
    A->>B: rsyslog-Ereignisse fortlaufend senden
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Tägliche Paketierung
    B->>B: computer-b-daily-archive.sh
    B->>B: .tar.gz (oder .tar.gz.enc) erstellen

    Note over B,C: Übertragung an einen oder mehrere C-Server
    B->>C: computer-b-send-archives.sh über scp
    alt C ist beschäftigt (.busy-Marker)
        C-->>B: Beschäftigt-Signal
        B->>B: Warten/Wiederholen/Fallback-Server
    else Übertragung akzeptiert
        C-->>B: Archiv empfangen
    end

    Note over C: Annahme und Warteschlange
    C->>C: computer-c-receive-archives.sh
    alt Archiv gültig
        C->>C: Für Bandschreiben einreihen
    else Archiv ungültig
        C->>C: Ablehnen + Fehler protokollieren
    end

    Note over C,T: Band-Schreibschleife
    C->>C: computer-c-write-to-tape.sh
    C->>T: Zum Datenende springen + Archiv anhängen
    T-->>C: Schreiben erfolgreich
    C->>C: .taped markieren (und gemäß Aufbewahrung aufräumen)

    opt Operator-Inventur
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Inhaltsverzeichnis Marker für Marker
    end

    opt Operator-Wiederherstellungsanfrage
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Archivnutzdaten am passenden Marker
        C-->>A: Wiederhergestelltes .tar.gz zur Prüfung
    end
```

[← README (Deutsch)](../README.de.md)
