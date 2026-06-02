# A/B/C Pipeline Diagrams (Português)

[← README (Português)](../README.pt.md)

Esta cópia localizada liga os diagramas do pipeline ao README localizado correspondente.

## Diagrama de estados de eventos

```mermaid
stateDiagram-v2
    [*] --> A_WritingLogs : O Computador A emite eventos rsyslog

    A_WritingLogs --> B_HourlyRotate : cron horário / computer-b-hourly-rotate.sh
    B_HourlyRotate --> B_WaitMoreLogs : log horário rotacionado criado
    B_WaitMoreLogs --> B_DailyArchive : cron diário / computer-b-daily-archive.sh
    B_DailyArchive --> B_ArchiveReady : .tar.gz (ou .tar.gz.enc) gerado

    B_ArchiveReady --> B_SendArchives : computer-b-send-archives.sh
    B_SendArchives --> C_Incoming : transferência scp para o Computador C
    B_SendArchives --> B_RetryLater : C ocupado (marcador .busy) ou falha na transferência
    B_RetryLater --> B_SendArchives : janela de nova tentativa

    C_Incoming --> C_ReceiveValidate : computer-c-receive-archives.sh
    C_ReceiveValidate --> C_QueueForTape : aceito + enfileirado
    C_ReceiveValidate --> C_Reject : arquivo inválido

    C_QueueForTape --> C_WriteTape : computer-c-write-to-tape.sh
    C_WriteTape --> C_Taped : arquivo anexado à fita + marcador .taped
    C_WriteTape --> C_WaitTape : sem fita/espaço/erro
    C_WaitTape --> C_WriteTape : nova tentativa na próxima execução

    C_Taped --> C_Inventory : sob demanda / computer-c-inventory-tape.sh
    C_Inventory --> C_Restore : sob demanda / computer-c-restore-archive-from-tape.sh
    C_Restore --> [*] : saída de arquivo recuperado
```

## Diagrama de sequência

```mermaid
sequenceDiagram
    autonumber
    participant A as Computador A (origem rsyslog)
    participant B as Computador B (arquivo/envio)
    participant C as Computador C (recebimento/fita)
    participant T as Dispositivo de fita

    Note over A,B: Ingestão/rotação horária
    A->>B: Enviar eventos rsyslog continuamente
    B->>B: computer-b-hourly-rotate.sh

    Note over B: Empacotamento diário
    B->>B: computer-b-daily-archive.sh
    B->>B: Criar .tar.gz (ou .tar.gz.enc)

    Note over B,C: Transferência para um ou mais servidores C
    B->>C: computer-b-send-archives.sh via scp
    alt C está ocupado (marcador .busy)
        C-->>B: Indicação de ocupado
        B->>B: Esperar/tentar novamente/servidor alternativo
    else Transferência aceita
        C-->>B: Arquivo recebido
    end

    Note over C: Entrada e fila
    C->>C: computer-c-receive-archives.sh
    alt Arquivo válido
        C->>C: Enfileirar para gravação em fita
    else Arquivo inválido
        C->>C: Rejeitar + registrar erro
    end

    Note over C,T: Loop de gravação em fita
    C->>C: computer-c-write-to-tape.sh
    C->>T: Buscar fim dos dados + anexar arquivo
    T-->>C: Gravação bem-sucedida
    C->>C: Marcar .taped (e limpar conforme retenção)

    opt Inventário do operador
        C->>T: computer-c-inventory-tape.sh
        T-->>C: TOC marcador por marcador
    end

    opt Pedido de restauração do operador
        C->>T: computer-c-restore-archive-from-tape.sh
        T-->>C: Carga arquivada no marcador correspondente
        C-->>A: .tar.gz recuperado para inspeção
    end
```

[← README (Português)](../README.pt.md)
