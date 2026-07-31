# shellcheck shell=bash
# Shared definitions for claude-setup.sh and claude-check.sh.
# Source from another bash script. Do not execute directly.

if [ -z "${BASH_VERSION:-}" ]; then
  echo "claude-lib.sh requires bash" >&2
  return 1 2>/dev/null || exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOME_CLAUDE="$HOME/.claude"

# Each entry: "<repo-relative source>|<home-relative dest>|<file|dir>"
CLAUDE_LINKS=(
  "claude/CLAUDE.md|CLAUDE.md|file"
  "claude/settings.json|settings.json|file"
  "claude/statusline.sh|statusline.sh|file"
)

# Pre-commit hook: link .git/hooks/pre-commit -> repo's scripts/hooks/pre-commit
GIT_HOOK_SRC="scripts/hooks/pre-commit"
GIT_HOOK_DST=".git/hooks/pre-commit"
