# FreeBSDOpenBSDTapeOps (Deutsch)

Interaktive Shell-Skripte, die gängige Magnetband-Operationen mit `mt` und `tar` Schritt für Schritt demonstrieren.

## Sprachdokumentationsindex

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


## Skripte

| Skript | Zielbetriebssystem |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Beide Skripte führen dieselbe Abfolge von Operationen aus:

1. Benutzer auffordern zu bestätigen, dass das Band eingelegt ist.
2. Band zurückspulen.
3. Bandstatus ausgeben.
4. Inhalte der Archive an Dateiposition 0, 1, 2 und 3 mit `tar t` auflisten.
5. Band offline nehmen.

Jeder Schritt pausiert und wartet auf **Enter**, bevor fortgefahren wird. Dadurch eignen sich die Skripte als interaktive Demonstrationen oder geführte Durchläufe.

## Unterschiede zwischen den beiden Skripten

### 1. Pfad des Bandgeräts

Die Skripte verwenden unterschiedliche Bandgeräte-Knoten:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Beide sind nicht zurückspulende Gerätedateien (Präfix `n`), daher bleibt die Bandposition zwischen Befehlen erhalten, und die Skripte steuern die Positionierung explizit mit `mt rewind` und `mt fsf`.

### 2. Schritt zum Laden des Bands

- **FreeBSD**: Führt beim Start `mt -f /dev/nsa0 load` aus, um die Bandkassette mechanisch ins Laufwerk zu laden, bevor zurückgespult wird.
- **OpenBSD**: Überspringt den `load`-Befehl, weil `mt(1)` unter OpenBSD kein `load`-Unterkommando unterstützt. Das OpenBSD-Skript geht davon aus, dass das Band bereits im Laufwerk ist, und spult direkt zurück.

## OpenBSD-A-zu-B-zu-C-Log-Pipeline-Skripte

Das Verzeichnis `scripts/` enthält Skripte für das Szenario, in dem OpenBSD-Computer B rsyslog-Einträge von Computer A empfängt, sie täglich bündelt, an einen von mehreren Computer-C-Servern sendet und Computer C sie auf Band schreibt.

| Skript | Zweck |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Erstellt auf Computer B eine stündlich rotierte Logdatei aus der aktiven rsyslog-Eingabedatei. |
| `scripts/computer-b-daily-archive.sh` | Packt auf Computer B einen Tag (`YYYYMMDD`) stündlicher Logs in ein zeitbereichsbasiertes `.tar.gz`-Archiv und schließt die aktuelle Stunde aus, um Konflikte mit aktiven Schreibvorgängen zu vermeiden. |
| `scripts/computer-b-send-archives.sh` | Sendet ungesendete Tagesarchive (`.tar.gz` und optional `.tar.gz.enc`) von Computer B über `scp` an einen oder mehrere Computer-C-Server. |
| `scripts/computer-c-receive-archives.sh` | Validiert eingehende unverschlüsselte Archive und stellt unverschlüsselte/verschlüsselte Archive für Band bereit. |
| `scripts/computer-c-write-to-tape.sh` | Schreibt wartende unverschlüsselte oder verschlüsselte Archive auf Band, prüft freien Platz, hängt sicher an und markiert sie als aufgezeichnet. |
| `scripts/computer-c-inventory-tape.sh` | Gibt ein Band-Inhaltsverzeichnis nach Dateimarkierung aus, damit Operatoren Archive schnell finden können. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Durchsucht Banddateipositionen nach einem angeforderten Archiv, entschlüsselt bei Bedarf und speichert die wiederhergestellten Daten in einer Datei. |
| `scripts/test-computer-a-b-c-integration.sh` | Führt einen deterministischen lokalen A→B→C-Integrationstest (einschließlich Bandwiederherstellung) aus, der nicht von Echtzeit abhängt. |

Typische Planung:

- Führen Sie `computer-b-hourly-rotate.sh` stündlich aus (Cron auf B).
- Führen Sie `computer-b-daily-archive.sh` einmal täglich aus (Cron auf B).
- Führen Sie `computer-b-send-archives.sh` nach der Archiverstellung aus (Cron auf B).
- Führen Sie `computer-c-receive-archives.sh` regelmäßig auf C aus.
- Führen Sie `computer-c-write-to-tape.sh` regelmäßig auf C mit dem korrekten Bandgerät aus.
- Führen Sie `computer-c-inventory-tape.sh` auf C aus, wenn Sie ein Inhaltsverzeichnis nach Markierungen benötigen.
- Führen Sie `computer-c-restore-archive-from-tape.sh` auf C aus, wenn Sie ein bestimmtes Archiv zur Prüfung wiederherstellen müssen.

Alle Pipeline-Skripte senden zusätzlich zu Konsolenausgaben auch Betriebsnachrichten über `logger` an Syslog (z. B. sichtbar über rsyslog/Journaling).

### Versand an mehrere Server von Computer B

`computer-b-send-archives.sh` unterstützt sowohl Einzelserver- als auch Mehrservermodus:

- Einzelserver: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Mehrserver: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Optionen zur Serverauswahl auf Client-Seite:

- Geben Sie einen Server in den Argumenten an, um auf einen Computer C festzulegen.
- Geben Sie mehrere Server an, um Fallback zu ermöglichen.
- Setzen Sie `PREFERRED_SERVER=user@host`, um einen bestimmten Server aus der bereitgestellten Liste auszuwählen.

Optionen zur Behandlung von Belegt-Zuständen auf Computer B:

- `REMOTE_BUSY_MARKER` (Standard: `.busy`): Markerdatei, die auf der Gegenseite geprüft wird.
- `BUSY_RETRY_SECONDS` (Standard: `60`): Wartezeit zwischen Wiederholungen, solange der Server belegt ist.
- `BUSY_MAX_RETRIES` (Standard: `10`): Maximale Anzahl Wiederholungsversuche pro Server.

### Veröffentlichung des Belegt-Status auf Computer C

`computer-c-write-to-tape.sh` erstellt eine Belegt-Markierung, während aktiv Archive auf Band geschrieben werden, und entfernt sie im Leerlauf.

- `BUSY_MARKER` (Standard: `<received_dir>/.busy`)

Richten Sie `REMOTE_BUSY_MARKER` auf Computer B auf den Markerpfad aus, den Computer C verwendet.

### Bandsicherheit und Anhängeverhalten auf Computer C

Vor dem Schreiben jedes Archivs prüft `computer-c-write-to-tape.sh`, ob genügend Band-/Gerätekapazität verfügbar ist, und erfordert mindestens:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Relevante Variablen:

- `TAPE_SAFETY_MARGIN_BYTES` (Standard: `10485760`)
- `TAPE_AVAILABLE_BYTES` (Überschreibung für bekannten verfügbaren Platz)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (erlaubt Schreiben, wenn freier Platz nicht ermittelt werden kann)

Bei echten Bandgeräten fährt der Schreiber vor dem Schreiben an das Datenende (`mt eom`/`mt eod`), sodass mehrere Archive angehängt statt vorhandene Bandinhalte überschrieben werden.

### Lesbare Zeitstempel in Dateinamen

- Stündliche Logs heißen z. B.: `rsyslog-2026-06-01T1600.log`
- Tagesarchive heißen z. B.: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Die Tagesarchiv-Zeitbereiche basieren auf den tatsächlich ersten und letzten stündlichen Dateien, die in das Archiv aufgenommen wurden.
Diese Namen sollen für Menschen lesbar sein, die nach Ereignis-Datums-/Zeitfenstern suchen.
Die aktuelle Stunde wird bei der Archiverstellung absichtlich ausgeschlossen, damit aktive Schreibvorgänge nicht übertragen werden.

### Optionale OpenSSL-Verschlüsselung für Tagesarchive

`computer-b-daily-archive.sh` kann Archive nach dem Erstellen des Tarballs mit OpenSSL verschlüsseln:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` für symmetrische Verschlüsselung (`openssl enc`, Standard-Chiffre `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` für Verschlüsselung mit Empfängerzertifikat (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` zur Auswahl der OpenSSL-Chiffre für Schlüsseldatei- und Zertifikatsmodus (Standard: `aes-256-gcm`).

Es darf immer nur eine dieser Optionen gleichzeitig gesetzt sein. Verschlüsselte Ausgaben verwenden `.tar.gz.enc`.
Aus Sicherheitsgründen lehnt das Skript schwache oder nicht-AEAD-Chiffren ab und verlangt Chiffren der GCM-/poly1305-Klasse.

### Archivwiederherstellung von Band auf Computer C

Verwenden Sie `computer-c-restore-archive-from-tape.sh`, um ein bestimmtes Archiv zu finden, indem Banddateien vom Anfang an der Reihe nach durchsucht werden:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Bei Archivnamen wie `rsyslog-<start>_to_<end>.tar.gz` (oder `.tar.gz.enc`) identifiziert das Skript den korrekten Treffer, indem geprüft wird, ob die stündlichen Grenzdateien in den wiederhergestellten Nutzdaten vorhanden sind.
- Wenn Ihr Archivname anders aufgebaut ist, setzen Sie `TARGET_MEMBER_GLOB` auf ein Shell-Muster, das auf ein Mitglied passt, das im Archiv vorhanden sein muss.
- Wenn ein Archiv verschlüsselt ist, geben Sie bei Bedarf Entschlüsselungseinstellungen an:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetrischer `openssl enc`-Modus; Standard-Entschlüsselungschiffre: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` und `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-Entschlüsselungsmodus)

Die wiederhergestellte Ausgabe wird als unverschlüsselte `.tar.gz`-Datei geschrieben, sodass sie mit Tools wie `tar -tzf` geprüft werden kann.

### Band-Inhaltsverzeichnis auf Computer C

Verwenden Sie `computer-c-inventory-tape.sh`, um ein Inhaltsverzeichnis Markierung für Markierung auszugeben:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Die Ausgabespalten umfassen:

- `file_marker`: nullbasierte Position der Band-Dateimarkierung
- `status`: `ok`, `decrypted` oder `unreadable`
- `encrypted`: ob zur Prüfung des Eintrags entschlüsselt werden musste (`yes`/`no`)
- `archive_hint`: abgeleiteter Archivname-Stil, wenn Grenzen erkannt werden können
- `first_member` / `last_member`: erstes und letztes Tar-Mitglied in dieser Markierung
- `member_count`: Anzahl der in dieser Markierung gefundenen Tar-Mitglieder
- `bytes`: rohe Bytezahl, die an dieser Markierung gelesen wurde

Dadurch kann ein Operator den Marker-Index bestimmen, zu dem vor Wiederherstellungen gesprungen werden soll (`mt fsf <N>`).

### Deterministischer A/B/C-Integrationstest

Verwenden Sie `scripts/test-computer-a-b-c-integration.sh`, um die Ende-zu-Ende-Integration von Computer A, B und C unabhängig von verstrichener Zeit zu validieren:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Dieses Skript:

1. Simuliert, dass A Logs schreibt.
2. Führt Rotation und Tagesarchiverstellung auf B aus.
3. Simuliert die Übertragung in den Eingangsordner von C.
4. Führt Empfang + Schreiben-auf-Band auf C aus.
5. Stellt das Archiv vom Band wieder her und validiert den Inhalt.

Es verwendet einen festen Tagesstempel (`TEST_DAY_STAMP`, Standard `20260101`), sodass das Verhalten reproduzierbar ist und nicht an aktuelles Datum/Uhrzeit gebunden ist.

### 72-Stunden-Aufbewahrung mit Sicherheit für unbestätigte Daten

Die Skripte verwenden jetzt standardmäßig ein 72-Stunden-Aufbewahrungsfenster:

- `computer-b-hourly-rotate.sh` entfernt alte stündliche Logs nur, wenn ein passender lokaler `.taped`-Bestätigungsmarker existiert.
- `computer-b-send-archives.sh` entfernt alte lokale Archive nur, wenn sowohl `.sent`- als auch lokaler `.taped`-Bestätigungsmarker existieren.
- `computer-c-write-to-tape.sh` entfernt nur alte Archive, die bereits `.taped`-Marker haben.

Dadurch bleiben Dateien, die noch nicht erfolgreich übertragen und auf Band aufgezeichnet wurden, erhalten, selbst wenn sie älter als `RETENTION_HOURS` (Standard `72`) sind.
Auf Computer B erfordert das lokale Aufräumen lokale `.taped`-Marker (zum Beispiel durch einen Rücksynchronisationsschritt oder einen manuellen Bestätigungsprozess).
Auf Computer C wird das Aufbewahrungsalter anhand der Änderungszeit des `.taped`-Markers gemessen (normalerweise auf den Zeitpunkt des erfolgreichen Schreibens auf Band gesetzt).

## Pipeline-Diagramme

- [A/B/C-Mermaid-Sequenz- und Zustandsdiagramme](pipeline-diagrams/README.de.md)
