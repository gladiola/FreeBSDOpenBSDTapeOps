# A/B/C Pipeline Diagrams (Italiano)

[← README (Italiano)](../README.it.md)

Questa copia localizzata collega i diagrammi della pipeline al README localizzato corrispondente.

## Diagramma di stato degli eventi

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Il Computer A emette eventi rsyslog

    A_WritingLogs --> B_HourlyRotate : cron orario / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log orario ruotato creato
    B_WaitMoreLogs --> B_DailyArchive : cron giornaliero / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (o .tar.gz.enc) prodotto

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : trasferimento scp al Computer C
    B_SendArchives --> B_RetryLater : C occupato (marcatore .busy) o errore di trasferimento
    B_RetryLater --> B_SendArchives : finestra di ritentativo

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : accettato + accodato
    C_ReceiveValidate --> C_Reject : archivio non valido

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archivio aggiunto al nastro + marcatore .taped
    C_WriteTape --> C_WaitTape : nastro/spazio/errore assente
    C_WaitTape --> C_WriteTape : ritenta alla prossima esecuzione

    C_Taped --> C_Inventory : su richiesta / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : su richiesta / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : output archivio recuperato
```

## Diagramma di sequenza

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (sorgente rsyslog)
    participant B as Computer B (archiviazione/invio)
    participant C as Computer C (ricezione/nastro)
    participant T as Dispositivo a nastro

    Note over A,B: Ingestione/rotazione oraria
    A->>B: Invia eventi rsyslog continuamente
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Impacchettamento giornaliero
    B->>B: computer-b-daily-archive.sh
    B->>B: Crea .tar.gz (o .tar.gz.enc)

    Note over B,C: Trasferimento a uno o più server C
    B->>C: computer-b-send-archives.sh tramite scp
    alt C è occupato (marcatore .busy)
        C-->>B: Indicazione di occupato
        B->>B: Attesa/ritentativo/server di fallback
    else Trasferimento accettato
        C-->>B: Archivio ricevuto
    end

    Note over C: Ricezione e coda
    C->>C: computer-c-receive-archives.sh
    alt Archivio valido
        C->>C: Accoda per scrittura su nastro
    else Archivio non valido
        C->>C: Rifiuta + registra errore
    end

    Note over C,T: Ciclo di registrazione su nastro
    C->>C: computer-c-write-to-tape.sh
    C->>T: Vai a fine dati + aggiungi archivio
    T-->>C: Scrittura riuscita
    C->>C: Marca .taped (e pulisci secondo la retention)

    opt Inventario operatore
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marcatore per marcatore
    end

    opt Richiesta di ripristino operatore
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Payload archiviato al marcatore corrispondente
        C-->>A: .tar.gz recuperato per ispezione
    end
```

[← README (Italiano)](../README.it.md)
