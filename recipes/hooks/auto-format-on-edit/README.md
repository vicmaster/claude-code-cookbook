# auto-format-on-edit

**Pain:** Claude edits a file, you push, CI fails on RuboCop / Prettier / Black whitespace. Five seconds of work, two minutes of red.
**Fix:** A PostToolUse hook that runs the right formatter after every `Edit` or `Write`, silently no-ops when no formatter is installed or the extension isn't recognized.
**Time to install:** 30s

## Why this exists

Formatters are too cheap to run manually and too expensive to forget. The agent already wrote the file — running `rubocop -A` or `prettier --write` on it costs milliseconds and saves a CI round-trip.

This script ships with sensible defaults for Ruby, JS/TS, JSON, CSS, Markdown, YAML, Python, Go, and Rust. Edit it to match your project's actual toolchain.

## Install

```bash
mkdir -p .claude/hooks
cp format-edited-file.sh .claude/hooks/
chmod +x .claude/hooks/format-edited-file.sh
cp settings.json .claude/settings.json   # or merge into existing
```

User-scoped: install to `~/.claude/` and update the path in `settings.json` accordingly.

## Files

- `format-edited-file.sh` — language-dispatch script
- `settings.json` — registers the hook for `Edit` and `Write`

## Gotchas

- **Requires `jq`** to parse the hook payload.
- **Silent failure is intentional** — if `rubocop` isn't installed or the file has a weird extension, the hook does nothing rather than blocking the edit. Trade-off: you won't notice if your formatter binary is missing.
- **`rubocop -A` auto-corrects.** If your team uses `rubocop -a` (safe-only) or no auto-correct, edit the script.
- **Skips files over 500KB** — formatters can hang on huge files.
- **Runs on every `Edit`/`Write`** — including ones that only change a single character. If your formatter is slow, scope the matcher (e.g. specific paths) or add a debounce.
- **Doesn't roll back failed formats.** If the formatter corrupts the file (rare but possible), Claude won't see it; you will.

## Variations

- **Project-specific formatters**: replace the case branches with your team's exact commands (e.g. `bundle exec rubocop -A` instead of bare `rubocop`)
- **Per-language hooks**: split into separate hooks with stricter matchers (e.g. only run RuboCop on `*.rb`) — slightly more config, faster execution
- **Lint instead of format**: change `rubocop -A` → `rubocop --fail-level error` and exit non-zero to surface lint errors back to the agent
- **Skip generated files**: add a guard like `[[ "$file_path" == */generated/* ]] && exit 0`
