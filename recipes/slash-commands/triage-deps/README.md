# triage-deps

**Pain:** The Dependabot PR backlog. You keep meaning to get to it. It keeps growing. Each PR needs a 30-second judgement call but there are 40 of them.
**Fix:** A `/triage-deps` slash command that lists open Dependabot PRs, classifies each by semver risk, flags security advisories, and outputs a sorted Markdown table — read-only, no merges.
**Time to install:** 30s

## Why this exists

Dependabot is great at opening PRs and bad at telling you which ones matter. This command turns "I'll deal with it later" into a concrete, prioritized list — the kind a human can act on in 5 minutes instead of 50.

## Install

```bash
mkdir -p ~/.claude/commands
cp triage-deps.md ~/.claude/commands/
```

Then in Claude Code (from inside any GitHub repo): `/triage-deps`, or `/triage-deps ruby` to filter by label.

## Files

- `triage-deps.md` — the slash command definition

## Gotchas

- **Requires `gh` CLI authenticated** with read access to the repo's PRs.
- **Read-only by design.** A separate "auto-merger" recipe is planned (`dependabot-triage-bot`, Week 11 of the roadmap) for actually clicking merge. This one only sorts.
- **Capped at 100 PRs** — if your backlog is bigger than that, narrow with `--label` first.
- **Pre-1.0 packages**: any minor bump on a 0.X package is treated as major (semver doesn't apply below 1.0). Surprises some users; reflects reality.
- **Doesn't read changelogs.** Just titles and bodies. A PR labeled "patch" could still introduce breaking changes — risk classification is heuristic, not authoritative.
- **`GHSA-` matching is loose** — false positives possible if a non-security PR happens to mention an advisory in passing.

## Variations

- **Slack output**: pipe the table into a `chat.postMessage` call to your dependencies channel
- **Auto-link to changelogs**: extend each row with a `View` column that resolves the package's changelog URL (npm: `https://github.com/<repo>`, rubygems: gem homepage)
- **Multi-repo**: loop over a list of repos and produce a single sorted table — useful for org-wide triage
- **Weekly digest mode**: `/triage-deps weekly` → only show PRs older than 7 days
