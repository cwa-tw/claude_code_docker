# Dockerfile for Claude Code with LiteLLM integration
FROM node:22-slim

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

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
