---
description: Generate yesterday's standup notes from git commits across configured repos
allowed-tools: Bash(git log:*), Bash(git config:*), Bash(date:*), Bash(cat:*), Bash(test:*), Read
---

Generate standup-ready bullets from yesterday's git activity.

## Repo list

Use the repo list from `$ARGUMENTS` (space-separated absolute paths). If `$ARGUMENTS` is empty, read paths from `~/.claude/standup-repos.txt` (one absolute path per line). If neither is provided, ask the user once for a repo list and stop.

## Steps

1. **Determine the date window.**
   - If today is Monday, "yesterday" = the prior Friday 00:00 through Sunday 23:59 (covers the weekend)
   - Otherwise "yesterday" = yesterday 00:00 through yesterday 23:59
   - Compute concrete `--since` and `--until` ISO 8601 timestamps for `git log`

2. **Get the author's email.** Run `git config --global user.email` (fallback to per-repo `git config user.email`). Use this as the `--author` filter.

3. **For each repo path:**
   - Verify the path exists and is a git repo (`test -d "$path/.git"`)
   - Run:
     ```
     git -C "$path" log \
       --since="<start>" --until="<end>" \
       --author="<email>" \
       --no-merges \
       --pretty=format:"- %s"
     ```
   - Capture commits

4. **Format the output as Markdown:**
   ```markdown
   ## Standup — <today's date>

   ### Yesterday
   **<repo basename>**
   - <commit subject>
   - <commit subject>

   **<another repo>**
   - <commit subject>

   ### Today
   - TODO

   ### Blockers
   - None
   ```

5. **Skip empty repos** — don't print the heading if there are no commits in the window.

6. **Print the result.** Don't add commentary; the user will paste it into Slack.

## Constraints

- Read-only — no `git pull`, no fetching, no writes.
- If the user's email isn't set globally, fall back to scanning each repo's local config.
- If a repo path doesn't exist or isn't a git repo, skip it silently and warn at the end with a single line: "Skipped: <path> (not a git repo)".
