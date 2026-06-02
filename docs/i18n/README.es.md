# FreeBSDOpenBSDTapeOps (Español)

Scripts de shell interactivos que guían al usuario a través de operaciones comunes con cinta magnética usando `mt` y `tar`.

## Índice de Documentación por Idioma

- [US English](docs/i18n/README.en-US.md)
- [Deutsch (German)](docs/i18n/README.de.md)
- [Español (Spanish)](docs/i18n/README.es.md)
- [Français (French)](docs/i18n/README.fr.md)
- [Português (Portuguese)](docs/i18n/README.pt.md)
- [Italiano (Italian)](docs/i18n/README.it.md)
- [繁體中文 (香港) / Traditional Chinese (Hong Kong)](docs/i18n/README.zh-HK.md)
- [简体中文 (Simplified Chinese)](docs/i18n/README.zh-CN.md)
- [한국어 (Korean)](docs/i18n/README.ko.md)
- [हिन्दी (Hindi)](docs/i18n/README.hi.md)
- [Русский (Russian)](docs/i18n/README.ru.md)
- [العربية (Arabic)](docs/i18n/README.ar.md)
- [Kiswahili (Swahili)](docs/i18n/README.sw.md)
- [日本語 (Japanese)](docs/i18n/README.ja.md)
- [Kreyòl Ayisyen (Haitian Creole)](docs/i18n/README.ht.md)
- [ʻŌlelo Hawaiʻi (Hawaiian)](docs/i18n/README.haw.md)
- [Gagana Samoa (Samoan)](docs/i18n/README.sm.md)
- [Te Reo Māori (Maori)](docs/i18n/README.mi.md)
- [Afrikaans](docs/i18n/README.af.md)
- [Nederlands (Dutch)](docs/i18n/README.nl.md)
- [Hausa](docs/i18n/README.ha.md)
- [አማርኛ (Amharic)](docs/i18n/README.am.md)
- [Yorùbá (Yoruba)](docs/i18n/README.yo.md)
- [বাংলা (Bengali)](docs/i18n/README.bn.md)
- [Gaeilge (Irish)](docs/i18n/README.ga.md)
- [Eesti (Estonian)](docs/i18n/README.et.md)
- [Suomi (Finnish)](docs/i18n/README.fi.md)
- [Svenska (Swedish)](docs/i18n/README.sv.md)
- [Norsk (Norwegian)](docs/i18n/README.no.md)
- [Українська (Ukrainian)](docs/i18n/README.uk.md)
- [ไทย (Thai)](docs/i18n/README.th.md)
- [Bahasa Indonesia](docs/i18n/README.id.md)
- [Tagalog](docs/i18n/README.tl.md)
- [Bahasa Melayu (Malay)](docs/i18n/README.ms.md)
- [Basa Jawa (Javanese)](docs/i18n/README.jv.md)
- [Ελληνικά (Greek)](docs/i18n/README.el.md)
- [Latina (Latin)](docs/i18n/README.la.md)
- [עברית (Hebrew)](docs/i18n/README.he.md)


## Scripts

| Script | SO de Destino |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Ambos scripts realizan la misma secuencia de operaciones:

1. Solicitar al usuario que confirme que la cinta está cargada.
2. Rebobinar la cinta.
3. Imprimir el estado de la cinta.
4. Listar el contenido de los archivos en las posiciones de archivo 0, 1, 2 y 3 usando `tar t`.
5. Poner la cinta fuera de línea.

Cada paso hace una pausa y espera a que el usuario presione **Enter** antes de continuar, lo que hace que los scripts sean adecuados como demostraciones interactivas o recorridos guiados.

## Diferencias Entre los Dos Scripts

### 1. Ruta del dispositivo de cinta

Los scripts apuntan a nodos de dispositivo de cinta diferentes:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Ambos son nodos de dispositivo sin rebobinado (el prefijo `n`), por lo que la posición de la cinta se conserva entre comandos y los scripts controlan el posicionamiento explícitamente con `mt rewind` y `mt fsf`.

### 2. Paso de carga de la cinta

- **FreeBSD**: Ejecuta `mt -f /dev/nsa0 load` al inicio para cargar mecánicamente el cartucho de cinta en la unidad antes de rebobinar.
- **OpenBSD**: Omite el comando `load` porque el `mt(1)` de OpenBSD no admite un subcomando `load`. El script de OpenBSD asume que la cinta ya está presente en la unidad y procede directamente al rebobinado.

## Scripts de Tubería de Registro A-a-B-a-C de OpenBSD

El directorio `scripts/` proporciona scripts para el escenario en el que el Computador B de OpenBSD recibe entradas de rsyslog del Computador A, las agrupa diariamente, las envía a uno de varios servidores Computador C, y el Computador C las escribe en cinta.

| Script | Propósito |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Crea un registro rotado por hora a partir del archivo de entrada rsyslog activo en el Computador B. |
| `scripts/computer-b-daily-archive.sh` | Agrupa un día (`YYYYMMDD`) de registros por hora en un archivo comprimido `.tar.gz` con rango temporal en el Computador B, excluyendo la hora actual para evitar conflictos de escritura activa. |
| `scripts/computer-b-send-archives.sh` | Envía archivos diarios no enviados (`.tar.gz` y opcionalmente `.tar.gz.enc`) desde el Computador B a uno o más servidores Computador C mediante `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valida los archivos en texto plano entrantes y pone en cola los archivos en texto plano/cifrados para la cinta. |
| `scripts/computer-c-write-to-tape.sh` | Escribe en cinta los archivos en cola en texto plano o cifrados, verifica el espacio disponible, los agrega de forma segura y los marca como grabados. |
| `scripts/computer-c-inventory-tape.sh` | Imprime una tabla de contenidos de la cinta por marcador de archivo para que los operadores puedan localizar los archivos rápidamente. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Escanea las posiciones de archivo de la cinta en busca de un archivo solicitado, descifra cuando es necesario y guarda los datos recuperados en un archivo. |
| `scripts/test-computer-a-b-c-integration.sh` | Ejecuta una prueba de integración local determinista A→B→C (incluida la restauración desde cinta) que no depende del tiempo del reloj. |

Programación típica:

- Ejecutar `computer-b-hourly-rotate.sh` cada hora (cron en B).
- Ejecutar `computer-b-daily-archive.sh` una vez al día (cron en B).
- Ejecutar `computer-b-send-archives.sh` después de crear el archivo (cron en B).
- Ejecutar `computer-c-receive-archives.sh` periódicamente en C.
- Ejecutar `computer-c-write-to-tape.sh` periódicamente en C con el dispositivo de cinta correcto.
- Ejecutar `computer-c-inventory-tape.sh` en C cuando se necesite una tabla de contenidos marcador por marcador.
- Ejecutar `computer-c-restore-archive-from-tape.sh` en C cuando se necesite recuperar un archivo específico para su inspección.

Todos los scripts de la tubería también emiten mensajes operativos a syslog mediante `logger` (visibles, por ejemplo, a través de rsyslog/journaling), además de la salida en consola.

### Envío a múltiples servidores desde el Computador B

`computer-b-send-archives.sh` admite tanto el modo de servidor único como el modo de múltiples servidores:

- Servidor único: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Múltiples servidores: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opciones de selección de servidor en el lado del cliente:

- Proporcionar un servidor en los argumentos para fijarse a un Computador C.
- Proporcionar múltiples servidores para permitir el uso de alternativas en caso de fallo.
- Establecer `PREFERRED_SERVER=user@host` para elegir un servidor específico de la lista proporcionada.

Opciones de manejo de servidor ocupado en el Computador B:

- `REMOTE_BUSY_MARKER` (predeterminado: `.busy`): archivo marcador verificado en el lado remoto.
- `BUSY_RETRY_SECONDS` (predeterminado: `60`): tiempo de espera entre reintentos mientras el servidor está ocupado.
- `BUSY_MAX_RETRIES` (predeterminado: `10`): número máximo de intentos por servidor.

### Publicación del estado de ocupado desde el Computador C

`computer-c-write-to-tape.sh` crea un marcador de ocupado mientras escribe activamente archivos en la cinta y lo elimina cuando está inactivo.

- `BUSY_MARKER` (predeterminado: `<received_dir>/.busy`)

Apuntar `REMOTE_BUSY_MARKER` en el Computador B a la ubicación del marcador utilizada por el Computador C.

### Seguridad de la cinta y comportamiento de anexado en el Computador C

Antes de escribir cada archivo, `computer-c-write-to-tape.sh` verifica la capacidad disponible de la cinta/dispositivo y requiere al menos:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variables relevantes:

- `TAPE_SAFETY_MARGIN_BYTES` (predeterminado: `10485760`)
- `TAPE_AVAILABLE_BYTES` (anulación para espacio disponible conocido)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (permite la escritura si no se puede detectar el espacio)

Para dispositivos de cinta reales, el escritor busca el fin de datos (`mt eom`/`mt eod`) antes de escribir, de modo que los múltiples archivos se agregan en lugar de sobrescribir el contenido previo de la cinta.

### Marcas de tiempo legibles por humanos en los nombres de archivo

- Los registros por hora se nombran de la forma: `rsyslog-2026-06-01T1600.log`
- Los archivos diarios se nombran de la forma: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Los rangos de los archivos diarios se basan en los archivos horarios real primero y último incluidos en el archivo.
Estos nombres están pensados para ser legibles por personas que buscan ventanas de fecha/hora de eventos.
La hora actual se excluye intencionalmente de la creación de archivos para que las escrituras activas no se transmitan.

### Cifrado opcional con OpenSSL para archivos diarios

`computer-b-daily-archive.sh` puede cifrar los archivos con OpenSSL después de crear el tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` para cifrado simétrico (`openssl enc`, cifrado predeterminado `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` para cifrado con certificado de destinatario (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` para elegir el cifrado de OpenSSL tanto en el modo de archivo de clave como en el de certificado (predeterminado: `aes-256-gcm`).

Solo una de estas opciones puede estar activa a la vez. Las salidas cifradas usan `.tar.gz.enc`.
Por seguridad, el script rechaza opciones de cifrado débiles o que no sean AEAD y requiere cifrados de la clase GCM/poly1305.

### Recuperación de archivos desde la cinta en el Computador C

Usar `computer-c-restore-archive-from-tape.sh` para localizar un archivo específico buscando en los archivos de cinta en orden desde el principio:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Para nombres de archivo como `rsyslog-<start>_to_<end>.tar.gz` (o `.tar.gz.enc`), el script identifica la coincidencia correcta verificando que los archivos horarios de límite estén presentes en la carga útil recuperada.
- Si el nombre de su archivo es diferente, establezca `TARGET_MEMBER_GLOB` con un patrón de shell que coincida con un miembro que deba existir en el archivo.
- Si un archivo está cifrado, proporcione la configuración de descifrado según sea necesario:
  - `OPENSSL_DECRYPT_KEY_FILE` (modo simétrico `openssl enc`; cifrado de descifrado predeterminado: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` y `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (modo de descifrado S/MIME)

La salida recuperada se escribe como un archivo `.tar.gz` en texto plano para que pueda inspeccionarse con herramientas como `tar -tzf`.

### Inventario de tabla de contenidos de cinta en el Computador C

Usar `computer-c-inventory-tape.sh` para imprimir una tabla de contenidos marcador por marcador:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Las columnas de salida incluyen:

- `file_marker`: posición del marcador de archivo de cinta basada en cero
- `status`: `ok`, `decrypted` o `unreadable`
- `encrypted`: si fue necesario el descifrado para inspeccionar la entrada (`yes`/`no`)
- `archive_hint`: nombre en estilo de archivo inferido cuando se pueden reconocer los límites
- `first_member` / `last_member`: primer y último miembro tar vistos en ese marcador
- `member_count`: número de miembros tar encontrados en ese marcador
- `bytes`: bytes brutos leídos en ese marcador

Esto permite al operador identificar el índice de marcador al que desplazarse (`mt fsf <N>`) antes de las operaciones de restauración.

### Prueba de integración determinista A/B/C

Usar `scripts/test-computer-a-b-c-integration.sh` para validar la integración de extremo a extremo de los Computadores A, B y C independientemente del tiempo transcurrido:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Este script:

1. Simula la escritura de registros por parte de A.
2. Ejecuta la rotación de B y la creación del archivo diario.
3. Simula la transferencia hacia la entrada de C.
4. Ejecuta la recepción de C y la escritura en cinta.
5. Restaura el archivo desde la cinta y valida el contenido.

Utiliza una marca de día fija (`TEST_DAY_STAMP`, predeterminado `20260101`) para que el comportamiento sea repetible y no esté vinculado a la fecha/hora actual.

### Retención de 72 horas con seguridad para datos no confirmados

Los scripts ahora tienen por defecto una ventana de retención de 72 horas:

- `computer-b-hourly-rotate.sh` solo elimina registros horarios antiguos cuando existe un marcador de confirmación `.taped` local correspondiente.
- `computer-b-send-archives.sh` solo elimina archivos locales antiguos cuando existen tanto los marcadores de confirmación `.sent` como los `.taped` locales.
- `computer-c-write-to-tape.sh` solo elimina archivos antiguos que ya tienen marcadores `.taped`.

Como resultado, los archivos que aún no se han transmitido y grabado correctamente en cinta se conservan incluso cuando son más antiguos que `RETENTION_HOURS` (predeterminado `72`).
En el Computador B, la limpieza local requiere marcadores `.taped` locales (por ejemplo, de un paso de sincronización de vuelta o un proceso de confirmación manual).
En el Computador C, la antigüedad de retención se mide desde el tiempo de modificación del marcador `.taped` (normalmente establecido en el momento de la escritura exitosa en cinta).

## Diagramas de la canalización

- [Diagramas Mermaid de secuencia y estados A/B/C](pipeline-diagrams/README.es.md)
