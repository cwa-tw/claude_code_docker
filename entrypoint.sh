#!/bin/sh

# If ANTHROPIC_AUTH_TOKEN is not set, fall back to CWA_LITELLM_KEY
if [ -z "$ANTHROPIC_AUTH_TOKEN" ] && [ -n "$CWA_LITELLM_KEY" ]; then
  export ANTHROPIC_AUTH_TOKEN="$CWA_LITELLM_KEY"
fi

# Skip SSL certificate verification if requested
if [ "$SKIP_SSL_VERIFY" = "1" ] || [ "$SKIP_SSL_VERIFY" = "true" ]; then
  export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

# Update Claude Code CLI before launching
npm update -g @anthropic-ai/claude-code

exec claude "$@"
