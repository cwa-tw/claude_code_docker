# Dockerfile for Claude Code with LiteLLM integration
#
# Use a glibc-based image so Linux CLI tools built with PyInstaller can run
# when their project directory is mounted into /workspace.
FROM node:22-bookworm-slim

# Install bash, gosu (for user switching), and common utilities.
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates curl git gosu passwd \
    && rm -rf /var/lib/apt/lists/*

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
