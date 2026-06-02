# FreeBSDOpenBSDTapeOps (ʻŌlelo Hawaiʻi)

Nā script shell pāhekoheko e alakaʻi ana i nā hana maʻamau o ka lipine mākenēki me `mt` a me `tar`.

## Papa Kuhikuhi Palapala ʻŌlelo

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


## Nā Script

| Script | OS i kuhikuhi ʻia |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

Hana nā script ʻelua i ka lālani hana like:

1. Nīnau i ka mea hoʻohana e hōʻoia ua hoʻokomo ʻia ka lipine.
2. Hoʻihoʻi i ka lipine i ka hoʻomaka.
3. Paʻi i ke kūlana o ka lipine.
4. Hōʻike i nā mea o nā waihona ma nā kūlana faila 0, 1, 2, a me 3 me `tar t`.
5. Hoʻokomo i ka lipine i ke kūlana offline.

Kū iki kēlā me kēia ʻanuʻu a kali i ka mea hoʻohana e paʻi i **Enter** ma mua o ka hoʻomau ʻana, no laila kūpono nā script no nā hōʻike pāhekoheko a i ʻole nā alakaʻi hele wāwae ʻia.

## Nā ʻokoʻa ma waena o nā Script ʻElua

### 1. Ala o ka mea lipine

Kuhi nā script i nā node mea lipine ʻokoʻa:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

He mau node mea lipine non-rewinding lāua ʻelua (ka pīʻani mua `n`), no laila mālama ʻia ke kūlana lipine ma waena o nā kauoha a hoʻokele maopopo nā script i ke kūlana me `mt rewind` a me `mt fsf`.

### 2. Ka ʻanuʻu hoʻouka lipine

- **FreeBSD**: Hoʻopuka ia i `mt -f /dev/nsa0 load` i ka hoʻomaka ʻana e hoʻouka mīkini i ka pahu lipine i loko o ka drive ma mua o ka hoʻihoʻi ʻana.
- **OpenBSD**: Kāʻalo ia i ke kauoha `load` no ka mea ʻaʻole kākoʻo ʻo `mt(1)` o OpenBSD i kahi kauoha liʻiliʻi `load`. Manaʻo ka script OpenBSD ua noho mua ka lipine i loko o ka drive a hele pololei i ka hoʻihoʻi ʻana.

## Nā Script Paipu Log OpenBSD A-i-B-i-C

Hāʻawi ka papa kuhikuhi `scripts/` i nā script no ke kūlana e loaʻa ai i ka Kamepiula B OpenBSD nā komo rsyslog mai ka Kamepiula A, hōʻuluʻulu iā lākou i kēlā me kēia lā, hoʻouna iā lākou i kekahi o nā kikowaena Kamepiula C he nui, a kākau ka Kamepiula C iā lākou i ka lipine.

| Script | Kumu |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Hana i kahi log i huli ʻia i kēlā me kēia hola mai ka faila hoʻokomo rsyslog hana ma ka Kamepiula B. |
| `scripts/computer-b-daily-archive.sh` | Hoʻopili i hoʻokahi lā (`YYYYMMDD`) o nā log hola i loko o kahi waihona `.tar.gz` me ka laulā manawa ma ka Kamepiula B, me ka hoʻokaʻawale ʻana i ka hola o kēia manawa e pale i nā paio kākau hana. |
| `scripts/computer-b-send-archives.sh` | Hoʻouna i nā waihona lā i hoʻouna ʻole ʻia (`.tar.gz` a me ka `.tar.gz.enc` koho) mai ka Kamepiula B i hoʻokahi a i ʻole he nui nā kikowaena Kamepiula C ma o `scp`. |
| `scripts/computer-c-receive-archives.sh` | Hōʻoia i nā waihona plaintext e komo ana a waiho i nā waihona plaintext a i ʻole encrypted i ka lālani no ka lipine. |
| `scripts/computer-c-write-to-tape.sh` | Kākau i nā waihona plaintext a i ʻole encrypted i ka lālani i ka lipine, nānā i ka hakahaka, hoʻopili palekana i ka hopena, a kau i ka hōʻailona ua hoʻopaʻa ʻia. |
| `scripts/computer-c-inventory-tape.sh` | Paʻi i kahi table-of-contents lipine ma ka file marker i hiki i nā mea hana ke ʻimi wikiwiki i nā waihona. |
| `scripts/computer-c-restore-archive-from-tape.sh` | Nānā i nā kūlana faila lipine no ka waihona i noi ʻia, wehe i ka hūnā inā pono, a mālama i ka ʻikepili i hoʻihoʻi ʻia i kahi faila. |
| `scripts/test-computer-a-b-c-integration.sh` | Holo i kahi hoʻāʻo hoʻohui kūloko A→B→C paʻa (me ka hoʻihoʻi lipine pū) ʻaʻole i pili i ka manawa uaki. |

Ka papahana maʻamau:

- Holo i `computer-b-hourly-rotate.sh` i kēlā me kēia hola (cron ma B).
- Holo i `computer-b-daily-archive.sh` hoʻokahi manawa i kēlā me kēia lā (cron ma B).
- Holo i `computer-b-send-archives.sh` ma hope o ka hana ʻana i ka waihona (cron ma B).
- Holo i `computer-c-receive-archives.sh` ma kēlā me kēia manawa ma C.
- Holo i `computer-c-write-to-tape.sh` ma kēlā me kēia manawa ma C me ka mea lipine kūpono.
- Holo i `computer-c-inventory-tape.sh` ma C i ka wā e pono ai ʻoe i kahi table-of-contents marker-by-marker.
- Holo i `computer-c-restore-archive-from-tape.sh` ma C i ka wā e pono ai ʻoe e hoʻihoʻi i kahi waihona kikoʻī no ka nānā ʻana.

Hoʻouna pū nā script paipu a pau i nā memo hana i syslog ma o `logger` (no ka laʻana, hiki ke ʻike ʻia ma rsyslog/journaling) ma waho aʻe o ka puka console.

### Ka hoʻouna ʻana i nā kikowaena he nui mai Kamepiula B

Kākoʻo ʻo `computer-b-send-archives.sh` i ke ʻano kikowaena hoʻokahi a me ke ʻano kikowaena he nui:

- Single-server: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- Multi-server: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

Nā koho koho kikowaena ma ka ʻaoʻao client:

- Hāʻawi i hoʻokahi kikowaena i nā arguments e paʻa ai i hoʻokahi Kamepiula C.
- Hāʻawi i nā kikowaena he nui e ʻae i fallback.
- E hoʻonoho iā `PREFERRED_SERVER=user@host` e koho i hoʻokahi kikowaena kikoʻī mai ka papa inoa i hāʻawi ʻia.

Nā koho no ka mālama ʻana i ke kūlana busy ma Kamepiula B:

- `REMOTE_BUSY_MARKER` (paʻamau: `.busy`): ka faila hōʻailona i nānā ʻia ma ka ʻaoʻao mamao.
- `BUSY_RETRY_SECONDS` (paʻamau: `60`): ka manawa kali ma waena o nā hoʻāʻo hou i ka wā busy ka kikowaena.
- `BUSY_MAX_RETRIES` (paʻamau: `10`): ka nui loa o nā hoʻāʻo hou no kēlā me kēia kikowaena.

### Ka paʻi ʻia ʻana o ke kūlana busy mai Kamepiula C

Hana ʻo `computer-c-write-to-tape.sh` i kahi hōʻailona busy i ka wā e kākau maoli ana i nā waihona i ka lipine a wehe iā ia i ka wā ʻaʻohe hana.

- `BUSY_MARKER` (paʻamau: `<received_dir>/.busy`)

E kuhikuhi iā `REMOTE_BUSY_MARKER` ma Kamepiula B i ka wahi hōʻailona i hoʻohana ʻia e Kamepiula C.

### Ka palekana lipine a me ka ʻano hoʻopili ma Kamepiula C

Ma mua o ke kākau ʻana i kēlā me kēia waihona, nānā ʻo `computer-c-write-to-tape.sh` i ka hiki o ka lipine a i ʻole ka mea i loaʻa a koi ma ka liʻiliʻi:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

Nā variable pili:

- `TAPE_SAFETY_MARGIN_BYTES` (paʻamau: `10485760`)
- `TAPE_AVAILABLE_BYTES` (override no ka hakahaka i ʻike ʻia he loaʻa)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (ʻae i ke kākau inā ʻaʻole hiki ke ʻike ʻia ka hakahaka)

No nā mea lipine maoli, ʻimi ka mea kākau i ka hopena o ka ʻikepili (`mt eom`/`mt eod`) ma mua o ke kākau ʻana, no laila hoʻopili ʻia nā waihona he nui ma kahi o ke kākau hou ʻana ma luna o nā mea lipine kahiko.

### Nā timestamp hiki i ke kanaka ke heluhelu ma nā inoa faila

- Ua kapa ʻia nā log hola pēnei: `rsyslog-2026-06-01T1600.log`
- Ua kapa ʻia nā waihona lā pēnei: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

Hoʻokumu ʻia nā laulā waihona lā ma luna o nā faila hola mua a hope hoʻi i hoʻokomo ʻia i loko o ka waihona.
Hoʻolālā ʻia kēia mau inoa i mea hiki i nā kānaka ke heluhelu maʻalahi i ka wā e nānā ana i nā puka lā a me ka manawa o nā hanana.
Hoʻokaʻawale ʻia ka hola o kēia manawa mai ka hana waihona ʻana i mea e hoʻouna ʻole ʻia ai nā kākau hana.

### Ka hoʻopunipuni OpenSSL koho no nā waihona lā

Hiki iā `computer-b-daily-archive.sh` ke encrypt i nā waihona me OpenSSL ma hope o ka hana ʻana i ka tarball:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` no ka symmetric encryption (`openssl enc`, ka cipher paʻamau `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` no ka encryption me ka palapala hōʻoia o ka mea loaʻa (`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` e koho i ka cipher OpenSSL no nā ʻano key-file a me certificate (paʻamau: `aes-256-gcm`).

Hiki ke hoʻonohonoho ʻia hoʻokahi wale nō o kēia mau koho i ka manawa hoʻokahi. Hoʻohana nā puka encrypted i `.tar.gz.enc`.
No ka palekana, hōʻole ka script i nā koho cipher nāwaliwali a i ʻole nā cipher ʻaʻole AEAD, a koi i nā cipher papa GCM/poly1305.

### Ka hoʻihoʻi waihona mai ka lipine ma Kamepiula C

E hoʻohana i `computer-c-restore-archive-from-tape.sh` e ʻimi i kahi waihona kikoʻī ma ka huli ʻana i nā faila lipine ma ke ʻano mai ka hoʻomaka:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- No nā inoa waihona e like me `rsyslog-<start>_to_<end>.tar.gz` (a i ʻole `.tar.gz.enc`), ʻike ka script i ka mea kūpono ma ka nānā ʻana ua noho nā faila hola palena i loko o ka payload i hoʻihoʻi ʻia.
- Inā ʻokoʻa kāu kapa inoa waihona, e hoʻonohonoho iā `TARGET_MEMBER_GLOB` i kahi pattern shell e kūlike ana i kahi member pono e noho ma loko o ka waihona.
- Inā ua encrypted kekahi waihona, e hāʻawi i nā hoʻonohonoho decryption e like me ka pono:
  - `OPENSSL_DECRYPT_KEY_FILE` (ke ʻano symmetric `openssl enc`; ka cipher decryption paʻamau: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` a me `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (ke ʻano decryption S/MIME)

Kākau ʻia ka puka i hoʻihoʻi ʻia ma ke ʻano he faila `.tar.gz` plaintext i hiki ke nānā ʻia me nā mea hana e like me `tar -tzf`.

### Ka papa ʻike o ka table-of-contents lipine ma Kamepiula C

E hoʻohana i `computer-c-inventory-tape.sh` e paʻi i kahi table-of-contents marker-by-marker:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

Aia nā kolamu puka i loko o:

- `file_marker`: ke kūlana file marker lipine hoʻomaka-mai-ka-ʻole
- `status`: `ok`, `decrypted`, a i ʻole `unreadable`
- `encrypted`: inā pono ka decryption e nānā i ka entry (`yes`/`no`)
- `archive_hint`: ka inoa ʻano waihona i manaʻo ʻia i ka wā e hiki ai ke ʻike i nā palena
- `first_member` / `last_member`: nā tar member mua a hope i ʻike ʻia ma kēlā marker
- `member_count`: ka helu o nā tar member i loaʻa ma kēlā marker
- `bytes`: nā raw bytes i heluhelu ʻia ma kēlā marker

Hāʻawi kēia i ka mea hana i ka hiki ke ʻike i ka index marker e ʻimi ai (`mt fsf <N>`) ma mua o nā hana hoʻihoʻi.

### Ka hoʻāʻo hoʻohui A/B/C paʻa

E hoʻohana i `scripts/test-computer-a-b-c-integration.sh` e hōʻoia i ka hoʻohui hope-a-hope o nā Kamepiula A, B, a me C me ka nānā ʻole i ka manawa i hala:

```sh
scripts/test-computer-a-b-c-integration.sh
```

Kēia script:

1. Hoʻohālike iā A e kākau ana i nā log.
2. Holo i ka rotation a me ka hana waihona lā a B.
3. Hoʻohālike i ka hoʻoili ʻana i ka incoming o C.
4. Holo i ka receive a C me ka write-to-tape.
5. Hoʻihoʻi i ka waihona mai ka lipine a hōʻoia i ka ʻikepili.

Hoʻohana ia i kahi hōʻailona lā paʻa (`TEST_DAY_STAMP`, paʻamau `20260101`) i mea e hiki ai ke hana hou ʻia ke ʻano a ʻaʻole ia i paʻa i ka lā a i ʻole ka manawa o kēia manawa.

### Ka mālama 72 hola me ka palekana no ka ʻikepili i hōʻoia ʻole ʻia

Paʻamau kēia manawa nā script i kahi puka mālama 72 hola:

- `computer-b-hourly-rotate.sh` wehe wale i nā log hola kahiko ke loaʻa ka hōʻailona hōʻoia `.taped` kūloko kūpono.
- `computer-b-send-archives.sh` wehe wale i nā waihona kūloko kahiko ke loaʻa nā hōʻailona hōʻoia `.sent` a me ka `.taped` kūloko.
- `computer-c-write-to-tape.sh` wehe wale i nā waihona kahiko i loaʻa mua nā hōʻailona `.taped`.

Ma muli o kēia, mālama ʻia nā faila i hoʻouna ʻole ʻia a hoʻopaʻa ʻole ʻia i ka lipine me ka kūleʻa inā ʻoi aku ko lākou kahiko ma mua o `RETENTION_HOURS` (paʻamau `72`).
Ma Kamepiula B, koi ka hoʻomaʻemaʻe kūloko i nā hōʻailona `.taped` kūloko (no ka laʻana mai kahi ʻanuʻu sync-back a i ʻole kahi kaʻina hōʻoia lima).
Ma Kamepiula C, ana ʻia ka makahiki mālama mai ka manawa hoʻoponopono o ka hōʻailona `.taped` (maʻamau hoʻonohonoho ʻia i ka manawa kākau lipine kūleʻa).

## Nā kiʻikuhi paipu

- [Nā kiʻikuhi Mermaid no ke kaʻina a me ke kūlana no A/B/C](pipeline-diagrams/README.haw.md)
