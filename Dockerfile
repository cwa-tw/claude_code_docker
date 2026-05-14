# Dockerfile for Claude Code with LiteLLM integration
FROM node:22-alpine

# Install bash, su-exec (for user switching), and common utilities
RUN apk add --no-cache bash git curl su-exec shadow

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code && npm cache clean --force

# Default LiteLLM base URL (can be overridden via env)
ENV ANTHROPIC_BASE_URL=https://litellm.cwa.gov.tw

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Working directory for user projects (mount as needed)
WORKDIR /workspace

# Entrypoint maps CWA_LITELLM_KEY -> ANTHROPIC_AUTH_TOKEN, then launches claude
ENTRYPOINT ["/entrypoint.sh"]
