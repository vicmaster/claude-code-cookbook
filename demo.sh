#!/usr/bin/env bash
# demo.sh — simulated Claude Code session for the README hero GIF.
# Driven by hero.tape (vhs).

set -u

dim=$'\033[2m'
white=$'\033[37m'
cyan=$'\033[36m'
green=$'\033[32m'
red=$'\033[1;31m'
reset=$'\033[0m'

# User prompt
printf "${dim}>${reset} ${white}commit these changes and push${reset}\n"
sleep 0.7
printf "\n"

# Assistant message
printf "${white}I'll stage everything, commit, and push to origin.${reset}\n\n"
sleep 0.7

# Tool call header
printf "${green}●${reset} ${dim}Bash(git add -A && git commit -m \"scaffold cookbook\")${reset}\n"
sleep 0.5

# Hook output rendered as tool result
printf "  ${cyan}⎿${reset}  ${red}Hook blocked (PreToolUse)${reset}\n"
sleep 0.2
printf "     ${red}Refusing to commit to protected branch 'main'.${reset}\n"
sleep 0.15
printf "     ${red}Create a feature branch first:  ${reset}${red}git checkout -b <branch-name>${reset}\n"
sleep 0.15
printf "     ${red}To bypass for this session:     ${reset}${red}export ALLOW_MAIN_COMMIT=1${reset}\n"
sleep 1.7

# Caption
printf "\n\n${dim}── claude-code-cookbook · recipes/hooks/block-main-branch-commits${reset}\n"
sleep 2.0
