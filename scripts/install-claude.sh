#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="${CODING_AGENT_SKILLS_REPO:-connar666666/CodingAgent_Skills}"
REF="${CODING_AGENT_SKILLS_REF:-main}"
SKILL_NAME="${SKILL_NAME:-python-backend-architecture}"
TARGET_ROOT="${1:-$HOME/.claude/skills}"
TARGET="$TARGET_ROOT/$SKILL_NAME"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"
LOCAL_SRC="$SCRIPT_DIR/../skills/$SKILL_NAME"

install_from_local() {
  mkdir -p "$TARGET_ROOT"
  rm -rf "$TARGET"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$LOCAL_SRC/" "$TARGET/"
  else
    mkdir -p "$TARGET"
    cp -R "$LOCAL_SRC/." "$TARGET/"
  fi
}

install_from_github_raw() {
  if [ "$SKILL_NAME" != "python-backend-architecture" ]; then
    echo "[ERROR] remote install currently supports python-backend-architecture only" >&2
    echo "        clone the repository for other skills: https://github.com/$REPO_SLUG" >&2
    exit 1
  fi
  if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl is required for remote installation" >&2
    exit 1
  fi

  local raw_base="https://raw.githubusercontent.com/$REPO_SLUG/$REF/skills/$SKILL_NAME"
  local files=(
    "SKILL.md"
    "references/acceptance-gates.md"
    "references/architecture-blueprint.md"
    "references/implementation-flow.md"
    "references/refactor-signals.md"
    "references/review-checklist.md"
  )

  rm -rf "$TARGET"
  mkdir -p "$TARGET/references"
  for file in "${files[@]}"; do
    mkdir -p "$TARGET/$(dirname "$file")"
    curl -fsSL "$raw_base/$file" -o "$TARGET/$file"
  done
}

if [ -d "$LOCAL_SRC" ]; then
  install_from_local
else
  install_from_github_raw
fi

echo "Installed $SKILL_NAME to $TARGET"
