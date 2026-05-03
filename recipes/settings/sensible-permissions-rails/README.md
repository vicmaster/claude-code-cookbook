# sensible-permissions-rails

**Pain:** Permission prompts every 30 seconds for `bundle exec`, `bin/rails`, `bin/rspec`, `bin/rubocop` while you're trying to think.
**Fix:** A vetted `settings.json` allowlist for Rails work — read-only and routine commands pre-approved, write/destructive commands still gated.
**Time to install:** 30s

## Why this exists

The cost of permission prompts is focus, not seconds. Every approval you give breaks flow. This is a list of Rails commands that are routine *and* don't have destructive blast radius — safe to pre-approve so the model can iterate without interrupting you.

Battle-tested in a Rails 8 + Sidekiq + RSpec + RuboCop project across hundreds of agent turns.

## Install

```bash
# Project-scoped (recommended — keeps the allowlist scoped to this app):
mkdir -p .claude
cp settings.json .claude/settings.local.json

# Or merge into an existing settings.local.json by hand
```

Add `.claude/settings.local.json` to `.gitignore` if you want to keep your allowlist private; commit it if your team should share it.

## Files

- `settings.json` — the permissions block (rename to `settings.local.json` on install if you want it gitignored)

## Gotchas

- **Deliberately NOT allowed**: `rails db:drop`, `rails db:reset`, `rails runner *` (arbitrary code execution), `bundle update *` (changes lockfile silently). Keep these gated.
- **`git push *` is allowed** — pair with the [block-main-branch-commits](../../hooks/block-main-branch-commits) hook to avoid pushing straight to main.
- **`git commit -m ' *'` includes a space and quote** — that's intentional; it matches `git commit -m '...'` but not `git commit --amend` or `git commit -F`.
- **Timeouts** (`timeout 60`, `timeout 600`) prevent runaway specs/rubocop from hanging an agent turn.
- This list assumes `bin/rails`, `bin/rspec`, `bin/rubocop` exist (i.e. you've run `bundle binstubs`). Add the `bundle exec` equivalents if not.

## Variations

- Add Sidekiq: `Bash(bundle exec sidekiq *)`, `Bash(bin/sidekiq *)`
- Add Solid Queue: `Bash(bin/jobs *)`
- Add Kamal: `Bash(bin/kamal *)`
- Add seed/factories tooling: `Bash(bin/rails db:seed)` (already in), `Bash(bundle exec rake db:seed:replant)`
- Companion recipe planned: `sensible-permissions-node` for JS/TS projects
