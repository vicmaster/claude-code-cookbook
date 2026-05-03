# notify-on-completion

**Pain:** You kick off a 5-minute Claude task, intend to context-switch, but instead alt-tab back every 30 seconds "just in case it's done." The cost is focus.
**Fix:** A Stop hook that fires an OS notification (and optional sound) when Claude finishes a turn — go do other work, come back when it pings you.
**Time to install:** 30s

## Why this exists

The whole value of a long agent run is being able to stop watching it. A single notification at the end recovers the focus you'd otherwise burn on micro-checks.

Works on macOS (`osascript`) and Linux (`notify-send`). Silent on other platforms.

## Install

```bash
mkdir -p ~/.claude/hooks
cp notify.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/notify.sh
# Then merge settings.json into ~/.claude/settings.json
# (update the command path to ~/.claude/hooks/notify.sh if installing user-scoped)
```

Project-scoped: install into `.claude/hooks/` and use the `$CLAUDE_PROJECT_DIR` path in `settings.json` as-is.

## Files

- `notify.sh` — fires the notification; cross-platform dispatch
- `settings.json` — registers the Stop hook

## Gotchas

- **Only fires on `Stop`, not on every tool call.** That's intentional — otherwise it'd spam during long agent loops.
- **macOS sound names**: any from `/System/Library/Sounds/` (Glass, Ping, Pop, etc.). Set `CLAUDE_NOTIFY_SOUND=` (empty) to mute.
- **macOS notification permission**: first time it runs, macOS may prompt to allow notifications from `osascript`. Approve once.
- **Doesn't fire on `SubagentStop`** — only on the main agent's stop. Add a `SubagentStop` block if you want pings when subagents finish too.
- **No info about what just happened.** This is a "ding, look at me" notification, not a summary. See variations.

## Variations

- **Custom message**: `export CLAUDE_NOTIFY_BODY="ready for review"` — anything from your shell env
- **Per-project tone**: set different sounds in different `.claude/settings.json` files
- **Slack DM instead**: replace `osascript` with a `curl` to Slack's `chat.postMessage` — useful when you've left your laptop
- **Include the last assistant message**: parse `$input` (the Stop payload includes `transcript_path`) and `tail -n 1 "$transcript_path" | jq` to grab the last message preview for the body
- **Only notify on long tasks**: the Stop payload includes session info; track session start time elsewhere and skip notifications under a threshold
