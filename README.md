# Claude Code Docker (cwa-claude-code)

容器化的 Claude Code TUI，透過 CWA LiteLLM 連線，並保留設定與工作階段。

> 不想用 Docker？請見 [NATIVE.md](./NATIVE.md)。

## 快速開始

### 1. 取得映像檔

從 GHCR 拉取（推薦）：
```bash
docker login ghcr.io
docker pull ghcr.io/cwa-tw/claude_code_docker:latest
```

或自行建置：
```bash
docker build -t cwa-claude-code .
```

### 2. 設定 API 金鑰

```bash
cp .env.example .env
# 編輯 .env，填入 CWA_LITELLM_KEY=sk-xxxx
```

### 3. 啟動

```bash
docker run -it --env-file .env \
  -e PUID=$(id -u) -e PGID=$(id -g) \
  -v $HOME/.claude:/home/claude/.claude \
  -v $HOME/.claude.json:/home/claude/.claude.json \
  ghcr.io/cwa-tw/claude_code_docker:latest
```

掛載專案目錄請加上 `-v /path/to/project:/workspace`。

映像檔以 Debian slim（glibc）為基礎，因此掛載到 `/workspace` 的
Linux x86-64 glibc CLI（例如 PyInstaller standalone bundle）可直接執行。

## 環境變數

| 變數 | 必填 | 預設值 | 說明 |
|---|---|---|---|
| `CWA_LITELLM_KEY` | **是** | — | LiteLLM API 金鑰 |
| `ANTHROPIC_AUTH_TOKEN` | 否 | — | 若設定則覆寫 `CWA_LITELLM_KEY` |
| `ANTHROPIC_BASE_URL` | 否 | `https://litellm.cwa.gov.tw` | LiteLLM 端點 |
| `ANTHROPIC_DEFAULT_{OPUS,SONNET,HAIKU}_MODEL` | 否 | Anthropic 預設 | 覆寫對應模型 |
| `PUID` / `PGID` | 否 | `0` | 以主機使用者身分執行（建議 `$(id -u)` / `$(id -g)`） |
| `SKIP_SSL_VERIFY` | 否 | — | 設 `1` 跳過 SSL 驗證 |
| `SKIP_UPDATE` | 否 | — | 設 `1` 跳過啟動時自動更新 |
| `HTTP_PROXY` / `HTTPS_PROXY` | 否 | — | 代理伺服器位址 |

## 注意事項
- 勿將 `.env` 或 API 金鑰 commit 進 git。
- 使用 `PUID`/`PGID` 時，volume 須掛到 `/home/claude/`，不是 `/root/`。
- `~/.claude` 與 `~/.claude.json` 透過 volume 保留設定與工作階段。
