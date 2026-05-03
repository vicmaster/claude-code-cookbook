# rails-developer

**Pain:** Claude defaults to generic Ruby/Rails knowledge — it'll write code that works but ignores conventions, misses N+1s, picks the wrong gem, or skips proper indexes.
**Fix:** A subagent that acts as a senior Rails engineer — reads `Gemfile` and `db/schema.rb` first, follows existing patterns, picks the right tool from the modern Rails ecosystem (Hotwire, Solid Queue, Kamal, etc.).
**Time to install:** 30s

## Why this exists

Rails has a huge ecosystem and strong conventions. Without an opinionated agent, Claude will reach for whatever library it saw most in training data — often outdated. This agent encodes "what a senior Rails dev does first": read the app, match its style, then implement.

Battle-tested across Rails 8 apps using Hotwire, Sidekiq, RSpec, and PostgreSQL.

## Install

```bash
# User-scoped (available in every project):
mkdir -p ~/.claude/agents
cp agent.md ~/.claude/agents/rails-developer.md

# Or project-scoped:
mkdir -p .claude/agents
cp agent.md .claude/agents/rails-developer.md
```

Then in Claude Code: `Use the rails-developer agent to add a comments feature to the Post model`.

## Files

- `agent.md` — the subagent definition

## Gotchas

- Defaults to `model: sonnet` — change to opus for harder architectural work, haiku for trivial edits
- Tool list includes `Bash` so the agent can run `rspec`, `rubocop`, etc. — pair with the [sensible-permissions-rails](../../settings/sensible-permissions-rails) recipe to avoid permission prompts mid-task
- The agent reads `Gemfile` first — make sure your project has one committed (or it'll guess)

## Variations

- Swap `model: sonnet` → `model: opus` for greenfield architecture work
- Add `mcp__*` tools if you want it to query Linear / GitHub directly
- Pair with [code-reviewer](../code-reviewer) for a write-then-review loop
