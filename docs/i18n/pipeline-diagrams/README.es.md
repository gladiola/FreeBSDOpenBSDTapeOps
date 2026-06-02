# A/B/C Pipeline Diagrams (Español)

[← README (Español)](../README.es.md)

Esta copia localizada vincula los diagramas de la canalización con el README localizado correspondiente.

## Diagrama de estados de eventos

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : La Computadora A emite eventos de rsyslog

    A_WritingLogs --> B_HourlyRotate : cron horario / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : registro horario rotado creado
    B_WaitMoreLogs --> B_DailyArchive : cron diario / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : se genera .tar.gz (o .tar.gz.enc)

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transferencia scp a la Computadora C
    B_SendArchives --> B_RetryLater : C ocupada (marcador .busy) o fallo de transferencia
    B_RetryLater --> B_SendArchives : ventana de reintento

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : aceptado + en cola
    C_ReceiveValidate --> C_Reject : archivo no válido

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : archivo anexado a cinta + marcador .taped
    C_WriteTape --> C_WaitTape : sin cinta/espacio/error
    C_WaitTape --> C_WriteTape : reintento en la siguiente ejecución

    C_Taped --> C_Inventory : bajo demanda / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : bajo demanda / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : salida del archivo recuperado
```

## Diagrama de secuencia

```mermaid
sequenceDiagram
    autonumber
    participant A as Computadora A (origen rsyslog)
    participant B as Computadora B (archivo/envío)
    participant C as Computadora C (recepción/cinta)
    participant T as Dispositivo de cinta

    Note over A,B: Ingesta/rotación horaria
    A->>B: Enviar eventos de rsyslog continuamente
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Empaquetado diario
    B->>B: computer-b-daily-archive.sh
    B->>B: Crear .tar.gz (o .tar.gz.enc)

    Note over B,C: Transferencia a uno o más servidores C
    B->>C: computer-b-send-archives.sh vía scp
    alt C está ocupada (marcador .busy)
        C-->>B: Indicación de ocupado
        B->>B: Esperar/reintentar/servidor alternativo
    else Transferencia aceptada
        C-->>B: Archivo recibido
    end

    Note over C: Recepción y cola
    C->>C: computer-c-receive-archives.sh
    alt Archivo válido
        C->>C: Poner en cola para escritura en cinta
    else Archivo no válido
        C->>C: Rechazar + registrar error
    end

    Note over C,T: Bucle de grabación en cinta
    C->>C: computer-c-write-to-tape.sh
    C->>T: Buscar fin de datos + anexar archivo
    T-->>C: Escritura correcta
    C->>C: Marcar .taped (y limpiar según retención)

    opt Inventario del operador
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marcador por marcador
    end

    opt Solicitud de restauración del operador
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Carga archivada en el marcador coincidente
        C-->>A: .tar.gz recuperado para inspección
    end
```

[← README (Español)](../README.es.md)
