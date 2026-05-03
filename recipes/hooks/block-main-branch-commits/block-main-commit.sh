#!/usr/bin/env bash
# block-main-commit.sh — refuse `git commit` when HEAD is on a protected branch.
#
# Reads Claude Code's PreToolUse hook payload from stdin (JSON), inspects the
# Bash command, and exits 2 (with a stderr message) to block the tool call if
# the command is a `git commit` and the current branch is in PROTECTED_BRANCHES.
#
# Configure protected branches by setting the env var (default: "main master"):
#   PROTECTED_BRANCHES="main master release/*"
#
# Bypass intentionally for one shell session:
#   export ALLOW_MAIN_COMMIT=1

set -euo pipefail

# Read tool input
input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

# Only act on `git commit` (matches `git commit`, `git -C ... commit`, `git commit --amend`)
if ! printf '%s' "$command" | grep -qE '\bgit(\s+-[A-Za-z]+(\s+\S+)?)*\s+commit\b'; then
  exit 0
fi

# Explicit bypass
if [ "${ALLOW_MAIN_COMMIT:-}" = "1" ]; then
  exit 0
fi

# Resolve current branch (skip if not in a repo or detached HEAD)
branch=$(git symbolic-ref --short HEAD 2>/dev/null || true)
if [ -z "$branch" ]; then
  exit 0
fi

# Match against protected list (space-separated; supports literal globs like release/*)
protected_list="${PROTECTED_BRANCHES:-main master}"
for pattern in $protected_list; do
  case "$branch" in
    $pattern)
      cat >&2 <<EOF
Refusing to commit to protected branch '$branch'.
Create a feature branch first:  git checkout -b <branch-name>
To bypass for this session:     export ALLOW_MAIN_COMMIT=1
EOF
      exit 2
      ;;
  esac
done

exit 0
