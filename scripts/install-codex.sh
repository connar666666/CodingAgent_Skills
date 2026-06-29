#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="${CODING_AGENT_SKILLS_REPO:-connar666666/CodingAgent_Skills}"
REF="${CODING_AGENT_SKILLS_REF:-main}"
SKILL_NAME="${SKILL_NAME:-python-backend-architecture}"
TARGET_ROOT="${1:-$HOME/.codex/skills}"
TARGET="$TARGET_ROOT/$SKILL_NAME"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"
LOCAL_SRC="$SCRIPT_DIR/../skills/$SKILL_NAME"
TMP_DIR=""

cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

if [ -d "$LOCAL_SRC" ]; then
  SRC="$LOCAL_SRC"
else
  if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl is required for remote installation" >&2
    exit 1
  fi
  if ! command -v tar >/dev/null 2>&1; then
    echo "[ERROR] tar is required for remote installation" >&2
    exit 1
  fi
  TMP_DIR="$(mktemp -d)"
  ARCHIVE_URL="https://github.com/$REPO_SLUG/archive/refs/heads/$REF.tar.gz"
  curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP_DIR"
  SRC="$(find "$TMP_DIR" -path "*/skills/$SKILL_NAME" -type d | head -n 1)"
  if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
    echo "[ERROR] skill not found in $REPO_SLUG@$REF: $SKILL_NAME" >&2
    exit 1
  fi
fi

mkdir -p "$TARGET_ROOT"
rm -rf "$TARGET"
if command -v rsync >/dev/null 2>&1; then
  rsync -a "$SRC/" "$TARGET/"
else
  mkdir -p "$TARGET"
  cp -R "$SRC/." "$TARGET/"
fi

echo "Installed $SKILL_NAME to $TARGET"
