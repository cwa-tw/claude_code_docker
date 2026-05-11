#!/bin/sh

# If ANTHROPIC_AUTH_TOKEN is not set, fall back to CWA_LITELLM_KEY
if [ -z "$ANTHROPIC_AUTH_TOKEN" ] && [ -n "$CWA_LITELLM_KEY" ]; then
  export ANTHROPIC_AUTH_TOKEN="$CWA_LITELLM_KEY"
fi

exec claude "$@"
