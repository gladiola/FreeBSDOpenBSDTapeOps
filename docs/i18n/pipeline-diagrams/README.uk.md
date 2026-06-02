# Діаграми конвеєра A/B/C (Українська)

[← README (Українська)](../README.uk.md)

Ця локалізована копія пов’язує діаграми конвеєра з відповідним локалізованим README.

## Діаграма станів подій

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A надсилає події rsyslog

    A_WritingLogs --> B_HourlyRotate : щогодинний cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : створено ротований погодинний лог
    B_WaitMoreLogs --> B_DailyArchive : щоденний cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : створено .tar.gz (або .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : передача scp на Computer C
    B_SendArchives --> B_RetryLater : C зайнятий (маркер .busy) або збій передачі
    B_RetryLater --> B_SendArchives : вікно повтору

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : прийнято + додано в чергу
    C_ReceiveValidate --> C_Reject : недійсний архів

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : архів дописано на стрічку + маркер .taped
    C_WriteTape --> C_WaitTape : немає стрічки/місця/помилка
    C_WaitTape --> C_WriteTape : повтор у наступному запуску

    C_Taped --> C_Inventory : за запитом / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : за запитом / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : відновлений архів на виході
```

## Діаграма послідовності

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (джерело rsyslog)
    participant B as Computer B (архівація/відправка)
    participant C as Computer C (прийом/стрічка)
    participant T as Стрічковий пристрій

    Note over A,B: Щогодинний прийом/ротація
    A->>B: Безперервне надсилання подій rsyslog
    B->>B: computer-b-hourly-rotate.sh (щогодини)

    Note over B: Щоденне пакування
    B->>B: computer-b-daily-archive.sh (щодня)
    B->>B: Створення .tar.gz (або .tar.gz.enc)

    Note over B,C: Передача на один або кілька серверів C
    B->>C: computer-b-send-archives.sh через scp
    alt C зайнятий (маркер .busy)
        C-->>B: Сигнал зайнятості
        B->>B: Очікування/повтор/резервний сервер
    else Передачу прийнято
        C-->>B: Архів отримано
    end

    Note over C: Прийом і черга
    C->>C: computer-c-receive-archives.sh
    alt Архів дійсний
        C->>C: Додати в чергу на запис на стрічку
    else Архів недійсний
        C->>C: Відхилити + записати помилку в лог
    end

    Note over C,T: Цикл запису на стрічку
    C->>C: computer-c-write-to-tape.sh
    C->>T: Перейти в кінець даних + дописати архів
    T-->>C: Запис успішний
    C->>C: Позначити .taped (і очистити за строками зберігання)

    opt Інвентаризація оператором
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Зміст маркер за маркером
    end

    opt Запит на відновлення від оператора
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Архівні дані за знайденим маркером
        C-->>A: Відновлений .tar.gz для перевірки
    end
```

[← README (Українська)](../README.uk.md)
