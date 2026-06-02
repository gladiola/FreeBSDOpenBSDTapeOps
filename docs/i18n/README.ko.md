# FreeBSDOpenBSDTapeOps (한국어)

`mt`와 `tar`를 사용해 일반적인 자기 테이프 작업을 단계별로 안내하는 대화형 셸 스크립트입니다.

## 언어 문서 색인

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


## 스크립트

| 스크립트 | 대상 OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

두 스크립트는 동일한 작업 순서를 수행합니다:

1. 사용자에게 테이프가 로드되었는지 확인하라고 요청합니다.
2. 테이프를 되감습니다.
3. 테이프 상태를 출력합니다.
4. `tar t`를 사용해 파일 위치 0, 1, 2, 3에 있는 아카이브 내용을 나열합니다.
5. 테이프를 오프라인 상태로 전환합니다.

각 단계는 계속하기 전에 사용자가 **Enter**를 누를 때까지 일시 중지하므로, 이 스크립트들은 대화형 데모나 안내형 실습에 적합합니다.

## 두 스크립트의 차이점

### 1. 테이프 장치 경로

스크립트는 서로 다른 테이프 장치 노드를 대상으로 합니다:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

둘 다 비자동 되감기 장치 노드(`n` 접두사)이므로 명령 사이에서 테이프 위치가 유지되며, 스크립트는 `mt rewind`와 `mt fsf`로 위치를 명시적으로 제어합니다.

### 2. 테이프 로드 단계

- **FreeBSD**: 시작 시 `mt -f /dev/nsa0 load`를 실행하여 되감기 전에 테이프 카트리지를 드라이브에 기계적으로 로드합니다.
- **OpenBSD**: OpenBSD의 `mt(1)`가 `load` 하위 명령을 지원하지 않으므로 `load` 명령을 건너뜁니다. OpenBSD 스크립트는 테이프가 이미 드라이브에 있다고 가정하고 바로 되감기로 진행합니다.

## OpenBSD A-B-C 로그 파이프라인 스크립트

`scripts/` 디렉터리는 OpenBSD Computer B가 Computer A에서 rsyslog 항목을 받아 하루 단위로 묶고, 여러 Computer C 서버 중 하나로 전송하며, Computer C가 이를 테이프에 기록하는 시나리오를 위한 스크립트를 제공합니다.

| 스크립트 | 용도 |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Computer B의 활성 rsyslog 입력 파일에서 시간별로 회전된 로그를 만듭니다. |
| `scripts/computer-b-daily-archive.sh` | Computer B에서 하루(`YYYYMMDD`)치 시간별 로그를 시간 범위가 포함된 `.tar.gz` 아카이브로 묶되, 활성 쓰기 충돌을 피하기 위해 현재 시간은 제외합니다. |
| `scripts/computer-b-send-archives.sh` | `scp`를 통해 미전송 일일 아카이브(`.tar.gz` 및 선택적 `.tar.gz.enc`)를 Computer B에서 하나 이상의 Computer C 서버로 보냅니다. |
| `scripts/computer-c-receive-archives.sh` | 들어오는 평문 아카이브를 검증하고 평문/암호화 아카이브를 테이프 대기열에 넣습니다. |
| `scripts/computer-c-write-to-tape.sh` | 대기열의 평문 또는 암호화 아카이브를 테이프에 쓰고, 공간을 확인하고, 안전하게 덧붙이며, 기록됨으로 표시합니다. |
| `scripts/computer-c-inventory-tape.sh` | 운영자가 아카이브를 빠르게 찾을 수 있도록 파일 마커 기준 테이프 목차를 출력합니다. |
| `scripts/computer-c-restore-archive-from-tape.sh` | 요청한 아카이브를 찾기 위해 테이프 파일 위치를 스캔하고, 필요 시 복호화하며, 복구한 데이터를 파일로 저장합니다. |
| `scripts/test-computer-a-b-c-integration.sh` | 경과 시간에 의존하지 않는 결정적 로컬 A→B→C 통합 테스트(테이프 복구 포함)를 실행합니다. |

일반적인 스케줄링:

- B에서 `computer-b-hourly-rotate.sh`를 매시간 실행합니다(cron).
- B에서 `computer-b-daily-archive.sh`를 하루에 한 번 실행합니다(cron).
- 아카이브 생성 후 `computer-b-send-archives.sh`를 실행합니다(B의 cron).
- C에서 `computer-c-receive-archives.sh`를 주기적으로 실행합니다.
- C에서 올바른 테이프 장치와 함께 `computer-c-write-to-tape.sh`를 주기적으로 실행합니다.
- 마커별 목차가 필요할 때 C에서 `computer-c-inventory-tape.sh`를 실행합니다.
- 검사용으로 특정 아카이브를 복구해야 할 때 C에서 `computer-c-restore-archive-from-tape.sh`를 실행합니다.

모든 파이프라인 스크립트는 콘솔 출력 외에도 `logger`를 통해 syslog로 운영 메시지를 보냅니다(예: rsyslog/journaling에서 확인 가능).

### Computer B에서 다중 서버로 전송

`computer-b-send-archives.sh`는 단일 서버 모드와 다중 서버 모드를 모두 지원합니다:

- 단일 서버: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- 다중 서버: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

클라이언트 측 서버 선택 옵션:

- 인수에 서버 하나를 제공해 특정 Computer C 하나에 고정합니다.
- 여러 서버를 제공해 대체 경로를 허용합니다.
- `PREFERRED_SERVER=user@host`를 설정해 제공된 목록에서 특정 서버 하나를 선택합니다.

Computer B의 바쁨 처리 옵션:

- `REMOTE_BUSY_MARKER` (기본값: `.busy`): 원격 측에서 확인하는 마커 파일입니다.
- `BUSY_RETRY_SECONDS` (기본값: `60`): 서버가 바쁠 때 재시도 사이의 대기 시간입니다.
- `BUSY_MAX_RETRIES` (기본값: `10`): 서버당 최대 재시도 횟수입니다.

### Computer C의 바쁨 상태 게시

`computer-c-write-to-tape.sh`는 아카이브를 테이프에 적극적으로 쓰는 동안 busy 마커를 만들고, 유휴 상태가 되면 이를 제거합니다.

- `BUSY_MARKER` (기본값: `<received_dir>/.busy`)

Computer B의 `REMOTE_BUSY_MARKER`를 Computer C가 사용하는 마커 위치로 맞추십시오.

### Computer C의 테이프 안전성과 추가 동작

각 아카이브를 쓰기 전에 `computer-c-write-to-tape.sh`는 사용 가능한 테이프/장치 용량을 확인하고 최소한 다음을 요구합니다:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

관련 변수:

- `TAPE_SAFETY_MARGIN_BYTES` (기본값: `10485760`)
- `TAPE_AVAILABLE_BYTES` (알려진 가용 공간에 대한 재정의)
- `ALLOW_UNKNOWN_TAPE_SPACE=1` (공간을 감지할 수 없어도 쓰기를 허용)

실제 테이프 장치의 경우 기록기는 쓰기 전에 데이터 끝(`mt eom`/`mt eod`)으로 이동하므로, 여러 아카이브가 이전 테이프 내용을 덮어쓰지 않고 이어서 추가됩니다.

### 파일 이름의 사람이 읽기 쉬운 타임스탬프

- 시간별 로그 이름 예시: `rsyslog-2026-06-01T1600.log`
- 일일 아카이브 이름 예시: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

일일 아카이브 범위는 아카이브에 실제로 포함된 첫 번째와 마지막 시간별 파일을 기준으로 합니다.
이 이름은 이벤트 날짜/시간 구간을 살펴보는 사람이 읽기 쉽도록 의도되었습니다.
현재 시간은 활성 쓰기 데이터가 전송되지 않도록 아카이브 생성에서 의도적으로 제외됩니다.

### 일일 아카이브용 선택적 OpenSSL 암호화

`computer-b-daily-archive.sh`는 tarball을 만든 후 OpenSSL로 아카이브를 암호화할 수 있습니다:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` 는 대칭 암호화용입니다(`openssl enc`, 기본 cipher `aes-256-gcm`).
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` 는 수신자 인증서 암호화용입니다(`openssl smime`).
- `OPENSSL_ENCRYPT_CIPHER` 는 키 파일 모드와 인증서 모드 모두에서 사용할 OpenSSL cipher를 선택합니다(기본값: `aes-256-gcm`).

한 번에 이 옵션들 중 하나만 설정할 수 있습니다. 암호화 출력은 `.tar.gz.enc`를 사용합니다.
보안을 위해 스크립트는 약하거나 AEAD가 아닌 cipher 선택을 거부하고 GCM/poly1305 계열 cipher를 요구합니다.

### Computer C의 테이프에서 아카이브 복구

처음부터 순서대로 테이프 파일을 검색하여 특정 아카이브를 찾으려면 `computer-c-restore-archive-from-tape.sh`를 사용하십시오:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- `rsyslog-<start>_to_<end>.tar.gz`(또는 `.tar.gz.enc`) 같은 아카이브 이름의 경우, 스크립트는 복구한 페이로드에 경계 시간별 파일이 존재하는지 확인하여 올바른 일치 항목을 식별합니다.
- 아카이브 이름 규칙이 다르면 `TARGET_MEMBER_GLOB`를 아카이브에 반드시 존재해야 하는 멤버와 일치하는 shell 패턴으로 설정하십시오.
- 아카이브가 암호화되어 있다면 필요에 따라 복호화 설정을 제공하십시오:
  - `OPENSSL_DECRYPT_KEY_FILE` (대칭 `openssl enc` 모드, 기본 복호화 cipher: `aes-256-gcm`)
  - `OPENSSL_DECRYPT_CERT_FILE` 및 `OPENSSL_DECRYPT_PRIVATE_KEY_FILE` (S/MIME 복호화 모드)

복구된 출력은 평문 `.tar.gz` 파일로 기록되므로 `tar -tzf` 같은 도구로 검사할 수 있습니다.

### Computer C의 테이프 목차 인벤토리

`computer-c-inventory-tape.sh`를 사용해 마커별 목차를 출력하십시오:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

출력 열은 다음을 포함합니다:

- `file_marker`: 0부터 시작하는 테이프 파일 마커 위치
- `status`: `ok`, `decrypted`, 또는 `unreadable`
- `encrypted`: 항목을 검사하는 데 복호화가 필요했는지 여부 (`yes`/`no`)
- `archive_hint`: 경계를 인식할 수 있을 때 추정한 아카이브 형식 이름
- `first_member` / `last_member`: 해당 마커에서 본 첫 번째와 마지막 tar 멤버
- `member_count`: 해당 마커에서 찾은 tar 멤버 수
- `bytes`: 해당 마커에서 읽은 원시 바이트 수

이를 통해 운영자는 복구 작업 전에 이동해야 할 마커 인덱스(`mt fsf <N>`)를 식별할 수 있습니다.

### 결정적 A/B/C 통합 테스트

경과 시간과 관계없이 Computers A, B, C의 엔드투엔드 통합을 검증하려면 `scripts/test-computer-a-b-c-integration.sh`를 사용하십시오:

```sh
scripts/test-computer-a-b-c-integration.sh
```

이 스크립트는 다음을 수행합니다:

1. A가 로그를 쓰는 동작을 시뮬레이션합니다.
2. B의 로테이션과 일일 아카이브 생성을 실행합니다.
3. C의 incoming으로 전송되는 과정을 시뮬레이션합니다.
4. C의 receive + write-to-tape를 실행합니다.
5. 테이프에서 아카이브를 복구하고 내용을 검증합니다.

이 스크립트는 고정된 일자 스탬프(`TEST_DAY_STAMP`, 기본값 `20260101`)를 사용하므로 동작을 반복 가능하게 만들며 현재 날짜/시간에 묶이지 않습니다.

### 확인되지 않은 데이터를 안전하게 보호하는 72시간 보존

이제 스크립트의 기본 보존 기간은 72시간입니다:

- `computer-b-hourly-rotate.sh`는 일치하는 로컬 `.taped` 확인 마커가 있을 때만 오래된 시간별 로그를 제거합니다.
- `computer-b-send-archives.sh`는 `.sent`와 로컬 `.taped` 확인 마커가 모두 있을 때만 오래된 로컬 아카이브를 제거합니다.
- `computer-c-write-to-tape.sh`는 이미 `.taped` 마커가 있는 오래된 아카이브만 제거합니다.

그 결과 아직 성공적으로 전송되어 테이프에 기록되지 않은 파일은 `RETENTION_HOURS`(기본값 `72`)보다 오래되었더라도 유지됩니다.
Computer B에서는 로컬 정리에 로컬 `.taped` 마커가 필요합니다(예: sync-back 단계나 수동 확인 절차에서 생성).
Computer C에서는 보존 기간이 `.taped` 마커 수정 시각부터 계산됩니다(보통 성공적으로 테이프에 쓴 시각으로 설정됨).

## 파이프라인 다이어그램

- [A/B/C Mermaid 시퀀스 및 상태 다이어그램](pipeline-diagrams/README.ko.md)
