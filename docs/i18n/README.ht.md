# FreeBSDOpenBSDTapeOps (Kreyòl Ayisyen)

Script shell entèaktif ki gide atravè operasyon kasèt mayetik ki komen ak `mt` ak `tar`.

## Endèks Dokimantasyon Lang

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


## Script yo

| Script | Sistèm sib |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Tou de script yo fè menm sekans operasyon yo:

1. Mande itilizatè a konfime kasèt la chaje.
2. Remete kasèt la nan kòmansman.
3. Afiche estati kasèt la.
4. Lis sa ki nan achiv yo nan pozisyon fichye 0, 1, 2, ak 3 avèk `tar t`.
5. Mete kasèt la offline.

Chak etap pran poz epi tann itilizatè a peze **Enter** anvan li kontinye, sa ki fè script yo apwopriye pou demonstrasyon entèaktif oswa gid etap pa etap.

## Diferans Ant De Script Yo

### 1. Chemen aparèy kasèt

Script yo vize diferan nœud aparèy kasèt:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Tou de se nœud aparèy ki pa remete kasèt la nan kòmansman otomatikman (prefiks `n`), kidonk pozisyon kasèt la konsève ant kòmandman yo epi script yo kontwole pozisyon an klèman ak `mt rewind` ak `mt fsf`.

### 2. Etap chajman kasèt la

- **FreeBSD**: Li lanse `mt -f /dev/nsa0 load` lè li kòmanse pou chaje katouch kasèt la mekanikman nan drive la anvan li remete li nan kòmansman.
- **OpenBSD**: Li sote kòmand `load` la paske `mt(1)` OpenBSD a pa sipòte yon sou-kòmand `load`. Script OpenBSD la sipoze kasèt la deja nan drive la epi li ale dirèkteman nan remete li nan kòmansman.

## Script Pipeline Jounal OpenBSD soti A pou rive B pou rive C

Repètwa `scripts/` la bay script pou senaryo kote Odinatè B OpenBSD a resevwa antre rsyslog soti nan Odinatè A, rasanble yo chak jou, voye yo bay youn nan plizyè sèvè Odinatè C, epi Odinatè C ekri yo sou kasèt.

| Script | Objektif |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Kreye yon log ki vire chak èdtan apati fichye antre rsyslog aktif la sou Odinatè B. |
| `scripts/computer-b-daily-archive.sh` | Rasanble yon jou (`YYYYMMDD`) log pa èdtan yo nan yon achiv `.tar.gz` ki gen entèval tan sou Odinatè B, pandan li retire èdtan aktyèl la pou evite konfli ekriti aktif. |
| `scripts/computer-b-send-archives.sh` | Voye achiv chak jou ki poko voye yo (`.tar.gz` ak opsyonèl `.tar.gz.enc`) soti nan Odinatè B ale nan youn oswa plizyè sèvè Odinatè C atravè `scp`. |
| `scripts/computer-c-receive-archives.sh` | Verifye achiv tèks klè k ap antre yo epi mete achiv tèks klè oswa chiffres yo nan keu pou kasèt. |
| `scripts/computer-c-write-to-tape.sh` | Ekri achiv tèks klè oswa chiffres ki nan keu yo sou kasèt, verifye espas, ajoute yo san danje nan fen an, epi make yo kòm anrejistre. |
| `scripts/computer-c-inventory-tape.sh` | Afiche yon table-of-contents kasèt la pa makè fichye pou operatè yo ka jwenn achiv yo byen vit. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Eskane pozisyon fichye yo sou kasèt la pou achiv yo mande a, dekripte lè sa nesesè, epi sove done yo rekipere yo nan yon fichye. |
| `scripts/test-computer-a-b-c-integration.sh` | Kouri yon tès entegrasyon lokal A→B→C ki detèminis (ki gen ladan restorasyon kasèt) ki pa depann de tan reyèl la. |

Orè tipik:

- Kouri `computer-b-hourly-rotate.sh` chak èdtan (cron sou B).
- Kouri `computer-b-daily-archive.sh` yon fwa pa jou (cron sou B).
- Kouri `computer-b-send-archives.sh` apre kreyasyon achiv la (cron sou B).
- Kouri `computer-c-receive-archives.sh` detanzantan sou C.
- Kouri `computer-c-write-to-tape.sh` detanzantan sou C ak bon aparèy kasèt la.
- Kouri `computer-c-inventory-tape.sh` sou C lè ou bezwen yon table-of-contents makè pa makè.
- Kouri `computer-c-restore-archive-from-tape.sh` sou C lè ou bezwen rekipere yon achiv espesifik pou enspeksyon.

Tout script pipeline yo tou voye mesaj operasyonèl nan syslog atravè `logger` (pa egzanp, vizib atravè rsyslog/journaling) anplis pwodiksyon konsòl la.

### Voye sou plizyè sèvè depi Odinatè B

`computer-b-send-archives.sh` sipòte ni mòd yon sèl sèvè ni mòd plizyè sèvè:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Opsyon chwa sèvè bò kliyan an:

- Bay yon sèl sèvè nan agiman yo pou fikse sou yon sèl Odinatè C.
- Bay plizyè sèvè pou pèmèt fallback.
- Mete `PREFERRED_SERVER=user@host` pou chwazi yon sèl sèvè espesifik nan lis yo bay la.

Opsyon pou jere eta busy sou Odinatè B:

- `REMOTE_BUSY_MARKER` (default: `.busy`): fichye makè yo verifye sou bò a distans.
- `BUSY_RETRY_SECONDS` (default: `60`): tan pou tann ant tantativ yo pandan sèvè a busy.
- `BUSY_MAX_RETRIES` (default: `10`): kantite maksimòm tantativ pa sèvè.

### Piblikasyon eta busy soti nan Odinatè C

`computer-c-write-to-tape.sh` kreye yon makè busy pandan li ap ekri achiv yo sou kasèt la aktivman epi li retire li lè li pa okipe.

- `BUSY_MARKER` (default: `<received_dir>/.busy`)

Fè `REMOTE_BUSY_MARKER` sou Odinatè B montre kote makè Odinatè C ap itilize a.

### Sekirite kasèt ak konpòtman ajoute nan fen sou Odinatè C

Anvan li ekri chak achiv, `computer-c-write-to-tape.sh` verifye kapasite kasèt oswa aparèy ki disponib epi li mande omwen:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Varyab ki enpòtan yo:

- `TAPE_SAFETY_MARGIN_BYTES` (default: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override pou espas disponib ki deja konnen)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (pèmèt ekriti si yo pa ka detekte espas la)

Pou aparèy kasèt reyèl yo, ekriven an chèche nan fen done yo (`mt eom`/`mt eod`) anvan li ekri, konsa plizyè achiv ajoute youn apre lòt olye yo efase sa ki te deja sou kasèt la.

### Dat/èdtan moun ka li nan non fichye yo

- Log pa èdtan yo gen non tankou: `rsyslog-2026-06-01T1600.log`
- Achiv chak jou yo gen non tankou: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Entèval achiv chak jou yo baze sou premye ak dènye fichye pa èdtan ki vrèman enkli nan achiv la.
Yo chwazi non sa yo pou moun ki ap gade fenèt dat oswa lè evènman yo ka li yo fasil.
Yo retire èdtan aktyèl la espre nan kreyasyon achiv la pou ekriti aktif yo pa transmèt.

### Chifreman OpenSSL opsyonèl pou achiv chak jou yo

`computer-b-daily-archive.sh` ka chiffre achiv yo ak OpenSSL apre li fin kreye tarball la:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` pou chifreman simetrik (`openssl enc`, cipher default la `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` pou chifreman ak sètifika moun k ap resevwa a (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` pou chwazi cipher OpenSSL la pou mòd key-file ak sètifika yo toude (default: `aes-256-gcm`).

Se yon sèl nan opsyon sa yo sèlman ki ka defini an menm tan. Sòti chiffres yo sèvi ak `.tar.gz.enc`.
Pou sekirite, script la rejte chwa cipher ki fèb oswa ki pa AEAD, epi li mande cipher nan klas GCM/poly1305.

### Rekiperasyon achiv soti sou kasèt nan Odinatè C

Sèvi ak `computer-c-restore-archive-from-tape.sh` pou jwenn yon achiv espesifik lè w ap chèche fichye kasèt yo an lòd depi nan kòmansman:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Pou non achiv tankou `rsyslog-<start>_to_<end>.tar.gz` (oswa `.tar.gz.enc`), script la idantifye bon korespondans lan lè li verifye fichye pa èdtan bò limit yo prezan nan chaj ki rekipere a.
- Si fason ou nonmen achiv yo diferan, mete `TARGET_MEMBER_GLOB` sou yon modèl shell ki koresponn ak yon manm ki dwe egziste nan achiv la.
- Si yon achiv chiffre, bay paramèt dechifreman yo jan sa nesesè:
  - `OPENSSL_DECRYPT_KEY_FILE` (mòd simetrik `openssl enc`; cipher dechifreman default la: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` ak `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mòd dechifreman S/MIME)

Sòti rekipere a ekri kòm yon fichye `.tar.gz` tèks klè pou yo ka enspekte li ak zouti tankou `tar -tzf`.

### Envantè table-of-contents kasèt la sou Odinatè C

Sèvi ak `computer-c-inventory-tape.sh` pou enprime yon table-of-contents makè pa makè:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Kolòn pwodiksyon yo genyen ladan yo:

- `file_marker`: pozisyon makè fichye sou kasèt la ki kòmanse nan zewo
- `status`: `ok`, `decrypted`, oswa `unreadable`
- `encrypted`: si dechifreman te nesesè pou enspekte antre a (`yes`/`no`)
- `archive_hint`: non tip achiv yo dedwi lè yo ka rekonèt limit yo
- `first_member` / `last_member`: premye ak dènye manm tar yo wè nan makè sa a
- `member_count`: kantite manm tar yo jwenn nan makè sa a
- `bytes`: bytes brit yo li nan makè sa a

Sa pèmèt yon operatè idantifye endèks makè pou chèche a (`mt fsf <N>`) anvan operasyon restorasyon yo.

### Tès entegrasyon A/B/C detèminis

Sèvi ak `scripts/test-computer-a-b-c-integration.sh` pou valide entegrasyon bout-an-bout Odinatè A, B, ak C kèlkeswa tan ki pase:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Script sa a:

1. Simile A ap ekri log yo.
2. Kouri wotasyon B a ak kreyasyon achiv chak jou a.
3. Simile transfè a nan incoming C a.
4. Kouri resepsyon C a ansanm ak ekriti sou kasèt.
5. Restore achiv la soti sou kasèt epi valide kontni an.

Li sèvi ak yon make jou fiks (`TEST_DAY_STAMP`, default `20260101`) pou konpòtman an repwodiktib epi li pa mare ak dat oswa lè aktyèl la.

### Konsèvasyon 72 èdtan ak sekirite pou done ki poko konfime

Kounye a, script yo itilize yon fenèt konsèvasyon 72 èdtan pa default:

- `computer-b-hourly-rotate.sh` sèlman retire ansyen log pa èdtan yo lè gen yon makè konfimasyon lokal `.taped` ki koresponn.
- `computer-b-send-archives.sh` sèlman retire ansyen achiv lokal yo lè gen tou de makè konfimasyon `.sent` ak `.taped` lokal.
- `computer-c-write-to-tape.sh` sèlman retire ansyen achiv ki deja gen makè `.taped`.

Kòm rezilta, fichye ki poko transmèt ak anrejistre avèk siksè sou kasèt la rete konsève menm lè yo pi ansyen pase `RETENTION_HOURS` (default `72`).
Sou Odinatè B, netwayaj lokal la mande makè `.taped` lokal yo (pa egzanp soti nan yon etap sync-back oswa yon pwosesis konfimasyon manyèl).
Sou Odinatè C, laj konsèvasyon an mezire apati tan modifikasyon makè `.taped` la (anjeneral yo mete li lè ekriti kasèt la reyisi).

## Dyagram Pipeline

- [Dyagram Mermaid sekans ak eta A/B/C](pipeline-diagrams/README.ht.md)
