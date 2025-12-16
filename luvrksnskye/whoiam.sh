#!/usr/bin/env bash

# ===============================
# WHOIAM — Skye Edition
# Cute terminal user card
# ===============================

# -------- COLORS (Catppuccin-ish) --------
RESET="\033[0m"
BOLD="\033[1m"

PINK="\033[38;5;218m"
MAUVE="\033[38;5;141m"
LAVENDER="\033[38;5;183m"
PEACH="\033[38;5;216m"
YELLOW="\033[38;5;222m"
BLUE="\033[38;5;111m"
GREEN="\033[38;5;114m"
TEAL="\033[38;5;116m"
SKY="\033[38;5;117m"
TEXT="\033[38;5;189m"

# -------- SYSTEM INFO --------
USER_NAME="$(whoami)"
UPTIME="$(uptime | sed 's/.*up \([^,]*\),.*/\1/')"
SHELL_NAME="$(basename "$SHELL")"

if command -v sw_vers >/dev/null 2>&1; then
  OS_NAME="$(sw_vers -productName) $(sw_vers -productVersion)"
else
  OS_NAME="$(uname -sr)"
fi

DATE_NOW="$(date '+%Y-%m-%d')"

clear

# -------- HEADER --------
echo -e "${LAVENDER}⧣₊˚﹒✦₊  ⧣₊˚   𓂃★   ⸝⸝   ⧣₊˚﹒✦₊  ⧣₊˚${RESET}\n"

# -------- CAT --------
echo -e "      ${MAUVE}/)     /)"
echo -e "    ${MAUVE}(｡•ㅅ•｡)〝₎₎   ${PINK}luvrksknskye ✦₊ ˊ˗${RESET}\n"

# -------- INFO CARD --------
echo -e "${MAUVE}. .╭∪─∪──────────────────── ${LAVENDER}✦ ⁺.${RESET}"
echo -e "${MAUVE}. .┊ ◟﹫ ${TEXT}User     : ${YELLOW}${USER_NAME}${RESET}"
echo -e "${MAUVE}. .┊ ﹒𐐪 ${TEXT}Uptime   : ${TEAL}${UPTIME}${RESET}"
echo -e "${MAUVE}. .┊ ꜝꜝ﹒ ${TEXT}Pronouns : ${PINK}she/they${RESET}"
echo -e "${MAUVE}. .┊ ⨳゛ ${TEXT}Date     : ${PEACH}${DATE_NOW}${RESET}"
echo -e "${MAUVE}. .┊ ◟ヾ ${TEXT}Shell    : ${BLUE}${SHELL_NAME}${RESET}"
echo -e "${MAUVE}. .┊ ﹒𐐪 ${TEXT}OS       : ${GREEN}${OS_NAME}${RESET}"
echo -e "${MAUVE}. .┊ ◟﹫ ${TEXT}Extra    : ${SKY}hai!!!${RESET}"
echo -e "${MAUVE}   ╰─────────────────────── ${LAVENDER}✦ ⁺.${RESET}\n"

# -------- FOOTER --------
echo -e "${LAVENDER}⧣₊˚﹒✦₊  ⧣₊˚   𓂃★   ⸝⸝   ⧣₊˚﹒✦₊  ⧣₊˚${RESET}\n"
