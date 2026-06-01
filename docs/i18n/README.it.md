# FreeBSDOpenBSDTapeOps (Italiano)

Script shell interattivi che illustrano le comuni operazioni su nastro magnetico usando `mt` e `tar`.

## Indice della documentazione per lingua

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


## Script

| Script | Sistema operativo di destinazione |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Entrambi gli script eseguono la stessa sequenza di operazioni:

1. Chiedere all’utente di confermare che il nastro è caricato.
2. Riavvolgere il nastro.
3. Stampare lo stato del nastro.
4. Elencare il contenuto degli archivi alle posizioni file 0, 1, 2 e 3 usando `tar t`.
5. Mettere il nastro offline.

Ogni passaggio mette in pausa ed attende che l’utente prema **Invio** prima di continuare, rendendo gli script adatti come dimostrazioni interattive o guide passo passo.

## Differenze tra i due script

### 1. Percorso del dispositivo nastro

Gli script usano nodi di dispositivo nastro differenti:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Entrambi sono nodi di dispositivo non-rewinding (prefisso `n`), quindi la posizione del nastro viene mantenuta tra i comandi e gli script controllano il posizionamento in modo esplicito con `mt rewind` e `mt fsf`.

### 2. Fase di caricamento del nastro

- **FreeBSD**: Esegue `mt -f /dev/nsa0 load` all’avvio per caricare meccanicamente la cartuccia del nastro nell’unità prima del riavvolgimento.
- **OpenBSD**: Salta il comando `load` perché `mt(1)` su OpenBSD non supporta un sottocomando `load`. Lo script OpenBSD presume che il nastro sia già presente nell’unità e procede direttamente al riavvolgimento.

## Script della pipeline di log OpenBSD da A a B a C

La directory `scripts/` fornisce script per lo scenario in cui il Computer B OpenBSD riceve voci rsyslog dal Computer A, le raggruppa giornalmente, le invia a uno dei vari server Computer C e il Computer C le scrive su nastro.

| Script | Scopo |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Crea un log ruotato ogni ora dal file di input rsyslog attivo sul Computer B. |
| `scripts/computer-b-daily-archive.sh` | Raggruppa un giorno (`YYYYMMDD`) di log orari in un archivio `.tar.gz` con intervallo temporale sul Computer B, escludendo l’ora corrente per evitare conflitti di scrittura attiva. |
| `scripts/computer-b-send-archives.sh` | Invia archivi giornalieri non inviati (`.tar.gz` e opzionalmente `.tar.gz.enc`) dal Computer B a uno o più server Computer C tramite `scp`. |
| `scripts/computer-c-receive-archives.sh` | Valida archivi in chiaro in arrivo e mette in coda archivi in chiaro/cifrati per il nastro. |
| `scripts/computer-c-write-to-tape.sh` | Scrive su nastro archivi in coda in chiaro o cifrati, verifica lo spazio, aggiunge in sicurezza e li contrassegna come registrati. |
| `scripts/computer-c-inventory-tape.sh` | Stampa un indice del contenuto del nastro per marcatore file, così gli operatori possono individuare rapidamente gli archivi. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Scansiona le posizioni file del nastro per un archivio richiesto, decifra quando necessario e salva i dati recuperati in un file. |
| `scripts/test-computer-a-b-c-integration.sh` | Esegue un test di integrazione locale deterministico A→B→C (incluso il ripristino da nastro) che non dipende dal tempo reale. |

Pianificazione tipica:

- Eseguire `computer-b-hourly-rotate.sh` ogni ora (cron su B).
- Eseguire `computer-b-daily-archive.sh` una volta al giorno (cron su B).
- Eseguire `computer-b-send-archives.sh` dopo la creazione dell’archivio (cron su B).
- Eseguire `computer-c-receive-archives.sh` periodicamente su C.
- Eseguire `computer-c-write-to-tape.sh` periodicamente su C con il dispositivo nastro corretto.
- Eseguire `computer-c-inventory-tape.sh` su C quando serve un indice marcatore per marcatore.
- Eseguire `computer-c-restore-archive-from-tape.sh` su C quando serve recuperare un archivio specifico per ispezione.

Tutti gli script della pipeline emettono anche messaggi operativi verso syslog tramite `logger` (ad esempio visibili tramite rsyslog/journaling) oltre all’output su console.

### Invio multi-server dal Computer B

`computer-b-send-archives.sh` supporta sia la modalità server singolo sia la modalità multi-server:

- Server singolo: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opzioni di selezione server lato client:

- Fornire un server negli argomenti per fissarsi a un solo Computer C.
- Fornire più server per consentire il failover.
- Impostare `PREFERRED_SERVER=user@host` per scegliere un server specifico dall’elenco fornito.

Opzioni di gestione stato occupato sul Computer B:

- `REMOTE_BUSY_MARKER` (predefinito: `.busy`): file marcatore controllato sul lato remoto.
- `BUSY_RETRY_SECONDS` (predefinito: `60`): tempo di attesa tra i tentativi mentre il server è occupato.
- `BUSY_MAX_RETRIES` (predefinito: `10`): massimo tentativi per server.

### Pubblicazione dello stato occupato dal Computer C

`computer-c-write-to-tape.sh` crea un marcatore di occupato mentre scrive attivamente archivi su nastro e lo rimuove quando inattivo.

- `BUSY_MARKER` (predefinito: `<received_dir>/.busy`)

Puntare `REMOTE_BUSY_MARKER` sul Computer B alla posizione del marcatore usata dal Computer C.

### Sicurezza nastro e comportamento di append sul Computer C

Prima di scrivere ogni archivio, `computer-c-write-to-tape.sh` controlla la capacità disponibile di nastro/dispositivo e richiede almeno:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Variabili rilevanti:

- `TAPE_SAFETY_MARGIN_BYTES` (predefinito: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override per spazio disponibile noto)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (consente la scrittura se lo spazio non può essere rilevato)

Per dispositivi nastro reali, il processo di scrittura cerca la fine dei dati (`mt eom`/`mt eod`) prima di scrivere, quindi più archivi vengono aggiunti invece di sovrascrivere il contenuto precedente del nastro.

### Timestamp leggibili nei nomi file

- I log orari sono nominati così: `rsyslog-2026-06-01T1600.log`
- Gli archivi giornalieri sono nominati così: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Gli intervalli degli archivi giornalieri si basano sui primi e ultimi file orari effettivamente inclusi nell’archivio.
Questi nomi sono pensati per essere leggibili da persone che cercano finestre data/ora di eventi.
L’ora corrente è intenzionalmente esclusa dalla creazione dell’archivio così che scritture attive non vengano trasmesse.

### Cifratura OpenSSL opzionale per archivi giornalieri

`computer-b-daily-archive.sh` può cifrare gli archivi con OpenSSL dopo aver creato il tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` per cifratura simmetrica (`openssl enc`, cifra predefinita `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` per cifratura con certificato destinatario (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` per scegliere la cifra OpenSSL sia per modalità file chiave sia certificato (predefinito: `aes-256-gcm`).

Solo una di queste opzioni può essere impostata alla volta. Gli output cifrati usano `.tar.gz.enc`.
Per sicurezza, lo script rifiuta scelte di cifratura deboli o non-AEAD e richiede cifre di classe GCM/poly1305.

### Recupero archivi da nastro sul Computer C

Usa `computer-c-restore-archive-from-tape.sh` per individuare un archivio specifico cercando i file del nastro in ordine dall’inizio:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Per nomi archivio come `rsyslog-<start>_to_<end>.tar.gz` (o `.tar.gz.enc`), lo script identifica la corrispondenza corretta verificando che i file orari di confine siano presenti nel payload recuperato.
- Se la convenzione di naming archivio è diversa, imposta `TARGET_MEMBER_GLOB` su un pattern shell che corrisponda a un membro che deve esistere nell’archivio.
- Se un archivio è cifrato, fornire le impostazioni di decifratura necessarie:
  - `OPENSSL_DECRYPT_KEY_FILE` (modalità simmetrica `openssl enc`; cifra di decifratura predefinita: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` e `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (modalità decifratura S/MIME)

L’output recuperato viene scritto come file `.tar.gz` in chiaro così può essere ispezionato con strumenti come `tar -tzf`.

### Inventario dell’indice nastro sul Computer C

Usa `computer-c-inventory-tape.sh` per stampare un indice marcatore per marcatore:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Le colonne di output includono:

- `file_marker`: posizione del marcatore file sul nastro con indice base zero
- `status`: `ok`, `decrypted` oppure `unreadable`
- `encrypted`: se è stata necessaria decifratura per ispezionare la voce (`yes`/`no`)
- `archive_hint`: nome in stile archivio dedotto quando i confini possono essere riconosciuti
- `first_member` / `last_member`: primo e ultimo membro tar visti in quel marcatore
- `member_count`: numero di membri tar trovati in quel marcatore
- `bytes`: byte grezzi letti in quel marcatore

Questo consente a un operatore di identificare l’indice marcatore da raggiungere (`mt fsf <N>`) prima delle operazioni di ripristino.

### Test di integrazione deterministico A/B/C

Usa `scripts/test-computer-a-b-c-integration.sh` per validare l’integrazione end-to-end dei Computer A, B e C indipendentemente dal tempo trascorso:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Questo script:

1. Simula A che scrive log.
2. Esegue rotazione B e creazione archivio giornaliero.
3. Simula trasferimento nella cartella di ingresso di C.
4. Esegue ricezione C + scrittura su nastro.
5. Ripristina l’archivio da nastro e valida il contenuto.

Usa un timbro giorno fisso (`TEST_DAY_STAMP`, predefinito `20260101`) così il comportamento è ripetibile e non legato a data/ora correnti.

### Conservazione di 72 ore con sicurezza per dati non confermati

Gli script ora usano per impostazione predefinita una finestra di conservazione di 72 ore:

- `computer-b-hourly-rotate.sh` rimuove vecchi log orari solo quando esiste un marcatore di conferma `.taped` locale corrispondente.
- `computer-b-send-archives.sh` rimuove vecchi archivi locali solo quando esistono sia `.sent` sia un marcatore di conferma `.taped` locale.
- `computer-c-write-to-tape.sh` rimuove solo vecchi archivi che hanno già marcatori `.taped`.

Di conseguenza, i file non ancora trasmessi con successo e registrati su nastro vengono mantenuti anche se più vecchi di `RETENTION_HOURS` (predefinito `72`).
Sul Computer B, la pulizia locale richiede marcatori `.taped` locali (ad esempio da una fase di sincronizzazione di ritorno o un processo manuale di conferma).
Sul Computer C, l’età di conservazione viene misurata dall’orario di modifica del marcatore `.taped` (normalmente impostato all’ora di scrittura su nastro riuscita).
