---
description: Triage open Dependabot PRs by risk (read-only, no merging)
allowed-tools: Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh repo view:*)
---

Triage open Dependabot PRs in the current repo. Output a risk-sorted summary; do NOT merge anything.

If `$ARGUMENTS` is provided, treat it as a label filter (e.g. `/triage-deps ruby` filters to PRs tagged `ruby`).

## Steps

1. **List open Dependabot PRs.** Run:
   ```
   gh pr list --author "app/dependabot" --state open --json number,title,labels,body,createdAt --limit 100
   ```
   If `$ARGUMENTS` was provided, add `--label "$ARGUMENTS"`.

2. **For each PR, parse the bump.** Dependabot titles follow `Bump <pkg> from X.Y.Z to A.B.C` (or `chore(deps): bump ...`). Extract `<pkg>`, old version, new version.

3. **Classify each PR by semver delta:**
   - **Patch** (`X.Y.Z → X.Y.W`): low risk
   - **Minor** (`X.Y.Z → X.W.0`): medium risk
   - **Major** (`X.Y.Z → W.0.0`): high risk
   - **Pre-1.0 minor** (`0.X.Y → 0.W.0`): treat as major — semver guarantees don't apply
   - **Unparseable** (non-standard version, git SHA, etc.): mark as unknown, flag for human review

4. **Flag security advisories.** If the PR body contains `GHSA-` or "security" / "advisory" / "CVE-", bump to **Security** category regardless of semver delta.

5. **Output a Markdown table sorted Security → Major → Minor → Patch:**
   ```markdown
   ## Dependabot triage — <repo name>

   | # | Package | Bump | Risk | Security? | Age |
   |---|---|---|---|---|---|
   | 142 | rails | 7.1.3 → 7.1.4 | Patch | – | 2d |
   | 141 | nokogiri | 1.16.2 → 1.16.5 | Patch | GHSA-xxxx | 4d |
   | 138 | webpacker | 5.4.0 → 6.0.0 | Major | – | 14d |
   ```

6. **End with a recommendation:**
   ```
   **Recommendation:** N patch PRs are low-risk and could be auto-merged after CI green. M security PRs need attention this week. K major PRs need a human read.
   ```

## Constraints

- **Read-only.** Never call `gh pr merge`, `gh pr review`, or anything that modifies state.
- **Don't fetch the diff** unless explicitly asked — diff fetching is slow on large PRs and rarely needed for triage.
- **Truncate at 100 PRs.** If more exist, note "limited to 100; pass `--label` to narrow".
- **No commentary on individual PRs** — the table is the deliverable.
