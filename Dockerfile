# Dockerfile for Claude Code with LiteLLM integration
FROM node:22-alpine

# Install bash and other common shell utilities needed by Claude Code
RUN apk add --no-cache bash git curl

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code && npm cache clean --force

# Create directory for persistent Claude config/sessions
RUN mkdir -p /root/.claude

# Default LiteLLM base URL (can be overridden via env)
ENV ANTHROPIC_BASE_URL=https://litellm.cwa.gov.tw

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Volumes for persistence:
#   /root/.claude  - user sessions, settings, and config
VOLUME ["/root/.claude"]

# Working directory for user projects (mount as needed)
WORKDIR /workspace

# Entrypoint maps CWA_LITELLM_KEY -> ANTHROPIC_AUTH_TOKEN, then launches claude
ENTRYPOINT ["/entrypoint.sh"]
