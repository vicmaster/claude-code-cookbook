# Contributing

Thanks for considering a recipe. Here's the bar.

## Recipe requirements

1. **You've actually used it.** No theoretical configs.
2. **It follows the [template](recipes/_template).** Same structure for every recipe — that's the whole point of this cookbook.
3. **It's scoped.** One recipe = one pain point. Bundle = separate PRs.
4. **It's safe.** Hooks that auto-run commands need a clear gotchas section.

## How to submit

1. Fork the repo
2. Copy `recipes/_template/` to the right category folder under a kebab-case name
3. Fill in every section of the README
4. Add the actual config files alongside (`settings.json`, `<name>.md`, etc.)
5. Add a row to the relevant table in the top-level [README](README.md)
6. Open a PR

## Recipe categories

- **hooks** — `settings.json` hook configs (PreToolUse, PostToolUse, Stop, etc.)
- **slash-commands** — `.md` command files for `~/.claude/commands/` or `.claude/commands/`
- **subagents** — agent definitions for `~/.claude/agents/` or `.claude/agents/`
- **settings** — full or partial `settings.json` snippets

## Style

- Lead with pain, not config
- Use bullet lists, not paragraphs
- Show install commands, don't describe them
- If there's a gotcha, name it
