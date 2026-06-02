# FreeBSDOpenBSDTapeOps (日本語)

`mt` と `tar` を使って一般的な磁気テープ操作を順を追って案内する対話型シェルスクリプトです。

## 言語ドキュメント索引

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


## スクリプト

| スクリプト | 対象 OS |
|---|---|
| `scriptedDemo.sh` | FreeBSD |
| `scriptedDemo_openbsd.sh` | OpenBSD |

両方のスクリプトは、同じ一連の操作を実行します:

1. テープがロードされていることを確認するようユーザーに促します。
2. テープを巻き戻します。
3. テープの状態を表示します。
4. `tar t` を使ってファイル位置 0、1、2、3 にあるアーカイブの内容を一覧表示します。
5. テープをオフラインにします。

各手順は続行前にユーザーが **Enter** を押すまで一時停止するため、対話型デモやガイド付きウォークスルーに適しています。

## 2 つのスクリプトの違い

### 1. テープデバイスパス

このスクリプトは異なるテープデバイスノードを対象とします:

- **FreeBSD** (`scriptedDemo.sh`): `/dev/nsa0`
- **OpenBSD** (`scriptedDemo_openbsd.sh`): `/dev/nrst0`

どちらも非巻き戻しデバイスノード（`n` 接頭辞）なので、コマンド間でテープ位置が保持され、スクリプトは `mt rewind` と `mt fsf` で位置を明示的に制御します。

### 2. テープのロード手順

- **FreeBSD**: 起動時に `mt -f /dev/nsa0 load` を実行し、巻き戻す前にテープカートリッジを機械的にドライブへロードします。
- **OpenBSD**: OpenBSD の `mt(1)` は `load` サブコマンドをサポートしていないため、`load` コマンドを省略します。OpenBSD 用スクリプトは、テープがすでにドライブに入っているものとして、そのまま巻き戻しに進みます。

## OpenBSD A→B→C ログパイプラインスクリプト

`scripts/` ディレクトリには、OpenBSD Computer B が Computer A から rsyslog エントリを受け取り、それらを日次でまとめ、複数ある Computer C サーバーのいずれか 1 台へ送信し、Computer C がそれらをテープに書き込むというシナリオ向けのスクリプトが用意されています。

| スクリプト | 用途 |
|---|---|
| `scripts/computer-b-hourly-rotate.sh` | Computer B のアクティブな rsyslog 入力ファイルから、時間ごとにローテートされたログを作成します。 |
| `scripts/computer-b-daily-archive.sh` | Computer B 上の 1 日分（`YYYYMMDD`）の時間別ログを、現在の時間を除外して、時間範囲付きの `.tar.gz` アーカイブにまとめます。これはアクティブな書き込み競合を避けるためです。 |
| `scripts/computer-b-send-archives.sh` | 未送信の日次アーカイブ（`.tar.gz` と任意の `.tar.gz.enc`）を `scp` 経由で Computer B から 1 台以上の Computer C サーバーへ送信します。 |
| `scripts/computer-c-receive-archives.sh` | 受信した平文アーカイブを検証し、平文/暗号化アーカイブをテープ向けキューに入れます。 |
| `scripts/computer-c-write-to-tape.sh` | キューに入った平文または暗号化アーカイブをテープに書き込み、空き容量を確認し、安全に追記して、記録済みとしてマークします。 |
| `scripts/computer-c-inventory-tape.sh` | オペレーターがアーカイブをすばやく見つけられるよう、ファイルマーカー単位のテープ目次を表示します。 |
| `scripts/computer-c-restore-archive-from-tape.sh` | 要求されたアーカイブを探すためにテープファイル位置を走査し、必要に応じて復号し、復旧したデータをファイルに保存します。 |
| `scripts/test-computer-a-b-c-integration.sh` | 経過時間に依存しない決定的なローカル A→B→C 統合テスト（テープ復元を含む）を実行します。 |

一般的なスケジューリング:

- B で `computer-b-hourly-rotate.sh` を毎時実行します（cron）。
- B で `computer-b-daily-archive.sh` を 1 日 1 回実行します（cron）。
- アーカイブ作成後に `computer-b-send-archives.sh` を実行します（B の cron）。
- C で `computer-c-receive-archives.sh` を定期実行します。
- C で正しいテープデバイスを指定して `computer-c-write-to-tape.sh` を定期実行します。
- マーカーごとの目次が必要なときは C で `computer-c-inventory-tape.sh` を実行します。
- 調査のために特定のアーカイブを復元する必要があるときは C で `computer-c-restore-archive-from-tape.sh` を実行します。

すべてのパイプラインスクリプトは、コンソール出力に加えて、`logger` を通じて syslog に運用メッセージも送信します（たとえば rsyslog/journaling で確認できます）。

### Computer B からの複数サーバー送信

`computer-b-send-archives.sh` は単一サーバーモードと複数サーバーモードの両方をサポートします:

- 単一サーバー: `computer-b-send-archives.sh <archive_dir> <user@host> <remote_dir>`
- 複数サーバー: `computer-b-send-archives.sh <archive_dir> <remote_dir> <user@host> [user@host...]`

クライアント側のサーバー選択オプション:

- 引数でサーバーを 1 台指定すると、特定の Computer C 1 台に固定できます。
- 複数のサーバーを指定すると、フォールバックを許可できます。
- `PREFERRED_SERVER=user@host` を設定すると、指定した一覧の中から特定のサーバー 1 台を選べます。

Computer B 側のビジー処理オプション:

- `REMOTE_BUSY_MARKER`（デフォルト: `.busy`）: リモート側で確認するマーカーファイルです。
- `BUSY_RETRY_SECONDS`（デフォルト: `60`）: サーバーがビジーの間に再試行するまでの待機時間です。
- `BUSY_MAX_RETRIES`（デフォルト: `10`）: サーバーごとの最大再試行回数です。

### Computer C からのビジー状態公開

`computer-c-write-to-tape.sh` は、アーカイブをテープへ積極的に書き込んでいる間はビジーマーカーを作成し、アイドル時にはそれを削除します。

- `BUSY_MARKER`（デフォルト: `<received_dir>/.busy`）

Computer B の `REMOTE_BUSY_MARKER` を、Computer C が使用するマーカーの場所に合わせてください。

### Computer C におけるテープ安全性と追記動作

各アーカイブを書き込む前に、`computer-c-write-to-tape.sh` は利用可能なテープ/デバイス容量を確認し、少なくとも次を必要とします:

`archive_size + TAPE_SAFETY_MARGIN_BYTES`

関連する変数:

- `TAPE_SAFETY_MARGIN_BYTES`（デフォルト: `10485760`）
- `TAPE_AVAILABLE_BYTES`（既知の利用可能容量を上書き）
- `ALLOW_UNKNOWN_TAPE_SPACE=1`（容量を検出できなくても書き込みを許可）

実際のテープデバイスでは、ライターは書き込む前にデータ終端（`mt eom`/`mt eod`）へ移動するため、複数のアーカイブは以前のテープ内容を上書きせず追記されます。

### ファイル名内の人が読みやすいタイムスタンプ

- 時間ごとのログ名の例: `rsyslog-2026-06-01T1600.log`
- 日次アーカイブ名の例: `rsyslog-2026-06-01T0000_to_2026-06-01T2300.tar.gz`

日次アーカイブの範囲は、アーカイブに実際に含まれる最初と最後の時間別ファイルに基づきます。
これらの名前は、イベントの日付/時刻範囲を確認する人が読みやすいよう意図されています。
現在の時間は、書き込み中のデータが送信されないよう、意図的にアーカイブ作成から除外されます。

### 日次アーカイブ向けの任意の OpenSSL 暗号化

`computer-b-daily-archive.sh` は、tarball 作成後に OpenSSL でアーカイブを暗号化できます:

- `OPENSSL_ENCRYPT_KEY_FILE=/path/to/keyfile` は共通鍵暗号化用です（`openssl enc`、デフォルト cipher は `aes-256-gcm`）。
- `OPENSSL_ENCRYPT_CERT_FILE=/path/to/cert.pem` は受信者証明書暗号化用です（`openssl smime`）。
- `OPENSSL_ENCRYPT_CIPHER` は、キーファイル方式と証明書方式の両方で使う OpenSSL cipher を選択します（デフォルト: `aes-256-gcm`）。

これらのオプションは同時に 1 つだけ設定できます。暗号化出力には `.tar.gz.enc` を使用します。
セキュリティのため、このスクリプトは弱い cipher や AEAD ではない cipher の選択を拒否し、GCM/poly1305 系の cipher を必須とします。

### Computer C のテープからのアーカイブ復元

先頭から順にテープファイルを検索して特定のアーカイブを見つけるには、`computer-c-restore-archive-from-tape.sh` を使用します:

```sh
scripts/computer-c-restore-archive-from-tape.sh <tape_device> <archive_name> <output_file>
```

- `rsyslog-<start>_to_<end>.tar.gz`（または `.tar.gz.enc`）のようなアーカイブ名については、復元したペイロードに境界となる時間別ファイルが存在することを確認して、正しい一致を特定します。
- アーカイブ命名が異なる場合は、`TARGET_MEMBER_GLOB` を、アーカイブ内に必ず存在すべきメンバーに一致する shell パターンに設定してください。
- アーカイブが暗号化されている場合は、必要に応じて復号設定を指定してください:
  - `OPENSSL_DECRYPT_KEY_FILE`（共通鍵 `openssl enc` モード、デフォルト復号 cipher: `aes-256-gcm`）
  - `OPENSSL_DECRYPT_CERT_FILE` と `OPENSSL_DECRYPT_PRIVATE_KEY_FILE`（S/MIME 復号モード）

復元された出力は平文の `.tar.gz` ファイルとして書き出されるため、`tar -tzf` のようなツールで確認できます。

### Computer C のテープ目次インベントリ

`computer-c-inventory-tape.sh` を使って、マーカーごとの目次を表示します:

```sh
scripts/computer-c-inventory-tape.sh <tape_device>
```

出力列には次が含まれます:

- `file_marker`: 0 始まりのテープファイルマーカー位置
- `status`: `ok`、`decrypted`、または `unreadable`
- `encrypted`: エントリの確認に復号が必要だったかどうか（`yes`/`no`）
- `archive_hint`: 境界を認識できる場合に推定されるアーカイブ形式の名前
- `first_member` / `last_member`: そのマーカーで見つかった最初と最後の tar メンバー
- `member_count`: そのマーカーで見つかった tar メンバー数
- `bytes`: そのマーカーで読み取った生バイト数

これにより、オペレーターは復元操作の前にシークすべきマーカー番号（`mt fsf <N>`）を特定できます。

### 決定的な A/B/C 統合テスト

経過時間に関係なく Computers A、B、C のエンドツーエンド統合を検証するには、`scripts/test-computer-a-b-c-integration.sh` を使用します:

```sh
scripts/test-computer-a-b-c-integration.sh
```

このスクリプトは:

1. A がログを書き込む動作をシミュレートします。
2. B のローテーションと日次アーカイブ作成を実行します。
3. C の incoming への転送をシミュレートします。
4. C の receive + write-to-tape を実行します。
5. テープからアーカイブを復元し、内容を検証します。

固定の日付スタンプ（`TEST_DAY_STAMP`、デフォルト `20260101`）を使用するため、挙動は再現可能であり、現在の日付/時刻に左右されません。

### 未確認データを安全に保つ 72 時間保持

これらのスクリプトは現在、デフォルトで 72 時間の保持期間を使用します:

- `computer-b-hourly-rotate.sh` は、一致するローカル `.taped` 確認マーカーが存在する場合にのみ、古い時間別ログを削除します。
- `computer-b-send-archives.sh` は、`.sent` とローカル `.taped` 確認マーカーの両方が存在する場合にのみ、古いローカルアーカイブを削除します。
- `computer-c-write-to-tape.sh` は、すでに `.taped` マーカーがある古いアーカイブだけを削除します。

その結果、まだ正常に送信されてテープへ記録されていないファイルは、`RETENTION_HOURS`（デフォルト `72`）より古くても保持されます。
Computer B では、ローカルのクリーンアップにローカル `.taped` マーカーが必要です（たとえば sync-back ステップや手動確認プロセスから得られるもの）。
Computer C では、保持期間は `.taped` マーカーの更新時刻から測定されます（通常はテープ書き込み成功時刻に設定されます）。

## パイプライン図

- [A/B/C Mermaid シーケンス図と状態図](pipeline-diagrams/README.ja.md)
