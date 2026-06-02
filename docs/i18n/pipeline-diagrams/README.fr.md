# A/B/C Pipeline Diagrams (Français)

[← README (Français)](../README.fr.md)

Cette copie localisée relie les diagrammes du pipeline au README localisé correspondant.

## Diagramme d’état des événements

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : L’ordinateur A émet des événements rsyslog

    A_WritingLogs --> B_HourlyRotate : cron horaire / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : journal horaire pivoté créé
    B_WaitMoreLogs --> B_DailyArchive : cron quotidien / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (ou .tar.gz.enc) produit

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transfert scp vers l’ordinateur C
    B_SendArchives --> B_RetryLater : C occupé (marqueur .busy) ou échec du transfert
    B_RetryLater --> B_SendArchives : fenêtre de nouvelle tentative

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : accepté + mis en file
    C_ReceiveValidate --> C_Reject : archive invalide

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archive ajoutée sur bande + marqueur .taped
    C_WriteTape --> C_WaitTape : pas de bande/espace/erreur
    C_WaitTape --> C_WriteTape : nouvelle tentative au prochain lancement

    C_Taped --> C_Inventory : à la demande / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : à la demande / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : sortie d’archive récupérée
```

## Diagramme de séquence

```mermaid
sequenceDiagram
    autonumber
    participant A as Ordinateur A (source rsyslog)
    participant B as Ordinateur B (archivage/envoi)
    participant C as Ordinateur C (réception/bande)
    participant T as Périphérique de bande

    Note over A,B: Ingestion/rotation horaire
    A->>B: Envoyer les événements rsyslog en continu
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Conditionnement quotidien
    B->>B: computer-b-daily-archive.sh
    B->>B: Créer .tar.gz (ou .tar.gz.enc)

    Note over B,C: Transfert vers un ou plusieurs serveurs C
    B->>C: computer-b-send-archives.sh via scp
    alt C est occupé (marqueur .busy)
        C-->>B: Indication d’occupation
        B->>B: Attente/nouvelle tentative/serveur de secours
    else Transfert accepté
        C-->>B: Archive reçue
    end

    Note over C: Réception et file d’attente
    C->>C: computer-c-receive-archives.sh
    alt Archive valide
        C->>C: Mettre en file pour écriture sur bande
    else Archive invalide
        C->>C: Rejeter + journaliser l’erreur
    end

    Note over C,T: Boucle d’écriture sur bande
    C->>C: computer-c-write-to-tape.sh
    C->>T: Aller à la fin des données + ajouter l’archive
    T-->>C: Écriture réussie
    C->>C: Marquer .taped (et nettoyer selon la rétention)

    opt Inventaire opérateur
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marqueur par marqueur
    end

    opt Demande de restauration opérateur
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Charge archivée au marqueur correspondant
        C-->>A: .tar.gz récupéré pour inspection
    end
```

[← README (Français)](../README.fr.md)
