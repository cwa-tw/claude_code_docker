# 不使用 Docker 安裝 Claude Code

## 安裝

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## 串接 LiteLLM

在 `settings.json` 加入：

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://litellm.dpi.dev",
    "ANTHROPIC_AUTH_TOKEN": "sk-m535ZheYHP6CtVek4-MEdg",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "llama3.2:1b",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "llama3.2:1b",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "llama3.2:1b"
  }
}
```

## 設定檔位置

| 範圍 | 路徑 |
|---|---|
| 使用者 | `~/.claude/settings.json` |
| 專案 | `.claude/settings.json` |
| 本機（請 gitignore） | `.claude/settings.local.json` |

## 啟動

```bash
claude
```
