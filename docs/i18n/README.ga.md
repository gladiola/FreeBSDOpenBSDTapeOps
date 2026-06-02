# FreeBSDOpenBSDTapeOps (Gaeilge)

Scripteanna sliogáin idirghníomhacha a shiúlann trí ghnáth-oibríochtaí téipe maighnéadaí ag úsáid `mt` agus `tar`.

## Innéacs Doiciméadúcháin Teangacha

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


## Scripteanna

| Script | Sprioc-OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Déanann an dá script an seicheamh céanna oibríochtaí:

1. Iarr ar an úsáideoir a dheimhniú go bhfuil an téip luchtaithe.
2. Athchas an téip.
3. Priontáil stádas na téipe.
4. Liostaigh ábhar na gcartlann ag suíomhanna comhaid 0, 1, 2, agus 3 ag úsáid `tar t`.
5. Cuir an téip as líne.

Stopann gach céim agus fanann sí go mbrúfaidh an t-úsáideoir **Enter** sula leanann sí ar aghaidh, rud a fhágann go bhfuil na scripteanna oiriúnach mar léirithe idirghníomhacha nó mar shiúlóidí treoraithe.

## Difríochtaí idir an Dá Script

### 1. Conair ghléis na téipe

Díríonn na scripteanna ar nóid ghléis téipe éagsúla:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

Is nóid ghléis neamh-athchasacha iad an dá cheann (an réimír `n`), mar sin caomhnaítear suíomh na téipe idir orduithe agus rialaíonn na scripteanna an suíomh go follasach le `mt rewind` agus `mt fsf`.

### 2. Céim luchtaithe na téipe

- **FreeBSD**: Eisíonn sé `mt -f /dev/nsa0 load` ag am tosaithe chun an chartús téipe a luchtú go meicniúil isteach sa tiomántán sula n-athchastar í.
- **OpenBSD**: Fágann sé an t-ordú `load` ar lár mar nach dtacaíonn `mt(1)` OpenBSD le fo-ordú `load`. Glacann script OpenBSD leis go bhfuil an téip sa tiomántán cheana féin agus téann sé díreach chuig an athchasadh.

## Scripteanna píblíne logaí OpenBSD A-go-B-go-C

Soláthraíonn an t-eolaire `scripts/` scripteanna don chás ina bhfaigheann OpenBSD Computer B iontrálacha rsyslog ó Computer A, ina mbaisceálann sé iad go laethúil, ina seolann sé iad chuig ceann de roinnt freastalaithe Computer C, agus ina scríobhann Computer C iad ar théip.

| Script | Cuspóir |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Cruthaíonn sé loga rothlaithe uair an chloig ón gcomhad ionchuir rsyslog gníomhach ar Computer B. |
| `scripts/computer-b-daily-archive.sh` | Cuachtaíonn sé lá amháin (`YYYYMMDD`) de logaí uairúla isteach i gcartlann `.tar.gz` raon-ama ar Computer B, agus an uair reatha á fágáil amach chun coinbhleachtaí le scríbhinní gníomhacha a sheachaint. |
| `scripts/computer-b-send-archives.sh` | Seolann sé cartlanna laethúla nár seoladh fós (`.tar.gz` agus `.tar.gz.enc` roghnach) ó Computer B chuig freastalaí Computer C amháin nó níos mó trí `scp`. |
| `scripts/computer-c-receive-archives.sh` | Bailíochtaíonn sé cartlanna gnáth-théacs atá ag teacht isteach agus cuireann sé cartlanna gnáth-théacs/crioptaithe i scuaine don téip. |
| `scripts/computer-c-write-to-tape.sh` | Scríobhann sé cartlanna gnáth-théacs nó crioptaithe atá sa scuaine ar théip, seiceálann sé spás, cuireann sé leo go sábháilte, agus marcálann sé mar thaifeadta iad. |
| `scripts/computer-c-inventory-tape.sh` | Priontálann sé clár ábhair na téipe de réir marcóra comhaid ionas gur féidir le hoibreoirí cartlanna a aimsiú go tapa. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Scanann sé suíomhanna comhaid ar an téip le haghaidh cartlainne iarrtha, díchriptíonn sé nuair is gá, agus sábhálann sé sonraí aisghafa i gcomhad. |
| `scripts/test-computer-a-b-c-integration.sh` | Ritheann sé tástáil chomhtháthaithe chinntitheach áitiúil A→B→C (lena n-áirítear aisghabháil ón téip) nach mbraitheann ar am an chloig. |

Sceidealú tipiciúil:

- Rith `computer-b-hourly-rotate.sh` gach uair an chloig (cron ar B).
- Rith `computer-b-daily-archive.sh` uair amháin sa lá (cron ar B).
- Rith `computer-b-send-archives.sh` tar éis cruthú na cartlainne (cron ar B).
- Rith `computer-c-receive-archives.sh` go tréimhsiúil ar C.
- Rith `computer-c-write-to-tape.sh` go tréimhsiúil ar C leis an ngléas téipe ceart.
- Rith `computer-c-inventory-tape.sh` ar C nuair a theastaíonn clár ábhair marcóir ar mharcóir uait.
- Rith `computer-c-restore-archive-from-tape.sh` ar C nuair a theastaíonn uait cartlann ar leith a aisghabháil lena hiniúchadh.

Scaoileann na scripteanna píblíne uile teachtaireachtaí oibríochtúla chuig syslog trí `logger` freisin (mar shampla, le feiceáil trí rsyslog/journaling) chomh maith leis an aschur consóil.

### Seoladh ilfhreastalaí ó Computer B

Tacaíonn `computer-b-send-archives.sh` le mód aonfhreastalaí agus mód ilfhreastalaí araon:

- Freastalaí aonair: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Ilfhreastalaí: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Roghanna roghnúcháin freastalaí ar thaobh an chliaint:

- Cuir freastalaí amháin ar fáil sna hargóintí chun é a phionnáil le Computer C amháin.
- Cuir roinnt freastalaithe ar fáil chun cúltaca a cheadú.
- Socraigh `PREFERRED_SERVER=user@host` chun freastalaí sonrach amháin a roghnú ón liosta a cuireadh ar fáil.

Roghanna láimhseála gnóthachais ar Computer B:

- `REMOTE_BUSY_MARKER` (réamhshocrú: `.busy`): comhad marcóra a sheiceáiltear ar an taobh iargúlta.
- `BUSY_RETRY_SECONDS` (réamhshocrú: `60`): am feithimh idir atrialacha fad is atá an freastalaí gnóthach.
- `BUSY_MAX_RETRIES` (réamhshocrú: `10`): uasmhéid atrialacha in aghaidh an fhreastalaí.

### Foilsiú staid ghnóthaigh ó Computer C

Cruthaíonn `computer-c-write-to-tape.sh` marcóir gnóthach agus é ag scríobh cartlanna go gníomhach ar théip agus baintear é nuair atá sé díomhaoin.

- `BUSY_MARKER` (réamhshocrú: `<received_dir>/.busy`)

Pointeáil `REMOTE_BUSY_MARKER` ar Computer B chuig suíomh an mharcóra a úsáideann Computer C.

### Sábháilteacht téipe agus iompar append ar Computer C

Sula scríobhtar gach cartlann, seiceálann `computer-c-write-to-tape.sh` an acmhainn téipe/ghléis atá ar fáil agus éilíonn sé ar a laghad:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Athróga ábhartha:

- `TAPE_SAFETY_MARGIN_BYTES` (réamhshocrú: `10485760`)
- `TAPE_AVAILABLE_BYTES` (sárú le haghaidh spáis atá ar eolas a bheith ar fáil)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ceadaíonn sé scríobh mura féidir spás a bhrath)

Maidir le fíorghléasanna téipe, lorgaíonn an scríobhaí deireadh na sonraí (`mt eom`/`mt eod`) sula scríobhann sé, ionas go gcuirtear roinnt cartlann leis in ionad ábhar téipe roimhe seo a fhorscríobh.

### Stampaí ama atá inléite ag daoine in ainmneacha comhad

- Ainmnítear logaí uairúla mar seo: `rsyslog-2026-06-01T1600.log`
- Ainmnítear cartlanna laethúla mar seo: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Tá raonta na gcartlann laethúil bunaithe ar na chéad agus na comhaid uairúla deireanacha iarbhír atá san áireamh sa chartlann.
Tá sé beartaithe go mbeidh na hainmneacha seo inléite ag daoine atá ag scanadh do fhuinneoga dáta/ama imeachta.
Fágtar an uair reatha ar lár d'aon ghnó ó chruthú cartlainne ionas nach seolfar scríbhinní gníomhacha.

### Criptiú OpenSSL roghnach do chartlanna laethúla

Is féidir le `computer-b-daily-archive.sh` cartlanna a chriptiú le OpenSSL tar éis an tarball a chruthú:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` le haghaidh criptithe siméadraigh (`openssl enc`, cipher réamhshocraithe `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` le haghaidh criptithe le teastas an fhaighteora (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` chun an cipher OpenSSL a roghnú do mhodh an chomhaid eochrach agus mhodh an teastais araon (réamhshocrú: `aes-256-gcm`).

Ní féidir ach ceann amháin de na roghanna seo a shocrú ag aon am amháin. Úsáideann aschuir chriptithe `.tar.gz.enc`.
Ar mhaithe le slándáil, diúltaíonn an script do roghanna cipher laga nó neamh-AEAD agus éilíonn sé cipher sa rang GCM/poly1305.

### Aisghabháil cartlainne ó théip ar Computer C

Úsáid `computer-c-restore-archive-from-tape.sh` chun cartlann ar leith a aimsiú trí chomhaid téipe a chuardach in ord ón tús:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Maidir le hainmneacha cartlainne cosúil le `rsyslog-<start>_to_<end>.tar.gz` (nó `.tar.gz.enc`), aithníonn an script an mheaitseáil cheart trí sheiceáil go bhfuil na comhaid uairúla teorann i láthair san ualach aisghafa.
- Má tá ainmniú do chartlann difriúil, socraigh `TARGET_MEMBER_GLOB` chuig patrún sliogáin a mheaitseálann ball a chaithfidh a bheith sa chartlann.
- Má tá cartlann criptithe, cuir socruithe díchriptithe ar fáil de réir mar is gá:
  - `OPENSSL_DECRYPT_KEY_FILE` (mód siméadrach `openssl enc`; cipher díchriptithe réamhshocraithe: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` agus `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (mód díchriptithe S/MIME)

Scríobhtar an t-aschur aisghafa mar chomhad `.tar.gz` gnáth-théacs ionas gur féidir é a iniúchadh le huirlisí ar nós `tar -tzf`.

### Fardal chlár ábhair téipe ar Computer C

Úsáid `computer-c-inventory-tape.sh` chun clár ábhair a phriontáil marcóir ar mharcóir:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Áirítear leis na colúin aschuir:

- `file_marker`: suíomh marcóra comhaid téipe bunaithe ar nialas
- `status`: `ok`, `decrypted`, nó `unreadable`
- `encrypted`: ar theastaigh díchriptiú chun an iontráil a iniúchadh (`yes`/`no`)
- `archive_hint`: ainm i stíl cartlainne a thugtar le fios nuair is féidir na teorainneacha a aithint
- `first_member` / `last_member`: an chéad agus an t-ábhar tar deireanach a fheictear sa mharcóir sin
- `member_count`: líon na n-ábhar tar a fhaightear sa mharcóir sin
- `bytes`: bearta amha a léitear ag an marcóir sin

Ligeann sé seo d'oibreoir innéacs an mharcóra le lorg (`mt fsf <N>`) a aithint roimh oibríochtaí aisghabhála.

### Tástáil chomhtháthaithe chinntithigh A/B/C

Úsáid `scripts/test-computer-a-b-c-integration.sh` chun comhtháthú ceann go ceann Computers A, B, agus C a bhailíochtú beag beann ar an am atá caite:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Déanann an script seo:

1. Insamhlaíonn sé A ag scríobh logaí.
2. Ritheann sé rothlú B agus cruthú cartlainne laethúla.
3. Insamhlaíonn sé aistriú isteach chuig C incoming.
4. Ritheann sé C receive + write-to-tape.
5. Aisghabhann sé an chartlann ón téip agus bailíochtaíonn sé an t-ábhar.

Úsáideann sé stampa lae seasta (`TEST_DAY_STAMP`, réamhshocrú `20260101`) ionas go bhfuil an t-iompar in-athdhéanta agus nach bhfuil sé ceangailte le dáta/am reatha.

### Coinneáil 72 uair an chloig le sábháilteacht do shonraí neamhdheimhnithe

Úsáideann na scripteanna fuinneog choinneála 72 uair an chloig mar réamhshocrú anois:

- Ní bhaineann `computer-b-hourly-rotate.sh` sean-logaí uairúla ach amháin nuair atá marcóir deimhnithe `.taped` áitiúil meaitseála ann.
- Ní bhaineann `computer-b-send-archives.sh` sean-chartlanna áitiúla ach amháin nuair atá marcóirí deimhnithe `.sent` agus `.taped` áitiúil araon ann.
- Ní bhaineann `computer-c-write-to-tape.sh` ach sean-chartlanna a bhfuil marcóirí `.taped` acu cheana féin.

Mar thoradh air sin, coinnítear comhaid nár tarchuireadh agus nár taifeadadh ar théip go rathúil fós fiú nuair atá siad níos sine ná `RETENTION_HOURS` (réamhshocrú `72`).
Ar Computer B, éilíonn glantachán áitiúil marcóirí `.taped` áitiúla (mar shampla ó chéim sync-back nó ó phróiseas deimhnithe láimhe).
Ar Computer C, tomhaistear aois na coinneála ó am modhnaithe an mharcóra `.taped` (socraithe de ghnáth ag am rathúil scríofa ar théip).

## Léaráidí píblíne

- [Léaráidí seichimh agus staid Mermaid A/B/C](pipeline-diagrams/README.ga.md)
