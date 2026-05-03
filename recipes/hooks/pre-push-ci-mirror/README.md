# pre-push-ci-mirror

**Pain:** You push, walk away, come back to a red CI build because rubocop or rspec failed on something you could have caught locally in 5 seconds.
**Fix:** A `lefthook` pre-push hook that runs lint + tests in parallel before every push. CI only sees changes that already passed locally.
**Time to install:** 1 minute (needs `lefthook` installed)

## Why this exists

CI feedback loops are slow (minutes) and expensive (CI minutes are billed). Local feedback loops are fast (seconds) and free. A pre-push hook moves the cheap checks left without slowing down `git commit` (use `pre-commit` for that — different recipe).

> **Note**: This is a *git* hook (managed by [lefthook](https://lefthook.dev)), not a Claude Code hook. It triggers on `git push`, regardless of whether the agent or a human did the pushing — which is exactly what you want when Claude is shipping code on your behalf.

## Install

```bash
# 1. Install lefthook (one-time, per machine)
brew install lefthook       # macOS
# or: gem install lefthook
# or: npm install -g lefthook

# 2. Copy the config to your repo root
cp lefthook.yml .

# 3. Wire up the git hooks (one-time, per clone)
lefthook install
```

Add `lefthook install` to your project's `bin/setup` so new clones get it automatically.

## Files

- `lefthook.yml` — the hook config (Rails example: rubocop + rspec)

## Gotchas

- **Bypass with `git push --no-verify`** when you genuinely need to push WIP — but don't make that a habit.
- **`parallel: true`** runs rubocop and rspec at the same time. If your specs are flaky under parallel load, set `parallel: false`.
- **Full suite vs scoped** — this config runs the full spec suite. For monorepos or large suites, scope with `{files}` substitution; just know that lefthook's file detection can be unreliable on branches without an upstream.
- **`bin/rubocop` and `bin/rspec`** assume binstubs. Substitute `bundle exec rubocop` / `bundle exec rspec` if you don't use them.
- This is for **pre-push**, not pre-commit. Pre-commit hooks should be near-instant; pre-push can take seconds.

## Variations

- **Node/TS**: swap commands for `npm run lint` and `npm test`
- **Python**: `ruff check` + `pytest`
- **Go**: `go vet ./...` + `go test ./...`
- **Pre-commit (lighter)**: a separate config running only fast checks (`rubocop --only Layout`, formatters)
- **Claude Code Stop hook variant**: instead of (or in addition to) lefthook, wire a Claude Code `Stop` hook that runs the same commands when the agent finishes a turn — gives the agent the same feedback the human gets at push time
