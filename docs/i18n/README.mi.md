# FreeBSDOpenBSDTapeOps (Te Reo Māori)

He hōtuhi shell pāhekoheko e ārahi ana i ngā mahi rīpene autō e whakamahia nuitia ana mā `mt` me `tar`.

## Taurangi Tuhinga Reo

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


## Ngā Hōtuhi

| Script | OS Whāinga |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Ka whakahaere ngā hōtuhi e rua i taua raupapa mahi anō:

1. Tonoa te kaiwhakamahi kia whakaū kua utaina te rīpene.
2. Whakahokia te rīpene ki te tīmatanga.
3. Tāngia te tūnga o te rīpene.
4. Rārangihia ngā ihirangi o ngā pūranga i ngā tūranga kōnae 0, 1, 2, me te 3 mā `tar t`.
5. Whakanohoia te rīpene kia offline.

Ka whakatā poto ia hipanga, ka tatari kia pēhia e te kaiwhakamahi te **Enter** i mua i te haere tonu, nā reira he pai ngā hōtuhi nei mō ngā whakaaturanga pāhekoheko, mō ngā aratohu hīkoi rānei.

## Ngā Rerekētanga i Waenga i ngā Hōtuhi e Rua

### 1. Ara pūrere rīpene

E whāia ana e ngā hōtuhi nei ngā kōpuku pūrere rīpene rerekē:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

He kōpuku pūrere kāore e whakahoki aunoa ēnei e rua (te pūmatua `n`), nō reira ka puritia te tūnga o te rīpene i waenga i ngā whakahau, ā, ka whakahaere ā-marama ngā hōtuhi i te tūnga mā `mt rewind` me `mt fsf`.

### 2. Hipanga uta rīpene

- **FreeBSD**: Ka tukuna te `mt -f /dev/nsa0 load` i te tīmatanga kia uta ā-miihini i te kārere rīpene ki roto i te drive i mua i te whakahokinga ki te tīmatanga.
- **OpenBSD**: Ka kapea te whakahau `load` nā te mea kāore te `mt(1)` o OpenBSD e tautoko i tētahi subcommand `load`. Ka whakapae te hōtuhi OpenBSD kua noho kē te rīpene i roto i te drive, ā, ka haere tika ki te whakahoki ki te tīmatanga.

## Ngā Hōtuhi Paipa Rangitaki OpenBSD A-ki-B-ki-C

Ka whakarato te kōpaki `scripts/` i ngā hōtuhi mō te āhuatanga ka whiwhi te Rorohiko B OpenBSD i ngā tāurunga rsyslog mai i te Rorohiko A, ka kohikohi ā-rā, ka tuku atu ki tētahi o ngā tūmau Rorohiko C maha, ā, ka tuhi te Rorohiko C i aua mea ki te rīpene.

| Script | Kaupapa |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Ka waihanga i tētahi rangitaki huri ia hāora mai i te kōnae tāurunga rsyslog hohe i te Rorohiko B. |
| `scripts/computer-b-daily-archive.sh` | Ka whakakotahi i tētahi rā kotahi (`YYYYMMDD`) o ngā rangitaki ia-hāora ki roto i tētahi pūranga `.tar.gz` whai-awhe wā i te Rorohiko B, me te whakakore i te hāora o nāianei kia karo i ngā taupatupatu tuhi hohe. |
| `scripts/computer-b-send-archives.sh` | Ka tuku i ngā pūranga ā-rā kāore anō kia tukuna (`.tar.gz` me te `.tar.gz.enc` kōwhiri) mai i te Rorohiko B ki tētahi tūmau Rorohiko C kotahi, neke atu rānei mā `scp`. |
| `scripts/computer-c-receive-archives.sh` | Ka whakamana i ngā pūranga plaintext e tae mai ana, ā, ka whakatakoto i ngā pūranga plaintext, encrypted rānei ki te rārangi mō te rīpene. |
| `scripts/computer-c-write-to-tape.sh` | Ka tuhi i ngā pūranga plaintext, encrypted rānei kua whakararangihia ki te rīpene, ka tirotiro i te wāhi, ka tāpiri haumaru, ā, ka tohu kua tuhia. |
| `scripts/computer-c-inventory-tape.sh` | Ka tā i tētahi table-of-contents rīpene mā te file marker kia tere ai te kimi pūranga a ngā kaiwhakahaere. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Ka matawai i ngā tūranga kōnae rīpene mō tētahi pūranga i tonoa, ka wetemunatia ina hiahiatia, ā, ka penapena i ngā raraunga kua whakahokia ki tētahi kōnae. |
| `scripts/test-computer-a-b-c-integration.sh` | Ka whakahaere i tētahi whakamātau whakakotahi ā-rohe A→B→C pūmau (tae atu ki te whakahoki mai i te rīpene) kāore e whakawhirinaki ki te wā o te karaka. |

Hōtaka noa:

- Whakahaerehia `computer-b-hourly-rotate.sh` ia hāora (cron i B).
- Whakahaerehia `computer-b-daily-archive.sh` kotahi ia rā (cron i B).
- Whakahaerehia `computer-b-send-archives.sh` i muri i te hanganga o te pūranga (cron i B).
- Whakahaerehia `computer-c-receive-archives.sh` i ētahi wā i C.
- Whakahaerehia `computer-c-write-to-tape.sh` i ētahi wā i C me te pūrere rīpene tika.
- Whakahaerehia `computer-c-inventory-tape.sh` i C ina hiahia koe ki tētahi table-of-contents marker-by-marker.
- Whakahaerehia `computer-c-restore-archive-from-tape.sh` i C ina hiahia koe ki te whakahoki i tētahi pūranga motuhake mō te arowhai.

Ka tuku hoki ngā hōtuhi paipa katoa i ngā karere whakahaere ki syslog mā `logger` (hei tauira, ka kitea mā rsyslog/journaling) hei tāpiri ki te putanga o te papatohu.

### Tukunga ki ngā tūmau maha mai i te Rorohiko B

Ka tautoko a `computer-b-send-archives.sh` i te aratau tūmau kotahi me te aratau tūmau maha:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Ngā kōwhiringa tīpako tūmau i te taha kiritaki:

- Tuku atu he tūmau kotahi i roto i ngā arguments kia piri ki tētahi Rorohiko C kotahi.
- Tuku atu he tūmau maha kia āhei ai te fallback.
- Tautuhia `PREFERRED_SERVER=user@host` kia kōwhiri i tētahi tūmau motuhake mai i te rārangi i tukuna mai.

Ngā kōwhiringa whakahaere busy i te Rorohiko B:

- `REMOTE_BUSY_MARKER` (taunoa: `.busy`): te kōnae tohu e tirohia ana i te taha mamao.
- `BUSY_RETRY_SECONDS` (taunoa: `60`): te wā tatari i waenga i ngā whakamātau anō i te wā busy te tūmau.
- `BUSY_MAX_RETRIES` (taunoa: `10`): te maha rawa o ngā whakamātau anō mō ia tūmau.

### Whakaputanga tūnga busy mai i te Rorohiko C

Ka waihanga a `computer-c-write-to-tape.sh` i tētahi busy marker i a ia e tuhi kaha ana i ngā pūranga ki te rīpene, ā, ka tango i taua tohu ina noho wātea.

- `BUSY_MARKER` (taunoa: `<received_dir>/.busy`)

Tohua `REMOTE_BUSY_MARKER` i te Rorohiko B ki te wāhi marker e whakamahia ana e te Rorohiko C.

### Haumarutanga rīpene me te whanonga tāpiri i te Rorohiko C

I mua i te tuhi i ia pūranga, ka tirohia e `computer-c-write-to-tape.sh` te kaha o te rīpene, o te pūrere rānei e wātea ana, ā, me whai i te iti rawa:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Ngā taurangi hāngai:

- `TAPE_SAFETY_MARGIN_BYTES` (taunoa: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override mō te wāhi wātea kua mōhiotia)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ka whakaae kia tuhia mēnā kāore e taea te kite i te wāhi)

Mō ngā pūrere rīpene tūturu, ka rapu te kaituhi ki te pito o te raraunga (`mt eom`/`mt eod`) i mua i te tuhi, nō reira ka tāpirihia ngā pūranga maha, kāore e tuhiruatia ngā ihirangi rīpene o mua.

### Ngā timestamp ka taea e te tangata te pānui i ngā ingoa kōnae

- Ka tapaina ngā rangitaki ia-hāora pēnei: `rsyslog-2026-06-01T1600.log`
- Ka tapaina ngā pūranga ā-rā pēnei: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Ka hāngai ngā awhe pūranga ā-rā ki ngā kōnae hāora tuatahi me te whakamutunga i tino whakaurua ki roto i te pūranga.
Kua whakaritea ēnei ingoa kia māmā te pānui mā te hunga e mātai ana i ngā matapihi rā me te wā o ngā takahanga.
Kua āta whakakorehia te hāora o nāianei i te hanganga pūranga kia kaua e tukuna ngā tuhinga kaha tonu.

### Whakamunatanga OpenSSL kōwhiri mō ngā pūranga ā-rā

Ka taea e `computer-b-daily-archive.sh` te encrypt i ngā pūranga mā OpenSSL i muri i te waihangatanga o te tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` mō te symmetric encryption (`openssl enc`, te cipher taunoa `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` mō te recipient-certificate encryption (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` hei kōwhiri i te cipher OpenSSL mō ngā aratau key-file me te certificate e rua (taunoa: `aes-256-gcm`).

Kotahi anake o ēnei kōwhiringa ka taea te tautuhi i te wā kotahi. Ka whakamahi ngā putanga encrypted i `.tar.gz.enc`.
Mō te haumarutanga, ka whakakāhore te hōtuhi i ngā kōwhiringa cipher ngoikore, kāore rānei he AEAD, ā, ka tono kia whakamahia ngā cipher kāwai GCM/poly1305.

### Whakaora pūranga mai i te rīpene i te Rorohiko C

Whakamahia `computer-c-restore-archive-from-tape.sh` kia kimi ai i tētahi pūranga motuhake mā te rapu kōnae rīpene i te raupapa mai i te tīmatanga:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- Mō ngā ingoa pūranga pērā i `rsyslog-<start>_to_<end>.tar.gz` (rānei `.tar.gz.enc`), ka tautohu te hōtuhi i te ōrite tika mā te tirotiro kei roto ngā kōnae hāora taitapa i te payload kua whakahokia.
- Mēnā he rerekē tō tikanga whakaingoa pūranga, tautuhia `TARGET_MEMBER_GLOB` ki tētahi pattern shell e ōrite ana ki tētahi member me noho ki roto i te pūranga.
- Mēnā he encrypted tētahi pūranga, tukuna mai ngā tautuhinga decryption e hiahiatia ana:
  - `OPENSSL_DECRYPT_KEY_FILE` (te aratau symmetric `openssl enc`; te cipher decryption taunoa: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` me `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (te aratau decryption S/MIME)

Ka tuhia te putanga kua whakahokia hei kōnae `.tar.gz` plaintext kia taea te arowhai mā ngā taputapu pērā i `tar -tzf`.

### Rārangi table-of-contents rīpene i te Rorohiko C

Whakamahia `computer-c-inventory-tape.sh` kia tāia tētahi table-of-contents marker-by-marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Kei roto i ngā tīwae putanga:

- `file_marker`: te tūranga file marker rīpene ka tīmata i te kore
- `status`: `ok`, `decrypted`, rānei `unreadable`
- `encrypted`: mēnā i hiahiatia te decryption hei arotake i te entry (`yes`/`no`)
- `archive_hint`: te ingoa āhua-pūranga i whakatau tatahia ina āhei te mōhio i ngā taitapa
- `first_member` / `last_member`: ngā tar member tuatahi me te whakamutunga i kitea i taua marker
- `member_count`: te maha o ngā tar member i kitea i taua marker
- `bytes`: ngā raw bytes i pānuihia i taua marker

Mā konei ka taea e tētahi kaiwhakahaere te tohu i te marker index hei whai (`mt fsf <N>`) i mua i ngā mahi whakaora.

### Whakamātau whakakotahi A/B/C pūmau

Whakamahia `scripts/test-computer-a-b-c-integration.sh` hei whakamana i te whakakotahitanga pito-ki-pito o ngā Rorohiko A, B, me C ahakoa te roa o te wā kua pahure:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Ko tēnei hōtuhi:

1. Ka whaihanga i a A e tuhi rangitaki ana.
2. Ka whakahaere i te rotation me te waihanga pūranga ā-rā a B.
3. Ka whaihanga i te whakawhitinga ki te incoming a C.
4. Ka whakahaere i te receive a C me te write-to-tape.
5. Ka whakahoki i te pūranga mai i te rīpene, ā, ka whakamana i te ihirangi.

Ka whakamahi i tētahi tohu rā pūmau (`TEST_DAY_STAMP`, taunoa `20260101`) kia taea ai te tukurua i te whanonga, kia kaua hoki e herea ki te rā, ki te wā rānei o nāianei.

### Pupuri 72-hāora me te haumarutanga mō ngā raraunga kāore anō kia whakaūngia

Kua noho ngā hōtuhi ki tētahi matapihi pupuri 72-hāora hei taunoa:

- `computer-b-hourly-rotate.sh` ka tango noa i ngā rangitaki hāora tawhito ina noho tētahi marker whakaū `.taped` ā-rohe e ōrite ana.
- `computer-b-send-archives.sh` ka tango noa i ngā pūranga ā-rohe tawhito ina noho ngātahi ngā marker whakaū `.sent` me te `.taped` ā-rohe.
- `computer-c-write-to-tape.sh` ka tango noa i ngā pūranga tawhito kua whai marker `.taped` kē.

Nā reira, ka puritia tonu ngā kōnae kāore anō kia tuku tika, kia tuhia hoki ki te rīpene ahakoa kua tawhito ake i `RETENTION_HOURS` (taunoa `72`).
I te Rorohiko B, me whai ngā mahi horoi ā-rohe i ngā marker `.taped` ā-rohe (hei tauira nō tētahi hipanga sync-back, nō tētahi tukanga whakaū ā-ringa rānei).
I te Rorohiko C, ka inea te pakeke pupuri mai i te wā whakarerekē o te marker `.taped` (ko te tikanga ka tautuhia i te wā e angitu ai te tuhi ki te rīpene).

## Ngā hoahoa paipa

- [Ngā hoahoa Mermaid mō te raupapa me ngā āhua o A/B/C](pipeline-diagrams/README.mi.md)
