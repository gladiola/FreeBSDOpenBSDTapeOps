# FreeBSDOpenBSDTapeOps (Eesti)

Interaktiivsed shelliskriptid, mis juhendavad läbi levinud magnetlindi toimingute, kasutades `mt`-d ja `tar`-i.

## Keeledokumentatsiooni register

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


## Skriptid

| Script | Siht-OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Mõlemad skriptid teevad sama toimingute jada:

1. Palu kasutajal kinnitada, et lint on laaditud.
2. Keri lint tagasi algusesse.
3. Prindi lindi olek.
4. Loetle failiasukohtadel 0, 1, 2 ja 3 olevate arhiivide sisu, kasutades `tar t`.
5. Vii lint offline-olekusse.

Iga samm peatub ja ootab, kuni kasutaja vajutab jätkamiseks **Enter**, mistõttu sobivad skriptid interaktiivseteks demonstratsioonideks või juhendatud läbitusteks.

## Kahe skripti erinevused

### 1. Lindiseadme tee

Skriptid kasutavad erinevaid lindiseadme sõlmi:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Mõlemad on mitte-tagasikerivad seadmesõlmed (`n`-eesliide), seega säilib lindi asukoht käskude vahel ning skriptid juhivad positsioneerimist otseselt käskudega `mt rewind` ja `mt fsf`.

### 2. Lindi laadimise samm

- **FreeBSD**: Käivitab alguses `mt -f /dev/nsa0 load`, et laadida lindikassett mehaaniliselt seadmesse enne tagasikerimist.
- **OpenBSD**: Jätab käsu `load` vahele, sest OpenBSD `mt(1)` ei toeta `load`-alamkäsku. OpenBSD skript eeldab, et lint on juba seadmes olemas, ja jätkab kohe tagasikerimisega.

## OpenBSD A-st B-sse ja C-sse logitorustiku skriptid

Kataloog `scripts/` sisaldab skripte stsenaariumi jaoks, kus OpenBSD Computer B võtab vastu Computer A rsyslogi kirjeid, koondab need päevade kaupa, saadab need ühele mitmest Computer C serverist ja Computer C kirjutab need lindile.

| Script | Eesmärk |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Loob Computer B aktiivsest rsyslogi sisendfailist tunnipõhiselt roteeritud logi. |
| `scripts/computer-b-daily-archive.sh` | Koondab ühe päeva (`YYYYMMDD`) tunnilogid Computer B-s ajavahemikuga `.tar.gz` arhiiviks, jättes praeguse tunni välja, et vältida konflikte aktiivsete kirjutustega. |
| `scripts/computer-b-send-archives.sh` | Saadab saatmata päevaarhiivid (`.tar.gz` ja valikuline `.tar.gz.enc`) Computer B-st `scp` kaudu ühele või mitmele Computer C serverile. |
| `scripts/computer-c-receive-archives.sh` | Kontrollib saabuvaid selgetekstilisi arhiive ja seab selgetekstilised/krüptitud arhiivid lindi jaoks järjekorda. |
| `scripts/computer-c-write-to-tape.sh` | Kirjutab järjekorras olevad selgetekstilised või krüptitud arhiivid lindile, kontrollib ruumi, lisab need turvaliselt ja märgib salvestatuks. |
| `scripts/computer-c-inventory-tape.sh` | Trükib välja lindi sisukorra failimarkeri kaupa, et operaatorid leiaksid arhiivid kiiresti üles. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Skannib lindi failiasukohti soovitud arhiivi leidmiseks, dekrüpteerib vajaduse korral ja salvestab taastatud andmed faili. |
| `scripts/test-computer-a-b-c-integration.sh` | Käivitab deterministliku kohaliku A→B→C integratsioonitesti (sh taastamise lindilt), mis ei sõltu tegelikust kellaajast. |

Tüüpiline ajastus:

- Käivita `computer-b-hourly-rotate.sh` iga tund (cron B-s).
- Käivita `computer-b-daily-archive.sh` üks kord päevas (cron B-s).
- Käivita `computer-b-send-archives.sh` pärast arhiivi loomist (cron B-s).
- Käivita `computer-c-receive-archives.sh` perioodiliselt C-s.
- Käivita `computer-c-write-to-tape.sh` perioodiliselt C-s õige lindiseadmega.
- Käivita `computer-c-inventory-tape.sh` C-s siis, kui vajad failimarkeri kaupa sisukorda.
- Käivita `computer-c-restore-archive-from-tape.sh` C-s siis, kui vajad konkreetse arhiivi taastamist kontrollimiseks.

Kõik torustikuskriptid saadavad lisaks konsooliväljundile ka tööteateid syslogi `logger`i kaudu (näiteks nähtavad rsyslogi/journalingu kaudu).

### Mitme serveri saatmine Computer B-st

`computer-b-send-archives.sh` toetab nii ühe serveri režiimi kui ka mitme serveri režiimi:

- Üks server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Mitu serverit: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Kliendipoolse serverivaliku võimalused:

- Määra argumentides üks server, et kinnistada valik ühele Computer C-le.
- Määra mitu serverit, et lubada varuvarianti.
- Sea `PREFERRED_SERVER=user@host`, et valida antud loendist üks konkreetne server.

Hõivatuse käsitlemise valikud Computer B-s:

- `REMOTE_BUSY_MARKER` (vaikimisi: `.busy`): kaugpoolel kontrollitav markerfail.
- `BUSY_RETRY_SECONDS` (vaikimisi: `60`): ooteaeg korduskatsete vahel, kui server on hõivatud.
- `BUSY_MAX_RETRIES` (vaikimisi: `10`): korduskatsete maksimaalne arv serveri kohta.

### Hõivatud oleku avaldamine Computer C-st

`computer-c-write-to-tape.sh` loob hõivatusmarkeri, kui ta kirjutab aktiivselt arhiive lindile, ja eemaldab selle, kui on jõude.

- `BUSY_MARKER` (vaikimisi: `<received_dir>/.busy`)

Suuna `REMOTE_BUSY_MARKER` Computer B-s markerasukohta, mida Computer C kasutab.

### Lindiohutus ja lisava kirjutamise käitumine Computer C-s

Enne iga arhiivi kirjutamist kontrollib `computer-c-write-to-tape.sh` saadaolevat lindi-/seadmeruumi ja nõuab vähemalt:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Asjakohased muutujad:

- `TAPE_SAFETY_MARGIN_BYTES` (vaikimisi: `10485760`)
- `TAPE_AVAILABLE_BYTES` (ületus teadaoleva saadaoleva ruumi jaoks)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (lubab kirjutamist, kui ruumi ei saa tuvastada)

Päris lindiseadmete puhul liigub kirjutaja enne kirjutamist andmete lõppu (`mt eom`/`mt eod`), nii et mitu arhiivi lisatakse järjest, mitte ei kirjutata varasemat lindisisu üle.

### Inimloetavad ajatemplid failinimedes

- Tunnilogide nimed on näiteks: `rsyslog-2026-06-01T1600.log`
- Päevaarhiivide nimed on näiteks: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Päevaarhiivide vahemikud põhinevad arhiivi lisatud tegelikel esimesel ja viimasel tunnifailil.
Need nimed on mõeldud olema loetavad inimestele, kes otsivad sündmuste kuupäeva/kellaaja vahemikke.
Praegune tund jäetakse arhiivi loomisest teadlikult välja, et aktiivseid kirjutusi ei edastataks.

### Valikuline OpenSSL-krüptimine päevaarhiividele

`computer-b-daily-archive.sh` võib arhiive OpenSSL-iga krüptida pärast tarballi loomist:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` sümmeetriliseks krüptimiseks (`openssl enc`, vaikimisi šiffer `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` saaja sertifikaadiga krüptimiseks (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` OpenSSL-i šifri valimiseks nii võtmefaili kui sertifikaadi režiimis (vaikimisi: `aes-256-gcm`).

Korraga võib olla määratud ainult üks neist valikutest. Krüptitud väljund kasutab `.tar.gz.enc`.
Turvalisuse huvides lükkab skript tagasi nõrgad või mitte-AEAD šifri valikud ja nõuab GCM/poly1305-klassi šifreid.

### Arhiivi taastamine lindilt Computer C-s

Kasuta `computer-c-restore-archive-from-tape.sh`, et leida konkreetne arhiiv, otsides lindi faile järjekorras algusest peale:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Arhiivinimede puhul nagu `rsyslog-<start>_to_<end>.tar.gz` (või `.tar.gz.enc`) tuvastab skript õige vaste, kontrollides, et piiritlevad tunnifailid on taastatud koormas olemas.
- Kui sinu arhiivide nimetamisskeem on teistsugune, sea `TARGET_MEMBER_GLOB` shelli mustriks, mis vastab liikmele, mis peab arhiivis olemas olema.
- Kui arhiiv on krüptitud, anna vajaduse järgi dekrüptimisseaded:
  - `OPENSSL_DECRYPT_KEY_FILE` (sümmeetriline `openssl enc` režiim; vaikimisi dekrüptimisšiffer: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` ja `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME dekrüptimisrežiim)

Taastatud väljund kirjutatakse selgetekstilise `.tar.gz` failina, et seda saaks uurida tööriistadega nagu `tar -tzf`.

### Lindi sisukorra inventuur Computer C-s

Kasuta `computer-c-inventory-tape.sh`, et trükkida välja sisukord failimarkeri kaupa:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Väljundi veerud hõlmavad:

- `file_marker`: nullpõhine lindifaili markeri asukoht
- `status`: `ok`, `decrypted` või `unreadable`
- `encrypted`: kas kirje uurimiseks oli vaja dekrüpteerimist (`yes`/`no`)
- `archive_hint`: tuletatud arhiivilaadne nimi, kui piire on võimalik ära tunda
- `first_member` / `last_member`: esimene ja viimane selles markeris nähtud tar-liige
- `member_count`: selles markeris leitud tar-liikmete arv
- `bytes`: sellest markerist loetud toorbaitide hulk

See võimaldab operaatoril tuvastada markeri indeksi, kuhu enne taastetoiminguid liikuda (`mt fsf <N>`).

### Deterministlik A/B/C integratsioonitest

Kasuta `scripts/test-computer-a-b-c-integration.sh`, et valideerida Computers A, B ja C otsast otsani integratsioon sõltumata möödunud ajast:

```sh
scripts/test-computer-a-b-c-integration.sh
```

See skript:

1. Simuleerib, et A kirjutab logisid.
2. Käivitab B roteerimise ja päevaarhiivi loomise.
3. Simuleerib ülekande C incoming-kataloogi.
4. Käivitab C receive + write-to-tape.
5. Taastab arhiivi lindilt ja kontrollib sisu.

See kasutab fikseeritud päevatemplit (`TEST_DAY_STAMP`, vaikimisi `20260101`), et käitumine oleks korratav ega sõltuks jooksvast kuupäevast/kellaajast.

### 72-tunnine säilitus kinnitamata andmete turvamiseks

Skriptid kasutavad nüüd vaikimisi 72-tunnist säilitusakent:

- `computer-b-hourly-rotate.sh` eemaldab vanu tunniloge ainult siis, kui vastav kohalik `.taped` kinnitusmarker on olemas.
- `computer-b-send-archives.sh` eemaldab vanu kohalikke arhiive ainult siis, kui olemas on nii `.sent` kui ka kohalik `.taped` kinnitusmarker.
- `computer-c-write-to-tape.sh` eemaldab ainult vanu arhiive, millel on juba `.taped` markerid.

Selle tulemusena säilitatakse faile, mida pole veel edukalt edastatud ja lindile talletatud, isegi siis, kui need on vanemad kui `RETENTION_HOURS` (vaikimisi `72`).
Computer B-s nõuab kohalik puhastus kohalikke `.taped` markereid (näiteks sync-back sammust või käsitsi kinnitamise protsessist).
Computer C-s mõõdetakse säilituse vanust `.taped` markeri muutmisajast (tavaliselt määratud eduka lindikirjutuse ajal).
