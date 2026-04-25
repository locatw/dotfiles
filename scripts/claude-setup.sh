#!/usr/bin/env bash
# Install symlinks from ~/.claude/ -> dotfiles/claude/ and from
# .git/hooks/pre-commit -> repo's scripts/hooks/pre-commit.
#
# Usage:
#   scripts/claude-setup.sh [--dry-run] [--force]
#     --dry-run  show planned actions without modifying anything
#     --force    overwrite a symlink that points somewhere else
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./claude-lib.sh
. "$SCRIPT_DIR/claude-lib.sh"

DRY_RUN=0
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force)   FORCE=1 ;;
    -h|--help)
      sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

BACKUP_DIR="$HOME_CLAUDE/backups/dotfiles-$(date +%Y%m%d-%H%M%S)"
backup_made=0

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "DRY: $*"
  else
    "$@"
  fi
}

ensure_backup_dir() {
  if [ "$backup_made" -eq 0 ]; then
    run mkdir -p "$BACKUP_DIR"
    backup_made=1
  fi
}

backup_path() {
  local path="$1" name
  ensure_backup_dir
  name="$(basename "$path")"
  run mv "$path" "$BACKUP_DIR/$name"
  echo "  backed up to $BACKUP_DIR/$name"
}

compare_paths() {
  local a="$1" b="$2"
  if [ -d "$a" ] && [ -d "$b" ]; then
    diff -rq "$a" "$b" >/dev/null 2>&1
  elif [ -f "$a" ] && [ -f "$b" ]; then
    cmp -s "$a" "$b"
  else
    return 1
  fi
}

install_link() {
  local src_abs="$1" dst="$2"

  run mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src_abs" ]; then
      echo "skip $dst (already linked)"
      return 0
    fi
    if [ "$FORCE" -ne 1 ]; then
      echo "ERROR: $dst is a symlink to $current (use --force to overwrite)" >&2
      return 1
    fi
    echo "replacing symlink $dst -> $current"
    run rm "$dst"
  elif [ -e "$dst" ]; then
    if compare_paths "$dst" "$src_abs"; then
      echo "  unchanged (matches repo)"
    else
      echo "  DIFF: $dst differs from $src_abs" >&2
    fi
    echo "backing up existing $dst"
    backup_path "$dst"
  fi

  run ln -sfn "$src_abs" "$dst"
  echo "linked $dst -> $src_abs"
}

echo "repo: $REPO_ROOT"
echo "home: $HOME_CLAUDE"
[ "$DRY_RUN" -eq 1 ] && echo "(dry-run)"
echo

for entry in "${CLAUDE_LINKS[@]}"; do
  IFS='|' read -r src dst _type <<<"$entry"
  install_link "$REPO_ROOT/$src" "$HOME_CLAUDE/$dst"
done

echo
install_link "$REPO_ROOT/$GIT_HOOK_SRC" "$REPO_ROOT/$GIT_HOOK_DST"

if [ "$backup_made" -eq 1 ]; then
  echo
  echo "Backups stored in: $BACKUP_DIR"
fi
