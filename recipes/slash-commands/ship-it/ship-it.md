---
description: Stage, commit, push, and open a PR with sensible defaults
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git symbolic-ref:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh repo view:*)
---

Ship the current branch as a pull request. Walk through these steps in order; do NOT batch parallel git calls — each step's decision depends on the prior one.

## Steps

1. **Sanity check the branch.** Run `git symbolic-ref --short HEAD`. If it returns `main` or `master`, STOP and tell the user: "You're on a protected branch. Create a feature branch first: `git checkout -b <name>`." Do not proceed.

2. **Inspect the working tree.** Run:
   - `git status`
   - `git diff` (unstaged)
   - `git diff --staged` (staged)
   - `git log <base>..HEAD --oneline` where base is the repo's default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name` if `gh` is available, otherwise `main`)

3. **Decide what to commit.** Summarize the diff in 1–2 sentences (focus on *why*, not *what*). If there are unstaged changes:
   - Stage everything except files matching `.env*`, `*.pem`, `credentials.*`, `*.key`, `id_rsa*` — never stage those silently
   - Use `git add -A` after the exclusion check, or stage explicit files when the change is narrow
4. **Commit.** Create exactly ONE commit with a message that follows the repo's existing style (run `git log --oneline -10` to spot the convention — Conventional Commits, plain English, prefixed scope, etc.). One sentence. Imperative mood. No "Co-Authored-By" lines.

5. **Push.** Run `git push -u origin HEAD` if the branch has no upstream, otherwise `git push`.

6. **Open the PR.** Run `gh pr create` with:
   - `--title`: under 70 characters; if `$ARGUMENTS` was provided, use it verbatim, otherwise derive from the commit subject
   - `--body`: a heredoc with two sections:
     ```
     ## Summary
     <1–3 bullets describing the change and why>

     ## Test plan
     <bulleted checklist of how to verify, drawn from the diff>
     ```

7. **Print the PR URL** that `gh pr create` returned.

## Constraints

- **One commit per `/ship-it`.** If there are obviously unrelated changes (e.g., a refactor mixed with a feature), stop and ask whether to split them.
- **Never `git push --force`.** If the push is rejected, surface the error; don't recover with force.
- **Never bypass branch protection.** If on `main`/`master`, refuse (step 1).
- **Never commit secrets.** Re-check the staged diff for high-entropy strings or credential-looking files before committing.
- **Don't open draft PRs by default** — pass `--draft` only if `$ARGUMENTS` contains the word `draft`.
