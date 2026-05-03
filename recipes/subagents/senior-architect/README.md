# senior-architect

**Pain:** "How should I structure this?" gets you one opinionated answer that may or may not fit your codebase. You wanted options, trade-offs, and a recommendation grounded in *your* code — not a generic textbook reply.
**Fix:** A subagent that reads your stack first, then presents 2–3 viable options with concrete pros/cons, effort estimates, and a final recommendation.
**Time to install:** 30s

## Why this exists

Architecture is contextual. The "right" answer for a 5-person Rails monolith is wrong for a 50-person microservice fleet. This agent forces Claude to read the codebase before opining, and to present options instead of a single take.

Best for greenfield design, refactor planning, and migration strategy.

## Install

```bash
mkdir -p ~/.claude/agents
cp agent.md ~/.claude/agents/senior-architect.md
```

Then: `Use the senior-architect agent to evaluate moving our background jobs from Sidekiq to Solid Queue`.

## Files

- `agent.md` — the subagent definition

## Gotchas

- Read-only by design (`Read, Grep, Glob, Bash`) — it won't write code. Hand off to a builder agent (e.g. [rails-developer](../rails-developer)) once a direction is chosen.
- "Effort" estimates are rough — calibrate against your team velocity.
- Best paired with `model: opus` for novel/hard problems; sonnet is fine for straightforward decisions.

## Variations

- Stack-specific siblings: `senior-architect-frontend`, `senior-architect-data`, etc., with narrowed knowledge bases
- Add a `### Risks & unknowns` section to the response format if your team values explicit risk surfacing
