# FreeBSDOpenBSDTapeOps (Suomi)

Interaktiiviset shell-skriptit, jotka käyvät läpi yleisiä magneettinauhaoperaatioita käyttäen `mt`:tä ja `tar`:ia.

## Kielidokumentaation hakemisto

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


## Skriptit

| Script | Kohdekäyttöjärjestelmä |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Molemmat skriptit suorittavat saman toimintasarjan:

1. Kehota käyttäjää vahvistamaan, että nauha on ladattu.
2. Kelaa nauha alkuun.
3. Tulosta nauhan tila.
4. Luettele tiedostopaikoissa 0, 1, 2 ja 3 olevien arkistojen sisältö käyttäen `tar t`.
5. Aseta nauha offline-tilaan.

Jokainen vaihe pysähtyy ja odottaa, että käyttäjä painaa **Enter** ennen jatkamista, mikä tekee skripteistä sopivia interaktiivisiksi demonstraatioiksi tai opastetuiksi läpikäynneiksi.

## Kahden skriptin erot

### 1. Nauhalaitteen polku

Skriptit kohdistuvat eri nauhalaitteen laitesolmuille:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Ne molemmat ovat ilman automaattista takaisinelausta toimivia laitesolmuja (`n`-etuliite), joten nauhan sijainti säilyy komentojen välillä ja skriptit hallitsevat sijaintia nimenomaisesti komennoilla `mt rewind` ja `mt fsf`.

### 2. Nauhan latausvaihe

- **FreeBSD**: Suorittaa käynnistyksessä `mt -f /dev/nsa0 load`, jotta nauhakasetti ladataan mekaanisesti asemaan ennen takaisinelausta.
- **OpenBSD**: Ohittaa komennon `load`, koska OpenBSD:n `mt(1)` ei tue `load`-alikomentoa. OpenBSD-skripti olettaa, että nauha on jo asemassa, ja siirtyy suoraan takaisinelaamiseen.

## OpenBSD A:sta B:hen ja C:hen -lokiputkiskriptit

Hakemisto `scripts/` sisältää skriptejä skenaarioon, jossa OpenBSD Computer B vastaanottaa rsyslog-merkintöjä Computer A:lta, niputtaa ne päivittäin, lähettää ne yhdelle useista Computer C -palvelimista ja Computer C kirjoittaa ne nauhalle.

| Script | Tarkoitus |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Luo tunnittain kierrätetyn lokin aktiivisesta rsyslog-syötetiedostosta Computer B:llä. |
| `scripts/computer-b-daily-archive.sh` | Niputtaa yhden päivän (`YYYYMMDD`) tunnittaisia lokeja aikavälilliseen `.tar.gz`-arkistoon Computer B:llä, jättäen nykyisen tunnin pois aktiivisten kirjoitusristiriitojen välttämiseksi. |
| `scripts/computer-b-send-archives.sh` | Lähettää lähettämättömät päivittäiset arkistot (`.tar.gz` ja valinnainen `.tar.gz.enc`) Computer B:ltä yhdelle tai useammalle Computer C -palvelimelle `scp`:n kautta. |
| `scripts/computer-c-receive-archives.sh` | Vahvistaa saapuvat selväkieliset arkistot ja asettaa selväkieliset/salatut arkistot jonoon nauhaa varten. |
| `scripts/computer-c-write-to-tape.sh` | Kirjoittaa jonossa olevat selväkieliset tai salatut arkistot nauhalle, tarkistaa tilan, lisää turvallisesti ja merkitsee ne tallennetuiksi. |
| `scripts/computer-c-inventory-tape.sh` | Tulostaa nauhan sisällysluettelon tiedostomerkki kerrallaan, jotta operaattorit löytävät arkistot nopeasti. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Skannaa nauhan tiedostosijainteja pyydetyn arkiston löytämiseksi, purkaa salauksen tarvittaessa ja tallentaa palautetut tiedot tiedostoon. |
| `scripts/test-computer-a-b-c-integration.sh` | Suorittaa deterministisen paikallisen A→B→C-integraatiotestin (mukaan lukien nauhapalautuksen), joka ei riipu kellonajasta. |

Tyypillinen ajoitus:

- Suorita `computer-b-hourly-rotate.sh` joka tunti (cron B:llä).
- Suorita `computer-b-daily-archive.sh` kerran päivässä (cron B:llä).
- Suorita `computer-b-send-archives.sh` arkiston luonnin jälkeen (cron B:llä).
- Suorita `computer-c-receive-archives.sh` säännöllisesti C:llä.
- Suorita `computer-c-write-to-tape.sh` säännöllisesti C:llä oikealla nauhalaitteella.
- Suorita `computer-c-inventory-tape.sh` C:llä, kun tarvitset tiedostomerkki kerrallaan esitetyn sisällysluettelon.
- Suorita `computer-c-restore-archive-from-tape.sh` C:llä, kun sinun täytyy palauttaa tietty arkisto tarkastusta varten.

Kaikki putkiskriptit lähettävät konsolitulosteen lisäksi myös operatiivisia viestejä syslogiin `logger`:n kautta (esimerkiksi näkyen rsyslogin/journalingin kautta).

### Monipalvelinlähetys Computer B:ltä

`computer-b-send-archives.sh` tukee sekä yhden palvelimen tilaa että monen palvelimen tilaa:

- Yksi palvelin: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Useita palvelimia: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Asiakaspuolen palvelinvalinnan vaihtoehdot:

- Anna argumenteissa yksi palvelin lukitaksesi käytön yhteen Computer C:hen.
- Anna useita palvelimia mahdollistaaksesi varajärjestelyn.
- Aseta `PREFERRED_SERVER=user@host` valitaksesi yhden tietyn palvelimen annetusta listasta.

Varattu-tilan käsittelyvaihtoehdot Computer B:llä:

- `REMOTE_BUSY_MARKER` (oletus: `.busy`): etäpäässä tarkistettava merkintätiedosto.
- `BUSY_RETRY_SECONDS` (oletus: `60`): odotusaika uusintayritysten välillä palvelimen ollessa varattu.
- `BUSY_MAX_RETRIES` (oletus: `10`): uusintayritysten enimmäismäärä palvelinta kohti.

### Varattu-tilan julkaisu Computer C:ltä

`computer-c-write-to-tape.sh` luo varattu-merkinnän, kun se kirjoittaa aktiivisesti arkistoja nauhalle, ja poistaa sen, kun se on joutilas.

- `BUSY_MARKER` (oletus: `<received_dir>/.busy`)

Aseta `REMOTE_BUSY_MARKER` Computer B:llä osoittamaan Computer C:n käyttämään merkinnän sijaintiin.

### Nauhaturvallisuus ja lisäävä kirjoituskäyttäytyminen Computer C:llä

Ennen jokaisen arkiston kirjoittamista `computer-c-write-to-tape.sh` tarkistaa käytettävissä olevan nauha-/laitekapasiteetin ja vaatii vähintään:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Olennaiset muuttujat:

- `TAPE_SAFETY_MARGIN_BYTES` (oletus: `10485760`)
- `TAPE_AVAILABLE_BYTES` (ohitus tunnetulle käytettävissä olevalle tilalle)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (sallii kirjoittamisen, jos tilaa ei voida havaita)

Oikeilla nauhalaitteilla kirjoittaja hakeutuu datan loppuun (`mt eom`/`mt eod`) ennen kirjoittamista, joten useita arkistoja lisätään aiemman nauhasisällön päälle kirjoittamisen sijaan.

### Ihmisluettavat aikaleimat tiedostonimissä

- Tunnittaiset lokit nimetään näin: `rsyslog-2026-06-01T1600.log`
- Päivittäiset arkistot nimetään näin: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Päivittäisten arkistojen aikavälit perustuvat arkistoon sisältyviin todellisiin ensimmäiseen ja viimeiseen tuntitiedostoon.
Näiden nimien tarkoitus on olla luettavia ihmisille, jotka selaavat tapahtumien päivämäärä-/aikaikkunoita.
Nykyinen tunti jätetään tarkoituksella pois arkiston luonnista, jotta aktiivisia kirjoituksia ei siirretä.

### Valinnainen OpenSSL-salaus päivittäisille arkistoille

`computer-b-daily-archive.sh` voi salata arkistoja OpenSSL:llä tarballin luonnin jälkeen:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` symmetriseen salaukseen (`openssl enc`, oletussalaus `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` vastaanottajan varmenteella tehtävään salaukseen (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` OpenSSL-salauksen valitsemiseksi sekä avaintiedosto- että varmennetilassa (oletus: `aes-256-gcm`).

Vain yksi näistä vaihtoehdoista voi olla asetettuna kerrallaan. Salattu tuloste käyttää `.tar.gz.enc`.
Turvallisuussyistä skripti hylkää heikot tai muut kuin AEAD-salausvalinnat ja edellyttää GCM/poly1305-luokan salauksia.

### Arkiston palautus nauhalta Computer C:llä

Käytä `computer-c-restore-archive-from-tape.sh` -skriptiä tietyn arkiston löytämiseen etsimällä nauhatiedostoja järjestyksessä alusta alkaen:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Arkistonimille kuten `rsyslog-<start>_to_<end>.tar.gz` (tai `.tar.gz.enc`) skripti tunnistaa oikean osuman tarkistamalla, että rajaavat tuntitiedostot ovat mukana palautetussa hyötykuormassa.
- Jos arkistonimeämisesi on erilainen, aseta `TARGET_MEMBER_GLOB` shell-kuvioksi, joka vastaa jäsentä, jonka on oltava arkistossa.
- Jos arkisto on salattu, anna purkuasetukset tarpeen mukaan:
  - `OPENSSL_DECRYPT_KEY_FILE` (symmetrinen `openssl enc` -tila; oletuspurkusalaus: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` ja `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME-purkutila)

Palautettu tuloste kirjoitetaan selväkielisenä `.tar.gz`-tiedostona, jotta sitä voidaan tarkastella työkaluilla kuten `tar -tzf`.

### Nauhan sisällysluettelon inventaario Computer C:llä

Käytä `computer-c-inventory-tape.sh` -skriptiä tulostamaan sisällysluettelo tiedostomerkki kerrallaan:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Tulosteen sarakkeet sisältävät:

- `file_marker`: nollapohjainen nauhatiedoston merkintäsijainti
- `status`: `ok`, `decrypted` tai `unreadable`
- `encrypted`: tarvittiinko merkinnän tarkastamiseen purkua (`yes`/`no`)
- `archive_hint`: päätelty arkistotyylinen nimi, kun rajat voidaan tunnistaa
- `first_member` / `last_member`: ensimmäinen ja viimeinen tässä merkinnässä nähty tar-jäsen
- `member_count`: tässä merkinnässä löytyneiden tar-jäsenten määrä
- `bytes`: tässä merkinnässä luetut raakabytet

Tämän avulla operaattori voi tunnistaa merkintäindeksin, johon siirtyä (`mt fsf <N>`) ennen palautustoimia.

### Deterministinen A/B/C-integraatiotesti

Käytä `scripts/test-computer-a-b-c-integration.sh` -skriptiä validoimaan Computers A:n, B:n ja C:n päästä päähän -integraatio riippumatta kuluneesta ajasta:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Tämä skripti:

1. Simuloi, että A kirjoittaa lokeja.
2. Suorittaa B:n kierrätyksen ja päivittäisen arkiston luonnin.
3. Simuloi siirron C incoming -hakemistoon.
4. Suorittaa C receive + write-to-tape.
5. Palauttaa arkiston nauhalta ja validoi sisällön.

Se käyttää kiinteää päiväleimaa (`TEST_DAY_STAMP`, oletus `20260101`), jotta toiminta on toistettavaa eikä sidottu nykyiseen päivämäärään tai aikaan.

### 72 tunnin säilytys vahvistamattomien tietojen turvaksi

Skriptit käyttävät nyt oletuksena 72 tunnin säilytysikkunaa:

- `computer-b-hourly-rotate.sh` poistaa vanhoja tuntikohtaisia lokeja vain, kun vastaava paikallinen `.taped`-vahvistusmerkki on olemassa.
- `computer-b-send-archives.sh` poistaa vanhoja paikallisia arkistoja vain, kun sekä `.sent`- että paikalliset `.taped`-vahvistusmerkit ovat olemassa.
- `computer-c-write-to-tape.sh` poistaa vain vanhoja arkistoja, joilla on jo `.taped`-merkinnät.

Tämän seurauksena tiedostot, joita ei ole vielä onnistuneesti siirretty ja tallennettu nauhalle, säilytetään silloinkin, kun ne ovat vanhempia kuin `RETENTION_HOURS` (oletus `72`).
Computer B:llä paikallinen siivous edellyttää paikallisia `.taped`-merkintöjä (esimerkiksi sync-back-vaiheesta tai manuaalisesta vahvistusprosessista).
Computer C:llä säilytyksen ikä mitataan `.taped`-merkinnän muutosajasta (yleensä asetettu onnistuneen nauhakirjoituksen aikaan).

## Putkistokaaviot

- [A/B/C Mermaid-sekvenssi- ja tilakaaviot](pipeline-diagrams/README.fi.md)
