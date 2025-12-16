#!/usr/bin/env bash

# ===============================
# WHOIAM — Skye Edition
# Cute terminal user card
# ===============================

# -------- COLORS (Catppuccin Mocha True Color) --------
RESET="\033[0m"
BOLD="\033[1m"
PINK="\033[38;2;245;194;231m"
MAUVE="\033[38;2;203;166;247m"
LAVENDER="\033[38;2;180;190;254m"
PEACH="\033[38;2;250;179;135m"
YELLOW="\033[38;2;249;226;175m"
BLUE="\033[38;2;137;180;250m"
GREEN="\033[38;2;166;227;161m"
TEAL="\033[38;2;148;226;213m"
SKY="\033[38;2;137;220;235m"
TEXT="\033[38;2;205;214;244m"

# -------- SYSTEM INFO --------
USER_NAME="$(whoami)"
UPTIME="$(uptime | sed 's/.*up \([^,]*\),.*/\1/')"
SHELL_NAME="$(basename "$SHELL")"

if command -v sw_vers >/dev/null 2>&1; then
  OS_NAME="$(sw_vers -productName) $(sw_vers -productVersion)"
  OS_ICON=""
else
  OS_NAME="$(uname -sr)"
  if [[ "$(uname)" == "Linux" ]]; then
    OS_ICON=""
  else
    OS_ICON="טּ"
  fi
fi

DATE_NOW="$(date '+%Y-%m-%d')"

# -------- ANIMATION --------
animate() {
    clear
    tput civis
    trap 'tput cnorm; exit' INT TERM
    
    local content
    read -r -d '' content << EOM
${LAVENDER}⧣₊˚﹒✦₊  ⧣₊˚   𓂃★   ⸝⸝   ⧣₊˚﹒✦₊  ⧣₊˚${RESET}

      ${MAUVE}/)     /)
    ${MAUve}(｡•ㅅ•｡)〝₎₎   ${PINK}luvrksknskye ✦₊ ˊ˗${RESET}

${MAUVE}╭∪─∪──────────────────── ${LAVENDER}✦ ⁺.${RESET}
${MAUVE}│  ${TEXT} User     : ${YELLOW}${USER_NAME}${RESET}
${MAUVE}│ 祥 ${TEXT} Uptime   : ${TEAL}${UPTIME}${RESET}
${MAUVE}│ ⚧ ${TEXT} Pronouns : ${PINK}she/they${RESET}
${MAUVE}│  ${TEXT} Date     : ${PEACH}${DATE_NOW}${RESET}
${MAUVE}│ консоль ${TEXT} Shell    : ${BLUE}${SHELL_NAME}${RESET}
${MAUVE}│ ${OS_ICON} ${TEXT} OS       : ${GREEN}${OS_NAME}${RESET}
${MAUVE}│  ${TEXT} Extra    : ${SKY}hai!!!${RESET}
${MAUVE}╰─────────────────────── ${LAVENDER}✦ ⁺.${RESET}

${LAVENDER}⧣₊˚﹒✦₊  ⧣₊˚   𓂃★   ⸝⸝   ⧣₊˚﹒✦₊  ⧣₊˚${RESET}

EOM

    echo -e "$content" | while IFS= read -r line; do
        echo -e "$line"
        sleep 0.02
    done

    tput cnorm
}

animate

