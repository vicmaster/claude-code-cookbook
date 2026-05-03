#!/usr/bin/env bash
# statusline.sh — one-line status with model, working directory, and session cost.
# Reads Claude Code session JSON from stdin, prints to stdout.
#
# Customize the warn threshold:  COST_WARN_USD=2.50

set -u

input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "?"')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // ""')
dir=$(basename "$cwd" 2>/dev/null || echo "")
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // 0')
cost_fmt=$(printf '%.2f' "$cost" 2>/dev/null || echo "0.00")

# Color codes (suppressed under NO_COLOR)
if [ -z "${NO_COLOR:-}" ]; then
  c_dim=$'\033[2m'
  c_model=$'\033[36m'
  c_cost=$'\033[33m'
  c_warn=$'\033[1;31m'
  c_reset=$'\033[0m'
else
  c_dim=''; c_model=''; c_cost=''; c_warn=''; c_reset=''
fi

# Color cost red if over threshold (default $1.00)
threshold="${COST_WARN_USD:-1.00}"
cost_color="$c_cost"
if awk -v c="$cost" -v t="$threshold" 'BEGIN{exit !(c>=t)}'; then
  cost_color="$c_warn"
fi

printf "%s%s%s %s|%s %s %s|%s %s\$%s%s" \
  "$c_model" "$model" "$c_reset" \
  "$c_dim" "$c_reset" "$dir" \
  "$c_dim" "$c_reset" "$cost_color" "$cost_fmt" "$c_reset"
