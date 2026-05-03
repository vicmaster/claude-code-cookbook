#!/usr/bin/env bash
# format-edited-file.sh — PostToolUse hook that runs the right formatter after
# Claude edits a file. Silently skips when:
#   - the formatter isn't installed
#   - the extension isn't recognized
#   - the file is too large (>500KB)
#
# Customize the per-language commands below to match your project.

set -u

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

# Skip very large files — formatters get slow and rarely add value
size=$(wc -c < "$file_path" 2>/dev/null || echo 0)
[ "$size" -gt 512000 ] && exit 0

run() {
  command -v "$1" >/dev/null 2>&1 || return 0
  "$@" >/dev/null 2>&1 || true
}

case "$file_path" in
  *.rb)
    run rubocop -A --no-color "$file_path"
    ;;
  *.js|*.jsx|*.ts|*.tsx|*.json|*.css|*.scss|*.html|*.md|*.yml|*.yaml)
    run prettier --write --log-level silent "$file_path"
    ;;
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      ruff format "$file_path" >/dev/null 2>&1 || true
    elif command -v black >/dev/null 2>&1; then
      black -q "$file_path" 2>/dev/null || true
    fi
    ;;
  *.go)
    run gofmt -w "$file_path"
    ;;
  *.rs)
    run rustfmt "$file_path"
    ;;
esac

exit 0
