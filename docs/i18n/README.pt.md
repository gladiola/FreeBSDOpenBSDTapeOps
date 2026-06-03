# FreeBSDOpenBSDTapeOps (Português)

Scripts de shell interativos que orientam operações comuns de fita magnética usando `mt` e `tar`.

## Índice de documentação por idioma

- [US English](README.en-US.md)
- [Deutsch (German)](README.de.md)
- [Español (Spanish)](README.es.md)
- [Français (French)](README.fr.md)
- [Português (Portuguese)](README.pt.md)
- [Italiano (Italian)](README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](README.zh-HK.md)
- [简体中文 (Simplified Chinese)](README.zh-CN.md)
- [한국어 (Korean)](README.ko.md)
- [हिन्दी (Hindi)](README.hi.md)
- [Русский (Russian)](README.ru.md)
- [العربية (Arabic)](README.ar.md)
- [Kiswahili (Swahili)](README.sw.md)
- [日本語 (Japanese)](README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](README.haw.md)
- [Gagana Samoa (Samoan)](README.sm.md)
- [Te Reo Māori (Maori)](README.mi.md)
- [Afrikaans](README.af.md)
- [Nederlands (Dutch)](README.nl.md)
- [Hausa](README.ha.md)
- [አማርኛ (Amharic)](README.am.md)
- [Yorùbá (Yoruba)](README.yo.md)
- [বাংলা (Bengali)](README.bn.md)
- [Gaeilge (Irish)](README.ga.md)
- [Eesti (Estonian)](README.et.md)
- [Suomi (Finnish)](README.fi.md)
- [Svenska (Swedish)](README.sv.md)
- [Norsk (Norwegian)](README.no.md)
- [Українська (Ukrainian)](README.uk.md)
- [ไทย (Thai)](README.th.md)
- [Bahasa Indonesia](README.id.md)
- [Tagalog](README.tl.md)
- [Bahasa Melayu (Malay)](README.ms.md)
- [Basa Jawa (Javanese)](README.jv.md)
- [Ελληνικά (Greek)](README.el.md)
- [Latina (Latin)](README.la.md)
- [עברית (Hebrew)](README.he.md)


## Scripts

| Script | SO de destino |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Ambos os scripts executam a mesma sequência de operações:

1. Solicitar que o usuário confirme que a fita está carregada.
2. Rebobinar a fita.
3. Imprimir o status da fita.
4. Listar o conteúdo dos arquivos nas posições de arquivo 0, 1, 2 e 3 usando `tar t`.
5. Colocar a fita offline.

Cada etapa pausa e aguarda o usuário pressionar **Enter** antes de continuar, tornando os scripts adequados como demonstrações interativas ou guias orientados.

## Diferenças entre os dois scripts

### 1. Caminho do dispositivo de fita

Os scripts visam diferentes nós de dispositivo de fita:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Ambos são nós de dispositivo sem rebobinamento (prefixo `n`), então a posição da fita é preservada entre comandos e os scripts controlam o posicionamento explicitamente com `mt rewind` e `mt fsf`.

### 2. Etapa de carregamento da fita

- **FreeBSD**: Emite `mt -f /dev/nsa0 load` na inicialização para carregar mecanicamente o cartucho de fita na unidade antes de rebobinar.
- **OpenBSD**: Pula o comando `load` porque o `mt(1)` do OpenBSD não suporta um subcomando `load`. O script do OpenBSD assume que a fita já está presente na unidade e segue direto para o rebobinamento.

## Scripts de pipeline de logs OpenBSD A-para-B-para-C

O diretório `scripts/` fornece scripts para o cenário em que o Computador B OpenBSD recebe entradas rsyslog do Computador A, as agrupa diariamente, envia para um de vários servidores Computador C, e o Computador C as grava em fita.

| Script | Finalidade |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Cria um log rotacionado por hora a partir do arquivo de entrada rsyslog ativo no Computador B. |
| `scripts/computer-b-daily-archive.sh` | Agrupa um dia (`YYYYMMDD`) de logs horários em um arquivo `.tar.gz` com faixa de tempo no Computador B, excluindo a hora atual para evitar conflitos de escrita ativa. |
| `scripts/computer-b-send-archives.sh` | Envia arquivos diários não enviados (`.tar.gz` e opcionalmente `.tar.gz.enc`) do Computador B para um ou mais servidores Computador C via `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valida arquivos de texto puro recebidos e enfileira arquivos em texto puro/criptografados para fita. |
| `scripts/computer-c-write-to-tape.sh` | Grava em fita arquivos enfileirados em texto puro ou criptografados, verifica espaço, anexa com segurança e os marca como gravados. |
| `scripts/computer-c-inventory-tape.sh` | Imprime um índice da fita por marcador de arquivo para que operadores localizem arquivos rapidamente. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Varre posições de arquivo da fita para um arquivo solicitado, descriptografa quando necessário e salva os dados recuperados em um arquivo. |
| `scripts/test-computer-a-b-c-integration.sh` | Executa um teste de integração local determinístico A→B→C (incluindo restauração da fita) que não depende do tempo de relógio. |

Agendamento típico:

- Execute `computer-b-hourly-rotate.sh` a cada hora (cron no B).
- Execute `computer-b-daily-archive.sh` uma vez por dia (cron no B).
- Execute `computer-b-send-archives.sh` após a criação do arquivo (cron no B).
- Execute `computer-c-receive-archives.sh` periodicamente no C.
- Execute `computer-c-write-to-tape.sh` periodicamente no C com o dispositivo de fita correto.
- Execute `computer-c-inventory-tape.sh` no C quando precisar de um índice marcador por marcador.
- Execute `computer-c-restore-archive-from-tape.sh` no C quando precisar recuperar um arquivo específico para inspeção.

Todos os scripts do pipeline também emitem mensagens operacionais para syslog via `logger` (por exemplo, visíveis via rsyslog/journaling), além da saída no console.

### Envio para múltiplos servidores a partir do Computador B

`computer-b-send-archives.sh` suporta tanto modo de servidor único quanto modo de múltiplos servidores:

- Servidor único: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Múltiplos servidores: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opções de seleção de servidor no lado cliente:

- Forneça um servidor nos argumentos para fixar em um único Computador C.
- Forneça vários servidores para permitir contingência.
- Defina `PREFERRED_SERVER=user@host` para escolher um servidor específico da lista fornecida.

Opções de tratamento de ocupado no Computador B:

- `REMOTE_BUSY_MARKER` (padrão: `.busy`): arquivo marcador verificado no lado remoto.
- `BUSY_RETRY_SECONDS` (padrão: `60`): tempo de espera entre tentativas enquanto o servidor está ocupado.
- `BUSY_MAX_RETRIES` (padrão: `10`): máximo de tentativas por servidor.

### Publicação de estado ocupado a partir do Computador C

`computer-c-write-to-tape.sh` cria um marcador de ocupado enquanto grava ativamente arquivos em fita e o remove quando ocioso.

- `BUSY_MARKER` (padrão: `<received_dir>/.busy`)

Aponte `REMOTE_BUSY_MARKER` no Computador B para o local do marcador usado pelo Computador C.

### Segurança de fita e comportamento de anexação no Computador C

Antes de gravar cada arquivo, `computer-c-write-to-tape.sh` verifica a capacidade disponível da fita/dispositivo e exige pelo menos:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variáveis relevantes:

- `TAPE_SAFETY_MARGIN_BYTES` (padrão: `10485760`)
- `TAPE_AVAILABLE_BYTES` (substituição para espaço disponível conhecido)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (permite gravação se o espaço não puder ser detectado)

Para dispositivos de fita reais, o processo de gravação busca o fim dos dados (`mt eom`/`mt eod`) antes de gravar, então múltiplos arquivos são anexados em vez de sobrescrever conteúdos anteriores da fita.

### Carimbos de data/hora legíveis em nomes de arquivo

- Logs horários são nomeados como: `rsyslog-2026-06-01T1600.log`
- Arquivos diários são nomeados como: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

As faixas dos arquivos diários são baseadas nos arquivos horários reais inicial e final incluídos no arquivo.
Esses nomes são destinados a serem legíveis por pessoas que procuram janelas de data/hora de eventos.
A hora atual é intencionalmente excluída da criação de arquivos para que gravações ativas não sejam transmitidas.

### Criptografia OpenSSL opcional para arquivos diários

`computer-b-daily-archive.sh` pode criptografar arquivos com OpenSSL após criar o tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` para criptografia simétrica (`openssl enc`, cifra padrão `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` para criptografia com certificado do destinatário (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` para escolher a cifra OpenSSL para os modos de arquivo de chave e certificado (padrão: `aes-256-gcm`).

Apenas uma dessas opções pode ser definida por vez. Saídas criptografadas usam `.tar.gz.enc`.
Por segurança, o script rejeita escolhas de cifra fracas ou não-AEAD e exige cifras da classe GCM/poly1305.

### Recuperação de arquivos da fita no Computador C

Use `computer-c-restore-archive-from-tape.sh` para localizar um arquivo específico pesquisando os arquivos da fita em ordem desde o início:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Para nomes de arquivo como `rsyslog-<start>_to_<end>.tar.gz` (ou `.tar.gz.enc`), o script identifica a correspondência correta verificando se os arquivos horários de fronteira estão presentes na carga recuperada.
- Se sua nomenclatura de arquivo for diferente, defina `TARGET_MEMBER_GLOB` para um padrão shell que corresponda a um membro que deve existir no arquivo.
- Se um arquivo estiver criptografado, forneça configurações de descriptografia conforme necessário:
  - `OPENSSL_DECRYPT_KEY_FILE` (modo simétrico `openssl enc`; cifra de descriptografia padrão: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` e `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (modo de descriptografia S/MIME)

A saída recuperada é gravada como um arquivo `.tar.gz` em texto puro para que possa ser inspecionada com ferramentas como `tar -tzf`.

### Inventário de índice da fita no Computador C

Use `computer-c-inventory-tape.sh` para imprimir um índice marcador por marcador:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

As colunas de saída incluem:

- `file_marker`: posição do marcador de arquivo da fita baseada em zero
- `status`: `ok`, `decrypted` ou `unreadable`
- `encrypted`: se a descriptografia foi necessária para inspecionar a entrada (`yes`/`no`)
- `archive_hint`: nome em estilo de arquivo inferido quando limites podem ser reconhecidos
- `first_member` / `last_member`: primeiro e último membros tar vistos nesse marcador
- `member_count`: número de membros tar encontrados nesse marcador
- `bytes`: bytes brutos lidos nesse marcador

Isso permite que um operador identifique o índice do marcador para avançar (`mt fsf <N>`) antes de operações de restauração.

### Teste de integração determinístico A/B/C

Use `scripts/test-computer-a-b-c-integration.sh` para validar a integração ponta a ponta dos Computadores A, B e C independentemente do tempo decorrido:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Este script:

1. Simula A escrevendo logs.
2. Executa rotação B e criação de arquivo diário.
3. Simula transferência para a pasta de entrada de C.
4. Executa recebimento C + gravação em fita.
5. Restaura o arquivo da fita e valida o conteúdo.

Ele usa um carimbo de dia fixo (`TEST_DAY_STAMP`, padrão `20260101`), então o comportamento é repetível e não vinculado à data/hora atual.

### Retenção de 72 horas com segurança para dados não confirmados

Os scripts agora usam por padrão uma janela de retenção de 72 horas:

- `computer-b-hourly-rotate.sh` remove logs horários antigos apenas quando existe um marcador local de confirmação `.taped` correspondente.
- `computer-b-send-archives.sh` remove arquivos locais antigos apenas quando existem tanto `.sent` quanto marcadores locais de confirmação `.taped`.
- `computer-c-write-to-tape.sh` remove apenas arquivos antigos que já possuem marcadores `.taped`.

Como resultado, arquivos que ainda não foram transmitidos com sucesso e gravados em fita são retidos mesmo quando mais antigos que `RETENTION_HOURS` (padrão `72`).
No Computador B, a limpeza local exige marcadores `.taped` locais (por exemplo, de uma etapa de sincronização de retorno ou processo de confirmação manual).
No Computador C, a idade de retenção é medida a partir do horário de modificação do marcador `.taped` (normalmente definido no momento da gravação bem-sucedida na fita).

## Diagramas do pipeline

- [Diagramas Mermaid de sequência e estado A/B/C](pipeline-diagrams/README.pt.md)
