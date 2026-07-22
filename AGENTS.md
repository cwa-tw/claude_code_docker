# Agent Instructions for Claude Code Docker Project

## Project Overview
This project provides a Docker image (`cwa-claude-code`) that runs the Claude Code TUI, connected to a LiteLLM backend. Users get an interactive Claude Code terminal session with persistent sessions and configs.

## Key Architecture

- **Dockerfile**: Installs Claude Code CLI (`@anthropic-ai/claude-code`) on Debian-based Node.js with default `ANTHROPIC_BASE_URL=https://litellm.cwa.gov.tw`; glibc supports mounted standalone Linux CLI tools
- **entrypoint.sh**: Maps `CWA_LITELLM_KEY` → `ANTHROPIC_AUTH_TOKEN` (if `ANTHROPIC_AUTH_TOKEN` is not set), then launches `claude`
- **Environment Configuration**: LiteLLM connection managed via `-e CWA_LITELLM_KEY=...` or `--env-file .env`
- **Persistence**: User sessions and settings stored in `~/.claude` (volume-mounted from host)

## Development Workflow

### Build Docker Image
```bash
docker build -t cwa-claude-code .
```

### Run Container
```bash
docker run -it -e CWA_LITELLM_KEY=sk-xxxx -v $HOME/.claude:/root/.claude cwa-claude-code
```

### Run with `.env` file (recommended)
```bash
docker run -it --env-file .env -v $HOME/.claude:/root/.claude cwa-claude-code
```

### Run with a project directory mounted
```bash
docker run -it --env-file .env \
  -v $HOME/.claude:/root/.claude \
  -v /path/to/project:/workspace \
  cwa-claude-code
```

## Claude Code + LiteLLM Integration

- Default `ANTHROPIC_BASE_URL` is `https://litellm.cwa.gov.tw` (baked into Dockerfile)
- `CWA_LITELLM_KEY` is the primary way to pass the API key; it maps to `ANTHROPIC_AUTH_TOKEN` at container startup
- If `ANTHROPIC_AUTH_TOKEN` is explicitly set, it takes priority over `CWA_LITELLM_KEY`
- Model overrides (`ANTHROPIC_DEFAULT_OPUS_MODEL`, etc.) are optional — Anthropic defaults are used if not set
- Always manage auth tokens securely (use `.env` file, never commit tokens)
- User-level settings: `~/.claude/settings.json` (persisted via volume mount)
- Check [Anthropic docs](https://docs.anthropic.com) for Claude Code CLI features

### Required Environment Variables
```
CWA_LITELLM_KEY=sk-xxxx
```

### Optional Environment Variables
```
ANTHROPIC_BASE_URL=https://litellm.cwa.gov.tw   # override default base URL
ANTHROPIC_AUTH_TOKEN=sk-xxxx                      # overrides CWA_LITELLM_KEY
ANTHROPIC_DEFAULT_OPUS_MODEL=your-model            # optional model override
ANTHROPIC_DEFAULT_SONNET_MODEL=your-model          # optional model override
ANTHROPIC_DEFAULT_HAIKU_MODEL=your-model           # optional model override
```

## File Structure
```
.
├── Dockerfile          # Container: installs Claude Code CLI, sets entrypoint
├── entrypoint.sh       # Maps CWA_LITELLM_KEY → ANTHROPIC_AUTH_TOKEN, launches claude
├── cliff.toml          # git-cliff release-note formatting
├── pixi.toml           # Pinned release tooling used by GitLab CI
├── .gitlab-ci.yml      # Publishes matching release notes to GitLab and GitHub
├── .dockerignore       # Files to exclude from Docker build
├── .env.example        # Template for LiteLLM environment variables
├── AGENTS.md           # Agent instructions
└── README.md           # Project documentation
```

## Environment Variables
Create a `.env` file (never commit to git) based on `.env.example`:
```
CWA_LITELLM_KEY=sk-xxxx
```

Reference in Docker with `--env-file .env` flag.

## Common Tasks
- **Update Claude Code Version**: Change the npm install version in Dockerfile
- **Create a Release**: Use an exact `major.minor.patch` tag; GitLab CI uses git-cliff to publish the same notes to GitLab and CWA GitHub
- **Debug Container Issues**: Use `docker run -it --entrypoint /bin/bash` for interactive shells
- **Optimize Image Size**: Use multi-stage builds, `.dockerignore`, and Debian slim base images while retaining glibc compatibility

## Useful Links
- [Anthropic SDK Docs](https://docs.anthropic.com/docs/home)
- [Docker Docs](https://docs.docker.com/)
- [API Error Handling Guide](https://docs.anthropic.com/docs/guides/error-handling)
