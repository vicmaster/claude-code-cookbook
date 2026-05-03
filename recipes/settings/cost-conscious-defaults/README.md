# cost-conscious-defaults

**Pain:** Surprise API bills from running every task on Opus, including ones Sonnet (or even Haiku) could handle in half the time at a fraction of the cost.
**Fix:** A `settings.json` that defaults to Sonnet for new sessions, plus a statusline that shows model + cumulative session cost in real time so you notice when a task warrants Opus.
**Time to install:** 30s

## Why this exists

Most coding tasks are well within Sonnet's capabilities. Opus shines on hard reasoning, novel architecture, and tricky debugging — but defaulting to it across the board is expensive theatre. The right move: default cheap, escalate manually when the task earns it.

The statusline makes the cost visible in your peripheral vision, so escalation decisions are informed instead of vibes-based.

## Install

```bash
# Copy the statusline script to a stable location
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Then merge settings.json into ~/.claude/settings.json
# (or copy as-is if you don't have one)
```

Restart Claude Code to pick up the new defaults.

## Files

- `settings.json` — sets `"model": "sonnet"` and registers the statusline command
- `statusline.sh` — prints a single colored line: model name, project name, session cost in USD

## Gotchas

- **Cost is estimated client-side.** Treat it as directional, not authoritative — billing truth lives in the Anthropic console.
- **Statusline runs on every render** (~every few seconds). Keep it fast — under 50ms. The shipped script is well under that.
- **Color output uses raw ANSI escapes.** Honors `NO_COLOR=1` if you've set it in your environment.
- **Switching models mid-session via `/model`** doesn't reset the cost counter — totals are per session, not per model.
- **The threshold turns the cost red at $1.00 by default.** Override with `COST_WARN_USD=2.50` in your shell env.
- **Doesn't show context-window usage** — see variations.

## Variations

- **Show context %**: extend the statusline to read `transcript_path` from the input, count tokens, divide by the model's window size
- **Per-project model**: drop a project-scoped `.claude/settings.json` with `"model": "opus"` in repos that genuinely need it (e.g., a hard refactor project)
- **Daily budget alarm**: have the statusline write each cost reading to `~/.claude/cost-history.log` and alert on cumulative daily spend
- **Pair with `/model` shortcuts**: bind `Esc-h` to switch to Haiku for quick edits, `Esc-o` to switch to Opus for hard problems
- **Hide the cost during demos**: `export COST_WARN_USD=999999` to suppress the red, or set `NO_COLOR=1` to drop ANSI entirely
