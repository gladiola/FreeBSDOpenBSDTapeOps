# FreeBSDOpenBSDTapeOps (简体中文)

使用 `mt` 和 `tar` 逐步演示常见磁带操作的交互式 shell 脚本。

## 语言文档索引

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


## 脚本

| 脚本 | 目标操作系统 |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

这两个脚本都会执行相同的操作顺序：

1. 提示用户确认磁带已装入。
2. 将磁带倒带。
3. 打印磁带状态。
4. 使用 `tar t` 列出文件位置 0、1、2 和 3 处的归档内容。
5. 使磁带离线。

每个步骤都会暂停，并等待用户按下 **Enter** 后再继续，因此这些脚本适合作为交互式演示或引导式操作流程。

## 两个脚本之间的差异

### 1. 磁带设备路径

这些脚本针对不同的磁带设备节点：

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

两者都是不自动倒带的设备节点（`n` 前缀），因此命令之间会保留磁带位置，而脚本会用 `mt rewind` 和 `mt fsf` 明确控制定位。

### 2. 装载磁带步骤

- **FreeBSD**: 启动时执行 `mt -f /dev/nsa0 load`，在倒带前以机械方式将磁带盒装入磁带机。
- **OpenBSD**: 跳过 `load` 命令，因为 OpenBSD 的 `mt(1)` 不支持 `load` 子命令。OpenBSD 脚本假定磁带已经在驱动器中，并直接进行倒带。

## OpenBSD A 到 B 到 C 日志流水线脚本

`scripts/` 目录提供了一组脚本，用于以下场景：OpenBSD 计算机 B 接收来自计算机 A 的 rsyslog 记录，按日批量整理后发送到多台计算机 C 服务器中的一台，而计算机 C 会将数据写入磁带。

| 脚本 | 用途 |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | 从计算机 B 当前活动的 rsyslog 输入文件创建每小时轮换日志。 |
| `scripts/computer-b-daily-archive.sh` | 将计算机 B 一天（`YYYYMMDD`）的每小时日志打包为带时间范围的 `.tar.gz` 归档，并排除当前小时以避免与正在写入发生冲突。 |
| `scripts/computer-b-send-archives.sh` | 通过 `scp` 将尚未发送的每日归档（`.tar.gz` 和可选的 `.tar.gz.enc`）从计算机 B 发送到一台或多台计算机 C 服务器。 |
| `scripts/computer-c-receive-archives.sh` | 验证传入的明文归档，并将明文/加密归档加入磁带队列。 |
| `scripts/computer-c-write-to-tape.sh` | 将排队中的明文或加密归档写入磁带，检查空间，安全追加，并标记为已记录。 |
| `scripts/computer-c-inventory-tape.sh` | 按文件标记打印磁带目录，使操作人员可以快速定位归档。 |
| `scripts/computer-c-restore-archive-from-tape.sh` | 扫描磁带文件位置以查找请求的归档，在需要时解密，并将恢复的数据保存到文件。 |
| `scripts/test-computer-a-b-c-integration.sh` | 运行可重复的本地 A→B→C 集成测试（包括磁带恢复），不依赖实际时钟时间。 |

典型调度：

- 在 B 上每小时运行 `computer-b-hourly-rotate.sh`（cron）。
- 在 B 上每天运行一次 `computer-b-daily-archive.sh`（cron）。
- 在创建归档后运行 `computer-b-send-archives.sh`（B 上的 cron）。
- 在 C 上定期运行 `computer-c-receive-archives.sh`。
- 在 C 上使用正确的磁带设备定期运行 `computer-c-write-to-tape.sh`。
- 当你需要逐个标记的目录时，在 C 上运行 `computer-c-inventory-tape.sh`。
- 当你需要恢复某个特定归档以便检查时，在 C 上运行 `computer-c-restore-archive-from-tape.sh`。

所有流水线脚本除了控制台输出外，还会通过 `logger` 向 syslog 发送运维消息（例如可通过 rsyslog/journaling 查看）。

### 从计算机 B 向多台服务器发送

`computer-b-send-archives.sh` 同时支持单服务器模式和多服务器模式：

- 单服务器：`computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- 多服务器：`computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

客户端服务器选择选项：

- 在参数中提供一台服务器，以固定使用某一台计算机 C。
- 提供多台服务器，以允许故障切换。
- 设置 `PREFERRED_SERVER=user@host`，从提供的列表中选择某一台特定服务器。

计算机 B 的忙状态处理选项：

- `REMOTE_BUSY_MARKER`（默认值：`.busy`）：在远端检查的标记文件。
- `BUSY_RETRY_SECONDS`（默认值：`60`）：服务器忙碌时每次重试之间的等待时间。
- `BUSY_MAX_RETRIES`（默认值：`10`）：每台服务器的最大重试次数。

### 来自计算机 C 的忙状态发布

`computer-c-write-to-tape.sh` 会在主动将归档写入磁带期间创建忙标记，并在空闲时将其移除。

- `BUSY_MARKER`（默认值：`<received_dir>/.busy`）

将计算机 B 上的 `REMOTE_BUSY_MARKER` 指向计算机 C 使用的标记位置。

### 计算机 C 上的磁带安全性与追加行为

在写入每个归档之前，`computer-c-write-to-tape.sh` 会检查可用的磁带/设备容量，并至少要求：

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

相关变量：

- `TAPE_SAFETY_MARGIN_BYTES`（默认值：`10485760`）
- `TAPE_AVAILABLE_BYTES`（覆盖已知可用空间）
- `ALLOW_UNKNOWN_TAPE_SPACE=1`（如果无法检测空间，仍允许写入）

对于真实磁带设备，写入程序会在写入前定位到数据末尾（`mt eom`/`mt eod`），因此多个归档会以追加方式写入，而不是覆盖之前的磁带内容。

### 文件名中的可读时间戳

- 每小时日志命名示例：`rsyslog-2026-06-01T1600.log`
- 每日归档命名示例：`rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

每日归档范围基于归档中实际包含的第一个和最后一个每小时文件。
这些名称旨在让查看事件日期/时间范围的人易于阅读。
当前小时会被有意排除在归档创建之外，以免传输仍在写入中的数据。

### 每日归档的可选 OpenSSL 加密

`computer-b-daily-archive.sh` 可以在创建 tarball 后使用 OpenSSL 对归档进行加密：

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` 用于对称加密（`openssl enc`，默认 cipher 为 `aes-256-gcm`）。
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` 用于接收者证书加密（`openssl smime`）。
- `OPENSSL_ENCRYPT_CIPHER` 用于在密钥文件模式和证书模式中选择 OpenSSL cipher（默认值：`aes-256-gcm`）。

这些选项同一时间只能设置一个。加密输出使用 `.tar.gz.enc`。
为保证安全，脚本会拒绝弱加密或非 AEAD 的 cipher 选择，并要求使用 GCM/poly1305 类 cipher。

### 从计算机 C 的磁带恢复归档

使用 `computer-c-restore-archive-from-tape.sh` 通过从开头开始按顺序搜索磁带文件来定位特定归档：

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- 对于 `rsyslog-<start>_to_<end>.tar.gz`（或 `.tar.gz.enc`）这类归档名称，脚本会通过检查恢复出的载荷中是否存在边界每小时文件来识别正确的匹配项。
- 如果你的归档命名方式不同，请将 `TARGET_MEMBER_GLOB` 设置为一个 shell 模式，用于匹配归档中必须存在的成员。
- 如果归档已加密，请根据需要提供解密设置：
  - `OPENSSL_DECRYPT_KEY_FILE`（对称 `openssl enc` 模式；默认解密 cipher：`aes-256-gcm`）
  - `OPENSSL_DECRYPT_CERT_FILE` 和 `OPENSSL_DECRYPT_PRIVATE_KEY_FILE`（S/MIME 解密模式）

恢复出的输出会写为明文 `.tar.gz` 文件，因此可以使用 `tar -tzf` 等工具进行检查。

### 计算机 C 上的磁带目录清单

使用 `computer-c-inventory-tape.sh` 打印逐个标记的目录：

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

输出列包括：

- `file_marker`：从零开始的磁带文件标记位置
- `status`：`ok`、`decrypted` 或 `unreadable`
- `encrypted`：检查条目时是否需要解密（`yes`/`no`）
- `archive_hint`：在可识别边界时推断出的归档式名称
- `first_member` / `last_member`：在该标记中看到的第一个和最后一个 tar 成员
- `member_count`：在该标记中找到的 tar 成员数量
- `bytes`：在该标记处读取的原始字节数

这让操作人员可以在恢复操作之前确定要定位的标记索引（`mt fsf <N>`）。

### 确定性的 A/B/C 集成测试

使用 `scripts/test-computer-a-b-c-integration.sh` 在不受经过时间影响的情况下，验证计算机 A、B 和 C 的端到端集成：

```sh
scripts/test-computer-a-b-c-integration.sh
```

此脚本会：

1. 模拟 A 写入日志。
2. 运行 B 的轮换和每日归档创建。
3. 模拟传输到 C 的 incoming。
4. 运行 C 的 receive + write-to-tape。
5. 从磁带恢复归档并验证内容。

它使用固定的日期标记（`TEST_DAY_STAMP`，默认值为 `20260101`），因此行为可重复，并且不受当前日期/时间影响。

### 为未确认数据提供安全性的 72 小时保留

这些脚本现在默认使用 72 小时的保留窗口：

- `computer-b-hourly-rotate.sh` 只有在存在匹配的本地 `.taped` 确认标记时，才会移除旧的每小时日志。
- `computer-b-send-archives.sh` 只有在同时存在 `.sent` 和本地 `.taped` 确认标记时，才会移除旧的本地归档。
- `computer-c-write-to-tape.sh` 只会移除已经具有 `.taped` 标记的旧归档。

因此，尚未成功传输并记录到磁带的文件，即使早于 `RETENTION_HOURS`（默认值 `72`），也会被保留。
在计算机 B 上，本地清理需要本地 `.taped` 标记（例如来自同步回传步骤或手动确认流程）。
在计算机 C 上，保留年龄从 `.taped` 标记的修改时间开始计算（通常设置为成功写入磁带的时间）。
