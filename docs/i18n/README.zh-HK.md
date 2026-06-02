# FreeBSDOpenBSDTapeOps (繁體中文（香港）)

使用 `mt` 和 `tar` 逐步示範常見磁帶操作的互動式 shell 腳本。

## 語言文件索引

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


## 腳本

| 腳本 | 目標作業系統 |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

兩個腳本都會執行相同的操作順序：

1. 提示使用者確認磁帶已載入。
2. 將磁帶倒帶。
3. 列印磁帶狀態。
4. 使用 `tar t` 列出檔案位置 0、1、2 和 3 的封存內容。
5. 讓磁帶離線。

每個步驟都會暫停，並等待使用者按下 **Enter** 後才繼續，因此這些腳本適合作為互動式示範或引導式操作流程。

## 兩個腳本之間的差異

### 1. 磁帶裝置路徑

這些腳本會針對不同的磁帶裝置節點：

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

兩者都是不自動倒帶的裝置節點（`n` 前綴），因此命令之間會保留磁帶位置，而腳本會以 `mt rewind` 和 `mt fsf` 明確控制定位。

### 2. 載入磁帶步驟

- **FreeBSD**: 在啟動時執行 `mt -f /dev/nsa0 load`，在倒帶之前以機械方式將磁帶匣載入磁帶機。
- **OpenBSD**: 略過 `load` 指令，因為 OpenBSD 的 `mt(1)` 不支援 `load` 子指令。OpenBSD 腳本假設磁帶已經在磁帶機中，並直接進行倒帶。

## OpenBSD A 至 B 至 C 日誌管線腳本

`scripts/` 目錄提供一組腳本，用於以下情境：OpenBSD 電腦 B 接收來自電腦 A 的 rsyslog 記錄，按日批次整理後傳送到多部電腦 C 伺服器中的其中一部，而電腦 C 會將資料寫入磁帶。

| 腳本 | 用途 |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | 從電腦 B 目前使用中的 rsyslog 輸入檔建立每小時輪替日誌。 |
| `scripts/computer-b-daily-archive.sh` | 將電腦 B 一天（`YYYYMMDD`）的每小時日誌打包成具有時間範圍的 `.tar.gz` 封存，並排除目前小時以避免與正在寫入衝突。 |
| `scripts/computer-b-send-archives.sh` | 透過 `scp` 將尚未傳送的每日封存（`.tar.gz` 及可選的 `.tar.gz.enc`）從電腦 B 傳送到一部或多部電腦 C 伺服器。 |
| `scripts/computer-c-receive-archives.sh` | 驗證傳入的明文封存，並將明文／加密封存排入寫入磁帶佇列。 |
| `scripts/computer-c-write-to-tape.sh` | 將已排隊的明文或加密封存寫入磁帶，檢查空間，安全追加，並標記為已記錄。 |
| `scripts/computer-c-inventory-tape.sh` | 按檔案標記列印磁帶目錄，讓操作人員可快速定位封存。 |
| `scripts/computer-c-restore-archive-from-tape.sh` | 掃描磁帶檔案位置以尋找指定封存，在需要時解密，並將恢復的資料儲存到檔案。 |
| `scripts/test-computer-a-b-c-integration.sh` | 執行可重現的本機 A→B→C 整合測試（包括磁帶恢復），不依賴實際時鐘時間。 |

典型排程：

- 在 B 上每小時執行 `computer-b-hourly-rotate.sh`（cron）。
- 在 B 上每天執行一次 `computer-b-daily-archive.sh`（cron）。
- 在建立封存後執行 `computer-b-send-archives.sh`（cron 於 B 上）。
- 在 C 上定期執行 `computer-c-receive-archives.sh`。
- 在 C 上以正確的磁帶裝置定期執行 `computer-c-write-to-tape.sh`。
- 當你需要逐個標記的目錄時，在 C 上執行 `computer-c-inventory-tape.sh`。
- 當你需要恢復特定封存以供檢查時，在 C 上執行 `computer-c-restore-archive-from-tape.sh`。

所有管線腳本除主控台輸出外，也會透過 `logger` 將操作訊息送到 syslog（例如可透過 rsyslog/journaling 查看）。

### 從電腦 B 傳送到多部伺服器

`computer-b-send-archives.sh` 同時支援單伺服器模式和多伺服器模式：

- 單伺服器：`computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- 多伺服器：`computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

用戶端伺服器選擇選項：

- 在參數中提供一台伺服器，以固定使用某一台電腦 C。
- 提供多台伺服器，以允許故障切換。
- 設定 `PREFERRED_SERVER=user@host`，從提供的清單中選擇某一台特定伺服器。

電腦 B 的忙碌處理選項：

- `REMOTE_BUSY_MARKER`（預設：`.busy`）：在遠端端檢查的標記檔案。
- `BUSY_RETRY_SECONDS`（預設：`60`）：伺服器忙碌時每次重試之間的等待時間。
- `BUSY_MAX_RETRIES`（預設：`10`）：每台伺服器的最大重試次數。

### 來自電腦 C 的忙碌狀態發佈

`computer-c-write-to-tape.sh` 會在主動將封存寫入磁帶期間建立忙碌標記，閒置時則移除它。

- `BUSY_MARKER`（預設：`<received_dir>/.busy`）

將電腦 B 上的 `REMOTE_BUSY_MARKER` 指向電腦 C 使用的標記位置。

### 電腦 C 上的磁帶安全性與追加行為

在寫入每個封存之前，`computer-c-write-to-tape.sh` 會檢查可用的磁帶／裝置容量，並至少要求：

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

相關變數：

- `TAPE_SAFETY_MARGIN_BYTES`（預設：`10485760`）
- `TAPE_AVAILABLE_BYTES`（覆寫已知可用空間）
- `ALLOW_UNKNOWN_TAPE_SPACE=1`（若無法偵測空間，仍允許寫入）

對真正的磁帶裝置而言，寫入器會在寫入前先尋找資料末端（`mt eom`/`mt eod`），因此多個封存會以追加方式寫入，而不會覆寫先前的磁帶內容。

### 檔案名稱中的人類可讀時間戳

- 每小時日誌命名示例：`rsyslog-2026-06-01T1600.log`
- 每日封存命名示例：`rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

每日封存的範圍是根據實際包含在封存中的第一個與最後一個每小時檔案而定。
這些名稱旨在讓查看事件日期／時間範圍的人容易閱讀。
目前小時會刻意排除在封存建立之外，以免傳送仍在寫入中的資料。

### 每日封存的可選 OpenSSL 加密

`computer-b-daily-archive.sh` 可在建立 tarball 後使用 OpenSSL 加密封存：

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` 用於對稱式加密（`openssl enc`，預設 cipher 為 `aes-256-gcm`）。
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` 用於收件者憑證加密（`openssl smime`）。
- `OPENSSL_ENCRYPT_CIPHER` 用於在金鑰檔模式與憑證模式中選擇 OpenSSL cipher（預設：`aes-256-gcm`）。

同一時間只可設定其中一個選項。加密輸出使用 `.tar.gz.enc`。
為確保安全，腳本會拒絕弱加密或非 AEAD 的 cipher 選擇，並要求使用 GCM/poly1305 類 cipher。

### 從電腦 C 的磁帶恢復封存

使用 `computer-c-restore-archive-from-tape.sh` 透過由開頭開始按順序搜尋磁帶檔案，來定位特定封存：

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- 對於 `rsyslog-<start>_to_<end>.tar.gz`（或 `.tar.gz.enc`）之類的封存名稱，腳本會藉由檢查恢復出的載荷中是否存在邊界每小時檔案，來識別正確的匹配項。
- 如果你的封存命名方式不同，請將 `TARGET_MEMBER_GLOB` 設為一個 shell 模式，以匹配封存中必須存在的成員。
- 如果封存已加密，請按需要提供解密設定：
  - `OPENSSL_DECRYPT_KEY_FILE`（對稱式 `openssl enc` 模式；預設解密 cipher：`aes-256-gcm`）
  - `OPENSSL_DECRYPT_CERT_FILE` 和 `OPENSSL_DECRYPT_PRIVATE_KEY_FILE`（S/MIME 解密模式）

恢復出的輸出會寫成明文 `.tar.gz` 檔案，因此可使用 `tar -tzf` 等工具進行檢查。

### 電腦 C 上的磁帶目錄清單

使用 `computer-c-inventory-tape.sh` 列印逐個標記的目錄：

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

輸出欄位包括：

- `file_marker`：以零為起點的磁帶檔案標記位置
- `status`：`ok`、`decrypted` 或 `unreadable`
- `encrypted`：檢查項目時是否需要解密（`yes`/`no`）
- `archive_hint`：當可識別邊界時推斷出的封存式名稱
- `first_member` / `last_member`：在該標記中看到的第一個與最後一個 tar 成員
- `member_count`：在該標記中找到的 tar 成員數量
- `bytes`：在該標記讀取的原始位元組數

這讓操作人員可在恢復操作之前識別要尋找的標記索引（`mt fsf <N>`）。

### 決定性的 A/B/C 整合測試

使用 `scripts/test-computer-a-b-c-integration.sh` 在不論經過時間多少的情況下，驗證電腦 A、B 和 C 的端對端整合：

```sh
scripts/test-computer-a-b-c-integration.sh
```

此腳本會：

1. 模擬 A 寫入日誌。
2. 執行 B 的輪替與每日封存建立。
3. 模擬傳輸到 C 的 incoming。
4. 執行 C 的 receive + write-to-tape。
5. 從磁帶恢復封存並驗證內容。

它使用固定的日期標記（`TEST_DAY_STAMP`，預設 `20260101`），因此行為可重現，且不受目前日期／時間影響。

### 為未確認資料提供安全性的 72 小時保留

這些腳本現在預設使用 72 小時的保留視窗：

- `computer-b-hourly-rotate.sh` 只有在存在對應的本地 `.taped` 確認標記時，才會移除舊的每小時日誌。
- `computer-b-send-archives.sh` 只有在同時存在 `.sent` 與本地 `.taped` 確認標記時，才會移除舊的本地封存。
- `computer-c-write-to-tape.sh` 只會移除已經具有 `.taped` 標記的舊封存。

因此，尚未成功傳送並記錄到磁帶的檔案，即使早於 `RETENTION_HOURS`（預設 `72`），仍會被保留。
在電腦 B 上，本地清理需要本地 `.taped` 標記（例如來自同步回傳步驟或手動確認流程）。
在電腦 C 上，保留年齡會從 `.taped` 標記的修改時間起計（通常設為成功寫入磁帶的時間）。

## 管線圖

- [A/B/C Mermaid 序列圖與狀態圖](pipeline-diagrams/README.zh-HK.md)
