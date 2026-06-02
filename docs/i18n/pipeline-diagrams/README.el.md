# Διαγράμματα pipeline A/B/C (Ελληνικά)

[← README (Ελληνικά)](../README.el.md)

Αυτό το μεταφρασμένο αντίγραφο συνδέει τα διαγράμματα pipeline με το αντίστοιχο μεταφρασμένο README.

## Διάγραμμα καταστάσεων συμβάντων

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Ο Computer A εκπέμπει συμβάντα rsyslog

    A_WritingLogs --> B_HourlyRotate : ωριαίο cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : δημιουργήθηκε περιστραμμένο ωριαίο αρχείο καταγραφής
    B_WaitMoreLogs --> B_DailyArchive : ημερήσιο cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : δημιουργήθηκε .tar.gz (ή .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : μεταφορά scp προς Computer C
    B_SendArchives --> B_RetryLater : ο C είναι απασχολημένος (δείκτης .busy) ή αποτυχία μεταφοράς
    B_RetryLater --> B_SendArchives : παράθυρο επανάληψης

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : έγινε αποδοχή + μπήκε σε ουρά
    C_ReceiveValidate --> C_Reject : μη έγκυρο αρχείο

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : το αρχείο προστέθηκε στην ταινία + δείκτης .taped
    C_WriteTape --> C_WaitTape : χωρίς ταινία/χώρο/σφάλμα
    C_WaitTape --> C_WriteTape : επανάληψη στην επόμενη εκτέλεση

    C_Taped --> C_Inventory : κατ’ απαίτηση / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : κατ’ απαίτηση / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : έξοδος ανακτημένου αρχείου
```

## Διάγραμμα ακολουθίας

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (πηγή rsyslog)
    participant B as Computer B (αρχειοθέτηση/αποστολή)
    participant C as Computer C (παραλαβή/ταινία)
    participant T as Συσκευή ταινίας

    Note over A,B: Ωριαία εισαγωγή/περιστροφή
    A->>B: Συνεχής αποστολή συμβάντων rsyslog
    B->>B: computer-b-hourly-rotate.sh (ωριαία)

    Note over B: Ημερήσια συσκευασία
    B->>B: computer-b-daily-archive.sh (ημερήσια)
    B->>B: Δημιουργία .tar.gz (ή .tar.gz.enc)

    Note over B,C: Μεταφορά σε έναν ή περισσότερους διακομιστές C
    B->>C: computer-b-send-archives.sh μέσω scp
    alt Ο C είναι απασχολημένος (δείκτης .busy)
        C-->>B: Ένδειξη απασχόλησης
        B->>B: Αναμονή/επανάληψη/εφεδρικός διακομιστής
    else Η μεταφορά έγινε αποδεκτή
        C-->>B: Το αρχείο παραλήφθηκε
    end

    Note over C: Παραλαβή και ουρά
    C->>C: computer-c-receive-archives.sh
    alt Το αρχείο είναι έγκυρο
        C->>C: Ουρά για εγγραφή σε ταινία
    else Το αρχείο δεν είναι έγκυρο
        C->>C: Απόρριψη + καταγραφή σφάλματος
    end

    Note over C,T: Βρόχος εγγραφής ταινίας
    C->>C: computer-c-write-to-tape.sh
    C->>T: Μετάβαση στο τέλος δεδομένων + προσάρτηση αρχείου
    T-->>C: Επιτυχής εγγραφή
    C->>C: Σήμανση .taped (και καθαρισμός βάσει διατήρησης)

    opt Απογραφή από χειριστή
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Πίνακας περιεχομένων ανά δείκτη
    end

    opt Αίτημα επαναφοράς από χειριστή
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Αρχειοθετημένο φορτίο στο αντίστοιχο marker
        C-->>A: Ανακτημένο .tar.gz για έλεγχο
    end
```

[← README (Ελληνικά)](../README.el.md)
