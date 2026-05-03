# ship-it

**Pain:** Every PR is the same six steps — `git status`, diff, summarize, commit, push, `gh pr create`, copy URL. Six steps, ten times a day, every day.
**Fix:** A `/ship-it` slash command that does it all with sensible defaults, refuses dangerous shortcuts, and asks the absolute minimum.
**Time to install:** 30s

## Why this exists

Most of the PR ceremony is mechanical, but the parts that aren't (commit message, PR description) are exactly where humans add value. This command automates the mechanical, leaves the writing to the agent, and bakes in the safety rails (no main-branch pushes, no force-push, no committed secrets).

## Install

```bash
mkdir -p ~/.claude/commands
cp ship-it.md ~/.claude/commands/
```

Then in Claude Code: `/ship-it` (or `/ship-it Some PR title here` to set the title explicitly).

For project-scoped install, drop into `.claude/commands/` instead.

## Files

- `ship-it.md` — the slash command definition with frontmatter (`description`, `allowed-tools`)

## Gotchas

- **Requires `gh` CLI authenticated** (`gh auth login` once).
- **Refuses to push to `main`/`master`** — pair with the [block-main-branch-commits](../../hooks/block-main-branch-commits) hook for double safety.
- **One commit per invocation** — if you've made unrelated changes, the command stops and asks. That's a feature.
- **Title length capped at 70 chars** — long titles get rejected by GitHub UI rendering anyway.
- **Excludes `.env*`, `*.pem`, `credentials.*`, `*.key`, `id_rsa*` from auto-stage.** Add patterns to the command file if your secrets live elsewhere.
- **`gh` reads the default branch from the remote** — if you've renamed `main`/`master`, the command will pick it up automatically via `gh repo view`.

## Variations

- **`/ship-it draft`** → opens a draft PR (the command keys off the word `draft` in `$ARGUMENTS`)
- **Auto-link Linear/Jira ticket from branch name** — extend the body template with a `## Tickets` section that greps the branch name for `[A-Z]+-\d+`
- **Slack notification on PR open** — append `gh pr view --json url -q .url | xargs -I{} curl -X POST $SLACK_WEBHOOK ...`
- **Conventional Commits enforcement** — add a step that validates the commit message matches `(feat|fix|chore|docs|refactor|test)(\(.+\))?: .+`
