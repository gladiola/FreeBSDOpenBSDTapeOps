# Диаграммы конвейера A/B/C (Русский)

[← README (Русский)](../README.ru.md)

Эта локализованная копия связывает диаграммы конвейера с соответствующим локализованным README.

## Диаграмма состояний событий

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : Computer A отправляет события rsyslog

    A_WritingLogs --> B_HourlyRotate : ежечасный cron / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : создан ротированный почасовой лог
    B_WaitMoreLogs --> B_DailyArchive : ежедневный cron / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : создан .tar.gz (или .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : передача scp на Computer C
    B_SendArchives --> B_RetryLater : C занят (маркер .busy) или сбой передачи
    B_RetryLater --> B_SendArchives : окно повтора

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : принят + поставлен в очередь
    C_ReceiveValidate --> C_Reject : некорректный архив

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : архив добавлен на ленту + маркер .taped
    C_WriteTape --> C_WaitTape : нет ленты/места/ошибка
    C_WaitTape --> C_WriteTape : повтор в следующем запуске

    C_Taped --> C_Inventory : по запросу / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : по запросу / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : восстановленный архив на выходе
```

## Диаграмма последовательности

```mermaid
sequenceDiagram
    autonumber
    participant A as Computer A (источник rsyslog)
    participant B as Computer B (архивация/отправка)
    participant C as Computer C (приём/лента)
    participant T as Ленточное устройство

    Note over A,B: Ежечасный приём/ротация
    A->>B: Непрерывная отправка событий rsyslog
    B->>B: computer-b-hourly-rotate.sh (ежечасно)

    Note over B: Ежедневная упаковка
    B->>B: computer-b-daily-archive.sh (ежедневно)
    B->>B: Создание .tar.gz (или .tar.gz.enc)

    Note over B,C: Передача на один или несколько серверов C
    B->>C: computer-b-send-archives.sh через scp
    alt C занят (маркер .busy)
        C-->>B: Сигнал занятости
        B->>B: Ожидание/повтор/резервный сервер
    else Передача принята
        C-->>B: Архив получен
    end

    Note over C: Приём и очередь
    C->>C: computer-c-receive-archives.sh
    alt Архив корректен
        C->>C: Постановка в очередь на запись на ленту
    else Архив некорректен
        C->>C: Отклонение + запись ошибки в лог
    end

    Note over C,T: Цикл записи на ленту
    C->>C: computer-c-write-to-tape.sh
    C->>T: Переход к концу данных + добавление архива
    T-->>C: Запись успешна
    C->>C: Установка .taped (и очистка по срокам хранения)

    opt Инвентаризация оператором
        C->>T: computer-c-inventory-tape.sh
        T-->>C: Оглавление маркер за маркером
    end

    opt Запрос восстановления от оператора
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Архивные данные по найденному маркеру
        C-->>A: Восстановленный .tar.gz для проверки
    end
```

[← README (Русский)](../README.ru.md)
