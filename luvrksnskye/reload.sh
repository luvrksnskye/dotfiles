#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  RELOAD  *:･ﾟ✧*:･ﾟ✧                                       │
# │                                                                             │
# │              Reload All Services                                            │                        │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS — Catppuccin Mocha 
# ═══════════════════════════════════════════════════════════════════════════════

R='\033[0m'
B='\033[1m'
DIM='\033[2m'

PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
RED='\033[38;2;243;139;168m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY0='\033[38;2;108;112;134m'

# ═══════════════════════════════════════════════════════════════════════════════
# NERD FONT ICONS
# ═══════════════════════════════════════════════════════════════════════════════

ICON_RELOAD=""      # nf-fa-refresh
ICON_CHECK=""       # nf-fa-check
ICON_CROSS=""       # nf-fa-times
ICON_CIRCLE=""      # nf-fa-circle_o
ICON_SPINNER="󰑓"     # nf-md-loading

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

print_status() {
    local name="$1"
    local status="$2"
    
    case "$status" in
        ok)
            printf "    ${TEXT}%-15s ${OVERLAY0}.......... ${GREEN}${ICON_CHECK} reloaded${R}\n" "$name"
            ;;
        fail)
            printf "    ${TEXT}%-15s ${OVERLAY0}.......... ${RED}${ICON_CROSS} failed${R}\n" "$name"
            ;;
        skip)
            printf "    ${TEXT}%-15s ${OVERLAY0}.......... ${DIM}${ICON_CIRCLE} skipped${R}\n" "$name"
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

clear

echo ""
echo -e "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*${R}"
echo ""

echo -e "    ${MAUVE}╭───────────────────────────────────────╮${R}"
echo -e "    ${MAUVE}│${R}                                       ${MAUVE}│${R}"
echo -e "    ${MAUVE}│${R}   ${PINK}${ICON_RELOAD}${R} ${B}${TEXT}Reloading Services...${R}          ${MAUVE}│${R}"
echo -e "    ${MAUVE}│${R}                                       ${MAUVE}│${R}"
echo -e "    ${MAUVE}╰───────────────────────────────────────╯${R}"
echo ""

# Reload Yabai
if command -v yabai &>/dev/null; then
    if yabai --restart-service 2>/dev/null; then
        print_status "Yabai" "ok"
    else
        print_status "Yabai" "fail"
    fi
else
    print_status "Yabai" "skip"
fi

sleep 0.1

# Reload skhd
if command -v skhd &>/dev/null; then
    if skhd --reload 2>/dev/null; then
        print_status "skhd" "ok"
    else
        print_status "skhd" "fail"
    fi
else
    print_status "skhd" "skip"
fi

sleep 0.1

# Reload SketchyBar
if pgrep -x "sketchybar" &>/dev/null; then
    if sketchybar --reload 2>/dev/null; then
        print_status "SketchyBar" "ok"
    else
        print_status "SketchyBar" "fail"
    fi
else
    print_status "SketchyBar" "skip"
fi

sleep 0.1

# Reload Borders
if pgrep -x "borders" &>/dev/null; then
    if brew services restart borders >/dev/null 2>&1; then
        print_status "Borders" "ok"
    else
        print_status "Borders" "fail"
    fi
else
    print_status "Borders" "skip"
fi

echo ""
echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}All services checked${R}"
echo ""
