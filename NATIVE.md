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
    "ANTHROPIC_BASE_URL": "https://litellm.cwa.gov.tw",
    "ANTHROPIC_AUTH_TOKEN": "sk-test-key",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "gcp_claude-opus-4-7",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "gcp_claude-sonnet-4-6",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gcp_claude-haiku-4-5"
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
