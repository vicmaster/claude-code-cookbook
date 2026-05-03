# code-reviewer

**Pain:** Asking Claude to "review my changes" produces a wall of nitpicks mixed with real issues — no severity, no priorities, sometimes inventing problems where there are none.
**Fix:** A subagent that runs `git diff` first, then reports findings sorted by severity (Critical / Warnings / Suggestions / What's good), with file:line citations and a rule against fabricating issues.
**Time to install:** 30s

## Why this exists

Code review only helps when the reader knows what to fix first. Generic AI review dumps everything at the same priority and over-reports. This agent is opinionated: be specific, sort by severity, don't invent problems if the diff is clean.

## Install

```bash
mkdir -p ~/.claude/agents
cp agent.md ~/.claude/agents/code-reviewer.md
```

Then: `Use the code-reviewer agent to review my staged changes` or `... to review PR #123`.

## Files

- `agent.md` — the subagent definition

## Gotchas

- Runs `git diff` / `git diff --staged` — make sure you've staged what you want reviewed (or pass an explicit ref)
- Severity buckets are guidance, not a rubric — calibrate with your team
- Won't flag style/lint issues by design; pair with rubocop/eslint/etc. for those
- Independent of your "writer" agent — important for second-opinion value

## Variations

- Add `gh pr diff` support for reviewing remote PRs
- Domain variants: `code-reviewer-security` (security-only), `code-reviewer-perf` (performance-only)
- Pair in a write→review loop: rails-developer or similar writes, code-reviewer reads
