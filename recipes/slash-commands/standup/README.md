# standup

**Pain:** "What did I do yesterday?" at 9am, every weekday. Scrolling git log across N repos, mentally filtering for your author email, formatting bullets — five minutes of low-value work right when you should be focused.
**Fix:** A `/standup` slash command that scans configured repos for your commits in the right date window (handling Mondays correctly), formats them as standup-ready Markdown, and prints them.
**Time to install:** 1 minute (you'll create the repo list once)

## Why this exists

Standup notes are valuable to others, tedious to produce. Git already knows what you did. This just connects the two.

The only manual config: a list of repos to scan. Set it once, paste the output every morning.

## Install

```bash
mkdir -p ~/.claude/commands
cp standup.md ~/.claude/commands/

# Create your repo list — one absolute path per line:
cat > ~/.claude/standup-repos.txt <<'EOF'
/Users/you/Projects/main-app
/Users/you/Projects/admin-panel
/Users/you/Projects/internal-tools
EOF
```

Then in Claude Code: `/standup`. Override the list ad hoc with `/standup /path/to/repo1 /path/to/repo2`.

## Files

- `standup.md` — the slash command definition

## Gotchas

- **Mondays look back to Friday.** Otherwise weekend would be silent. If you actively don't want weekend coverage, edit step 1.
- **Filters by `git config user.email`.** If you commit from multiple emails (personal vs work), the command will only pick up one. Pass `--author` overrides via a variation.
- **No fetching.** The command only reads local history. If you want commits from teammates' branches, fetch them yourself first.
- **Skips non-existent paths silently** with a single warning line at the end. Stale entries in `standup-repos.txt` are forgiving, not fatal.
- **Doesn't include PR reviews, Linear comments, or Slack messages.** It's git-only. Pair with a separate workflow if your standups need more.

## Variations

- **GitHub activity**: append `gh search prs --author "@me" --updated ">=<since>"` to capture review activity
- **Linear / Jira tickets**: add an MCP step that pulls assigned tickets moved yesterday
- **Per-team grouping**: tag repos in `standup-repos.txt` and group output by tag
- **Weekly summary mode**: `/standup week` → expand the date window to last 7 days, group by day
- **Time tracking**: append entries from Toggl / Harvest via their CLIs
