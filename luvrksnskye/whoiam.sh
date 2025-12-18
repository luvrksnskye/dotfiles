#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  WHO AM I  *:･ﾟ✧*:･ﾟ✧                                     │
# │                                                                             │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS — Catppuccin Mocha (Feminine)
# ═══════════════════════════════════════════════════════════════════════════════

R='\033[0m'
B='\033[1m'
DIM='\033[2m'

PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
BLUE='\033[38;2;137;180;250m'
ROSEWATER='\033[38;2;245;224;220m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE1='\033[38;2;69;71;90m'

# ═══════════════════════════════════════════════════════════════════════════════
# NERD FONT ICONS
# ═══════════════════════════════════════════════════════════════════════════════

ICON_USER=""        # nf-fa-user
ICON_CLOCK=""       # nf-fa-clock_o
ICON_HEART=""       # nf-fa-heart
ICON_CALENDAR=""    # nf-fa-calendar
ICON_TERMINAL=""    # nf-fa-terminal
ICON_APPLE=""       # nf-fa-apple
ICON_LINUX=""       # nf-fa-linux
ICON_STAR=""        # nf-fa-star
ICON_CODE=""        # nf-fa-code
ICON_HOME=""        # nf-fa-home
ICON_SPARKLE="󰫢"     # nf-md-shimmer

# ═══════════════════════════════════════════════════════════════════════════════
# SYSTEM INFO
# ═══════════════════════════════════════════════════════════════════════════════

USER_NAME="$(whoami)"
HOST_NAME="$(hostname -s 2>/dev/null || hostname)"
UPTIME="$(uptime | sed 's/.*up \([^,]*\),.*/\1/' | xargs)"
SHELL_NAME="$(basename "$SHELL")"
TERM_NAME="${TERM_PROGRAM:-$TERM}"

# OS Detection
if command -v sw_vers >/dev/null 2>&1; then
    OS_NAME="$(sw_vers -productName) $(sw_vers -productVersion)"
    OS_ICON="$ICON_APPLE"
else
    OS_NAME="$(uname -sr)"
    if [[ "$(uname)" == "Linux" ]]; then
        OS_ICON="$ICON_LINUX"
    else
        OS_ICON="$ICON_TERMINAL"
    fi
fi

DATE_NOW="$(date '+%Y-%m-%d')"
TIME_NOW="$(date '+%H:%M')"
DAY_NAME="$(date '+%A')"

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

clear
tput civis
trap 'tput cnorm; exit' INT TERM

# Animation delay
DELAY=0.02

animate_line() {
    echo -e "$1"
    sleep $DELAY
}

echo ""

animate_line "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}"
echo ""

# Cute bunny ASCII art
animate_line "    ${MAUVE}      /)     /)${R}"
animate_line "    ${MAUVE}     ( .  . )${R}"
animate_line "    ${MAUVE}     (  ${PINK}${ICON_HEART}${MAUVE}  )   ${PINK}luvrksknskye${R} ${LAVENDER}${ICON_SPARKLE}${R}"
animate_line "    ${MAUVE}      |   |${R}"
echo ""

animate_line "    ${MAUVE}╭─────────────────────────────────────────╮${R}"
animate_line "    ${MAUVE}│${R}                                         ${MAUVE}│${R}"
animate_line "    ${MAUVE}│${R}  ${PINK}${ICON_USER}${R}  ${SUBTEXT0}User${R}      ${YELLOW}${USER_NAME}${R}"
animate_line "    ${MAUVE}│${R}  ${TEAL}${ICON_HOME}${R}  ${SUBTEXT0}Host${R}      ${TEXT}${HOST_NAME}${R}"
animate_line "    ${MAUVE}│${R}  ${SKY}${ICON_CLOCK}${R}  ${SUBTEXT0}Uptime${R}    ${TEAL}${UPTIME}${R}"
animate_line "    ${MAUVE}│${R}  ${PINK}${ICON_HEART}${R}  ${SUBTEXT0}Pronouns${R}  ${PINK}she/they${R}"
animate_line "    ${MAUVE}│${R}  ${PEACH}${ICON_CALENDAR}${R}  ${SUBTEXT0}Date${R}      ${PEACH}${DATE_NOW}${R}"
animate_line "    ${MAUVE}│${R}  ${BLUE}${ICON_TERMINAL}${R}  ${SUBTEXT0}Shell${R}     ${BLUE}${SHELL_NAME}${R}"
animate_line "    ${MAUVE}│${R}  ${GREEN}${OS_ICON}${R}  ${SUBTEXT0}OS${R}        ${GREEN}${OS_NAME}${R}"
animate_line "    ${MAUVE}│${R}  ${LAVENDER}${ICON_STAR}${R}  ${SUBTEXT0}Vibe${R}      ${SKY}hai!!!${R}"
animate_line "    ${MAUVE}│${R}                                         ${MAUVE}│${R}"
animate_line "    ${MAUVE}╰─────────────────────────────────────────╯${R}"
echo ""

animate_line "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}"
echo ""

# Current time
animate_line "    ${DIM}${SUBTEXT0}${DAY_NAME}, ${TIME_NOW}${R}"
echo ""

tput cnorm
