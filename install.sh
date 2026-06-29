#!/usr/bin/env bash
set -euo pipefail

AGENT="${1:-codex}"
shift || true

case "$AGENT" in
  codex)
    curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/scripts/install-codex.sh | bash -s -- "$@"
    ;;
  claude|claude-code)
    curl -fsSL https://raw.githubusercontent.com/connar666666/CodingAgent_Skills/main/scripts/install-claude.sh | bash -s -- "$@"
    ;;
  *)
    echo "Usage: install.sh [codex|claude] [target-skills-root]" >&2
    exit 1
    ;;
esac
