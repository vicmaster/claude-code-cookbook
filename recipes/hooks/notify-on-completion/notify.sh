#!/usr/bin/env bash
# notify.sh — Stop hook that fires an OS notification when Claude finishes a turn.
# macOS: osascript. Linux: notify-send. Other: silent no-op.

set -u

# Read the Stop payload (we don't actually need anything from it for the basic
# notification, but consume stdin so the hook protocol is satisfied).
input=$(cat)

title="${CLAUDE_NOTIFY_TITLE:-Claude Code}"
body="${CLAUDE_NOTIFY_BODY:-Task finished — your turn}"
sound="${CLAUDE_NOTIFY_SOUND:-Glass}"

case "$(uname)" in
  Darwin)
    /usr/bin/osascript -e "display notification \"$body\" with title \"$title\" sound name \"$sound\"" >/dev/null 2>&1 || true
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "$title" "$body" || true
    fi
    ;;
esac

exit 0
