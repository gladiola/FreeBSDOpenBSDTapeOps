# תרשימי צינור עיבוד A/B/C (עברית)

[← README (עברית)](../README.he.md)

העותק המתורגם הזה מקשר את תרשימי הצינור לקובץ README המתורגם המתאים.

## תרשים מצבי אירועים

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : מחשב A מפיק אירועי rsyslog

    A_WritingLogs --> B_HourlyRotate : cron שעתי / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : נוצר לוג שעתי מסובב
    B_WaitMoreLogs --> B_DailyArchive : cron יומי / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : נוצר ‎.tar.gz (או ‎.tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : העברת scp למחשב C
    B_SendArchives --> B_RetryLater : C עסוק (סמן ‎.busy) או כשל בהעברה
    B_RetryLater --> B_SendArchives : חלון ניסיון חוזר

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : התקבל + הוכנס לתור
    C_ReceiveValidate --> C_Reject : ארכיון לא תקין

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : הארכיון נוסף לסרט + סמן ‎.taped
    C_WriteTape --> C_WaitTape : אין סרט/מקום/שגיאה
    C_WaitTape --> C_WriteTape : ניסיון חוזר בהרצה הבאה

    C_Taped --> C_Inventory : לפי דרישה / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : לפי דרישה / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : פלט ארכיון משוחזר
```

## תרשים רצף

```mermaid
sequenceDiagram
    autonumber
    participant A as מחשב A (מקור rsyslog)
    participant B as מחשב B (ארכוב/שליחה)
    participant C as מחשב C (קליטה/סרט)
    participant T as כונן סרט

    Note over A,B: קליטה/סיבוב לפי שעה
    A->>B: שליחת אירועי rsyslog ברצף
    B->>B: computer-b-hourly-rotate.sh (שעתי)

    Note over B: אריזה יומית
    B->>B: computer-b-daily-archive.sh (יומי)
    B->>B: יצירת ‎.tar.gz (או ‎.tar.gz.enc)

    Note over B,C: העברה לשרת C אחד או יותר
    B->>C: computer-b-send-archives.sh דרך scp
    alt C עסוק (סמן ‎.busy)
        C-->>B: סימון עסוק
        B->>B: המתנה/ניסיון חוזר/שרת חלופי
    else ההעברה התקבלה
        C-->>B: הארכיון התקבל
    end

    Note over C: קליטה ותור
    C->>C: computer-c-receive-archives.sh
    alt הארכיון תקין
        C->>C: הכנסה לתור כתיבה לסרט
    else הארכיון לא תקין
        C->>C: דחייה + רישום שגיאה
    end

    Note over C,T: לולאת כתיבה לסרט
    C->>C: computer-c-write-to-tape.sh
    C->>T: מעבר לסוף הנתונים + הוספת הארכיון
    T-->>C: הכתיבה הצליחה
    C->>C: סימון ‎.taped (וניקוי לפי מדיניות שימור)

    opt מלאי מפעיל
        C->>T: computer-c-inventory-tape.sh
        T-->>C: תוכן עניינים סמן־אחר־סמן
    end

    opt בקשת שחזור מהמפעיל
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: מטען ארכיון בסמן התואם
        C-->>A: ‎.tar.gz משוחזר לבדיקה
    end
```

[← README (עברית)](../README.he.md)
