#!/bin/sh

# --- User mapping: run as host user if PUID/PGID are set ---
PUID="${PUID:-0}"
PGID="${PGID:-0}"

if [ "$PUID" != "0" ]; then
  # Create group if not exists
  if ! getent group "$PGID" > /dev/null 2>&1; then
    addgroup -g "$PGID" claude
  fi
  GROUP_NAME=$(getent group "$PGID" | cut -d: -f1)

  # Create user if not exists
  if ! getent passwd "$PUID" > /dev/null 2>&1; then
    adduser -D -u "$PUID" -G "$GROUP_NAME" -h /home/claude claude
  fi
  USER_NAME=$(getent passwd "$PUID" | cut -d: -f1)
  USER_HOME=$(getent passwd "$PUID" | cut -d: -f6)

  # Ensure home directory and .claude config exist
  mkdir -p "$USER_HOME/.claude"
  chown -R "$PUID:$PGID" "$USER_HOME"

  # Set HOME for the child process
  export HOME="$USER_HOME"
fi

# If ANTHROPIC_AUTH_TOKEN is not set, fall back to CWA_LITELLM_KEY
if [ -z "$ANTHROPIC_AUTH_TOKEN" ] && [ -n "$CWA_LITELLM_KEY" ]; then
  export ANTHROPIC_AUTH_TOKEN="$CWA_LITELLM_KEY"
fi

# Skip SSL certificate verification if requested
if [ "$SKIP_SSL_VERIFY" = "1" ] || [ "$SKIP_SSL_VERIFY" = "true" ]; then
  export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

# Update Claude Code CLI before launching (skip with SKIP_UPDATE=1)
if [ "$SKIP_UPDATE" != "1" ] && [ "$SKIP_UPDATE" != "true" ]; then
  npm update -g @anthropic-ai/claude-code
fi

# Run as mapped user or root
if [ "$PUID" != "0" ]; then
  exec su-exec "$PUID:$PGID" claude "$@"
else
  exec claude "$@"
fi
