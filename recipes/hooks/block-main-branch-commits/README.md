# block-main-branch-commits

**Pain:** You ask the agent to commit, it commits, and the commit lands on `main` because nobody noticed nobody had branched first.
**Fix:** A PreToolUse hook that intercepts `git commit` and refuses it when HEAD is on a protected branch (`main`, `master`, or any pattern you configure).
**Time to install:** 30s

## Why this exists

GitHub branch protection catches the *push*, but only after the commit exists locally — undoing it means resets, force pushes, and apologies in chat. This hook catches the mistake one step earlier: at the commit itself, before any history is written.

Cheap, fast, and bypassable when you really mean it.

## Install

Project-scoped (recommended — protected-branch list lives with the repo):

```bash
mkdir -p .claude/hooks
cp block-main-commit.sh .claude/hooks/
chmod +x .claude/hooks/block-main-commit.sh

# Then merge settings.json into your existing .claude/settings.json
# (or copy as-is if you don't have one yet):
cp settings.json .claude/settings.json
```

User-scoped (applies in every project) — install to `~/.claude/` instead, and edit the `command` path in `settings.json` to `~/.claude/hooks/block-main-commit.sh`.

Restart Claude Code (or reload the project) for the hook to take effect.

## Files

- `block-main-commit.sh` — the actual logic; reads PreToolUse JSON from stdin, inspects the Bash command, exits 2 to block
- `settings.json` — registers the hook for the `Bash` tool

## Gotchas

- **Requires `jq`** (`brew install jq` / `apt install jq`) — the script uses it to parse the hook payload.
- **`git commit --amend` is blocked too.** Amending main is also dangerous; if you really want to amend, set `ALLOW_MAIN_COMMIT=1`.
- **Bypass with `export ALLOW_MAIN_COMMIT=1`** in your shell. The hook still runs but lets the commit through.
- **Won't catch `git -C /elsewhere commit`** if pwd is on a feature branch but `/elsewhere` is on main — the script checks pwd's git, not the `-C` target. Rare in practice; mention as known limitation.
- **Won't catch `gh pr merge` directly to main** — that's a GitHub-side action, not a local commit. Pair with branch protection rules for full coverage.
- **Detached HEAD lets commits through** — there's no branch to check. Acceptable: detached-HEAD commits are intentional and rare.

## Variations

- **More protected branches**: `export PROTECTED_BRANCHES="main master release/* prod"` (space-separated; case patterns)
- **Block force pushes too**: extend the regex to match `git push.*--force` and check the destination ref
- **Notify instead of block**: change `exit 2` to `exit 0` and add an `osascript`/`notify-send` call — discourage without preventing
- **Sibling recipe idea**: a `block-prod-deploys` hook that refuses `kamal deploy` / `cap production deploy` outside CI
