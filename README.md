# Claude Code Docker (cwa-claude-code)

將 Claude Code TUI 容器化，透過 CWA LiteLLM 連線。使用者可取得互動式 Claude Code 終端機，並保留設定與工作階段。

## 快速開始

### 1. 建置 Docker 映像檔
```bash
docker build -t cwa-claude-code .
```

### 2. 啟動 Claude Code TUI
```bash
docker run -it -e CWA_LITELLM_KEY=sk-xxxx -v $HOME/.claude:/root/.claude -v $HOME/.claude.json:/root/.claude.json cwa-claude-code
```

- `-it` — 互動式終端機（TUI 必要）
- `-e CWA_LITELLM_KEY=sk-xxxx` — 你的 CWA LiteLLM API 金鑰
- `-v $HOME/.claude:/root/.claude` — 在多次執行間保留使用者工作階段與設定

### 建議：使用 `.env` 檔案保管 API 金鑰
```bash
cp .env.example .env
# 編輯 .env，填入 CWA_LITELLM_KEY=sk-xxxx
```

```bash
docker run -it --env-file .env -v $HOME/.claude:/root/.claude -v $HOME/.claude.json:/root/.claude.json cwa-claude-code
```

### 選擇性：掛載專案目錄
```bash
docker run -it --env-file .env -v $HOME/.claude:/root/.claude -v $HOME/.claude.json:/root/.claude.json -v /path/to/project:/workspace cwa-claude-code
```

## 環境變數

| 變數 | 必填 | 預設值 | 說明 |
|---|---|---|---|
| `CWA_LITELLM_KEY` | **是** | — | CWA LiteLLM API 金鑰（對應至 `ANTHROPIC_AUTH_TOKEN`） |
| `ANTHROPIC_AUTH_TOKEN` | 否 | — | 若設定此值，將優先使用，`CWA_LITELLM_KEY` 會被忽略 |
| `ANTHROPIC_BASE_URL` | 否 | `https://litellm.cwa.gov.tw` | LiteLLM 端點 URL |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | 否 | Anthropic 預設 | 覆寫 Opus 模型 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | 否 | Anthropic 預設 | 覆寫 Sonnet 模型 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | 否 | Anthropic 預設 | 覆寫 Haiku 模型 |
| `SKIP_SSL_VERIFY` | 否 | — | 設為 `1` 跳過 SSL 憑證驗證（解決企業代理或自簽憑證問題） |
| `SKIP_UPDATE` | 否 | — | 設為 `1` 跳過啟動時自動更新 Claude Code CLI |
| `HTTP_PROXY` | 否 | — | HTTP 代理伺服器位址（例如 `http://proxy:8080`） |
| `HTTPS_PROXY` | 否 | — | HTTPS 代理伺服器位址（例如 `http://proxy:8080`） |

## 使用者層級設定

Claude Code 會讀取 `~/.claude/settings.json`。此檔案透過 volume mount 保留。

## 注意事項
- 切勿將 `.env` 或真實 API 金鑰提交至 git。
- `~/.claude` 及 `~/.claude.json` 的 volume mount 可在容器重啟間保留所有工作階段、歷史紀錄與設定。
