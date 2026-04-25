#!/usr/bin/env bash
# Verify that managed paths under ~/.claude/ (and the repo's pre-commit hook)
# are symlinks pointing to this repository.
#
# Exit code: 0 if all entries are OK, 1 otherwise.
#
# Usage:
#   scripts/claude-check.sh [--quiet]
#     --quiet  suppress OK lines (used by the pre-commit hook)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./claude-lib.sh
. "$SCRIPT_DIR/claude-lib.sh"

QUIET=0
for arg in "$@"; do
  case "$arg" in
    --quiet) QUIET=1 ;;
    -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

failed=0

report() {
  local status="$1" path="$2" detail="${3:-}"
  if [ "$status" = "OK" ] && [ "$QUIET" -eq 1 ]; then
    return
  fi
  if [ -n "$detail" ]; then
    printf '%-9s %s  (%s)\n' "$status" "$path" "$detail"
  else
    printf '%-9s %s\n' "$status" "$path"
  fi
}

check_link() {
  local src_abs="$1" dst="$2"
  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" != "$src_abs" ]; then
      report "DIVERGED" "$dst" "-> $current, expected $src_abs"
      failed=1
    elif [ ! -e "$dst" ]; then
      report "BROKEN" "$dst" "-> $current"
      failed=1
    else
      report "OK" "$dst"
    fi
  elif [ -e "$dst" ]; then
    report "DIVERGED" "$dst" "regular file/dir, expected symlink to $src_abs"
    failed=1
  else
    report "MISSING" "$dst"
    failed=1
  fi
}

for entry in "${CLAUDE_LINKS[@]}"; do
  IFS='|' read -r src dst _type <<<"$entry"
  check_link "$REPO_ROOT/$src" "$HOME_CLAUDE/$dst"
done

check_link "$REPO_ROOT/$GIT_HOOK_SRC" "$REPO_ROOT/$GIT_HOOK_DST"

if [ "$failed" -ne 0 ]; then
  echo
  echo "claude-check: one or more entries are not OK." >&2
  echo "Run scripts/claude-setup.sh to repair." >&2
  exit 1
fi

[ "$QUIET" -eq 1 ] || echo "claude-check: all OK."
