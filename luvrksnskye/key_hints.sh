#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  KEY HINTS  *:･ﾟ✧*:･ﾟ✧                                    │
# │                                                                             │
# │              Yabai + skhd Keybindings                                       │
# │              Catppuccin Mocha ·                                             │
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
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
BLUE='\033[38;2;137;180;250m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE1='\033[38;2;69;71;90m'

# ═══════════════════════════════════════════════════════════════════════════════
# NERD FONT ICONS
# ═══════════════════════════════════════════════════════════════════════════════

ICON_WINDOW=""      # nf-fa-window_maximize
ICON_MOVE="󰆾"        # nf-md-cursor_move
ICON_RESIZE="󰩨"      # nf-md-resize
ICON_LAYOUT=""      # nf-fa-th_large
ICON_WORKSPACE=""   # nf-fa-desktop
ICON_APP=""         # nf-fa-rocket
ICON_SETTINGS=""    # nf-fa-cog
ICON_KEYBOARD=""    # nf-fa-keyboard_o
ICON_MOUSE="󰍽"       # nf-md-mouse
ICON_STAR=""        # nf-fa-star

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

DELAY=0.003

animate() {
    while IFS= read -r line; do
        echo -e "$line"
        sleep $DELAY
    done
}

clear
tput civis
trap 'tput cnorm; exit' INT TERM

animate << EOF

    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}

    ${MAUVE}╭───────────────────────────────────────────────────────────────────╮${R}
    ${MAUVE}│${R}                                                                   ${MAUVE}│${R}
    ${MAUVE}│${R}     ${PINK}${ICON_KEYBOARD}${R}  ${B}${TEXT}K E Y B I N D I N G S${R}                               ${MAUVE}│${R}
    ${MAUVE}│${R}                                                                   ${MAUVE}│${R}
    ${MAUVE}│${R}     ${DIM}${SUBTEXT0}Yabai + skhd Reference${R}                                     ${MAUVE}│${R}
    ${MAUVE}│${R}                                                                   ${MAUVE}│${R}
    ${MAUVE}╰───────────────────────────────────────────────────────────────────╯${R}

    ${LAVENDER}╭────────────────────────────────╮  ╭────────────────────────────────╮${R}
    ${LAVENDER}│${R} ${GREEN}${ICON_WINDOW} FOCUS${R}                        ${LAVENDER}│${R}  ${LAVENDER}│${R} ${GREEN}${ICON_MOVE} MOVE/SWAP${R}                   ${LAVENDER}│${R}
    ${LAVENDER}├────────────────────────────────┤${R}  ${LAVENDER}├────────────────────────────────┤${R}
    ${LAVENDER}│${R} ${PEACH}opt${R}+${TEXT}h/j/k/l${R}    ${SUBTEXT0}focus vim${R}       ${LAVENDER}│${R}  ${LAVENDER}│${R} ${PEACH}opt+sft${R}+${TEXT}h/j/k/l${R}  ${SUBTEXT0}swap vim${R}    ${LAVENDER}│${R}
    ${LAVENDER}│${R} ${PEACH}opt${R}+${TEXT}arrows${R}     ${SUBTEXT0}focus arrows${R}    ${LAVENDER}│${R}  ${LAVENDER}│${R} ${PEACH}opt+sft${R}+${TEXT}arrows${R}   ${SUBTEXT0}swap arrows${R} ${LAVENDER}│${R}
    ${LAVENDER}│${R} ${PEACH}opt${R}+${TEXT}tab${R}        ${SUBTEXT0}recent space${R}    ${LAVENDER}│${R}  ${LAVENDER}│${R} ${PEACH}ctrl+opt${R}+${TEXT}hjkl${R}   ${SUBTEXT0}warp${R}        ${LAVENDER}│${R}
    ${LAVENDER}│${R} ${PEACH}opt${R}+${TEXT}p/n${R}        ${SUBTEXT0}prev/next${R}       ${LAVENDER}│${R}  ${LAVENDER}│${R}                                ${LAVENDER}│${R}
    ${LAVENDER}╰────────────────────────────────╯${R}  ${LAVENDER}╰────────────────────────────────╯${R}

    ${PINK}╭────────────────────────────────╮  ╭────────────────────────────────╮${R}
    ${PINK}│${R} ${TEAL}${ICON_LAYOUT} LAYOUT${R}                       ${PINK}│${R}  ${PINK}│${R} ${TEAL}${ICON_RESIZE} RESIZE${R}                       ${PINK}│${R}
    ${PINK}├────────────────────────────────┤${R}  ${PINK}├────────────────────────────────┤${R}
    ${PINK}│${R} ${PEACH}opt${R}+${TEXT}/${R}          ${SUBTEXT0}toggle split${R}    ${PINK}│${R}  ${PINK}│${R} ${PEACH}ctrl+opt${R}+${TEXT}arrows${R} ${SUBTEXT0}resize${R}       ${PINK}│${R}
    ${PINK}│${R} ${PEACH}opt${R}+${TEXT}f${R}          ${SUBTEXT0}float/tile${R}      ${PINK}│${R}  ${PINK}│${R} ${PEACH}opt+sft${R}+${TEXT}+/-${R}     ${SUBTEXT0}grow/shrink${R}  ${PINK}│${R}
    ${PINK}│${R} ${PEACH}opt+sft${R}+${TEXT}f${R}      ${SUBTEXT0}fullscreen${R}      ${PINK}│${R}  ${PINK}│${R} ${PEACH}fn${R}+${TEXT}drag${R}        ${SUBTEXT0}free resize${R}  ${PINK}│${R}
    ${PINK}│${R} ${PEACH}opt${R}+${TEXT}r${R}          ${SUBTEXT0}rotate 90${R}       ${PINK}│${R}  ${PINK}│${R}                                ${PINK}│${R}
    ${PINK}╰────────────────────────────────╯${R}  ${PINK}╰────────────────────────────────╯${R}

    ${SKY}╭────────────────────────────────╮  ╭────────────────────────────────╮${R}
    ${SKY}│${R} ${YELLOW}${ICON_WORKSPACE} WORKSPACES${R}                  ${SKY}│${R}  ${SKY}│${R} ${YELLOW}${ICON_WINDOW} MINIMIZE${R}                    ${SKY}│${R}
    ${SKY}├────────────────────────────────┤${R}  ${SKY}├────────────────────────────────┤${R}
    ${SKY}│${R} ${PEACH}opt${R}+${TEXT}1-4${R}        ${SUBTEXT0}focus space${R}     ${SKY}│${R}  ${SKY}│${R} ${PEACH}opt${R}+${TEXT}w${R}          ${SUBTEXT0}minimize${R}      ${SKY}│${R}
    ${SKY}│${R} ${PEACH}opt+sft${R}+${TEXT}1-4${R}    ${SUBTEXT0}send to space${R}   ${SKY}│${R}  ${SKY}│${R} ${PEACH}opt+sft${R}+${TEXT}w${R}      ${SUBTEXT0}minimize all${R}  ${SKY}│${R}
    ${SKY}│${R} ${PEACH}opt${R}+${TEXT}0${R}          ${SUBTEXT0}balance${R}         ${SKY}│${R}  ${SKY}│${R} ${PEACH}ctrl+opt${R}+${TEXT}w${R}     ${SUBTEXT0}restore${R}       ${SKY}│${R}
    ${SKY}╰────────────────────────────────╯${R}  ${SKY}╰────────────────────────────────╯${R}

    ${MAUVE}╭───────────────────────────────────────────────────────────────────╮${R}
    ${MAUVE}│${R} ${BLUE}${ICON_APP} LAUNCH APPS${R}  ${DIM}(opt+sft+letter)${R}                              ${MAUVE}│${R}
    ${MAUVE}├───────────────────────────────────────────────────────────────────┤${R}
    ${MAUVE}│${R} ${PINK}T${R} ${TEXT}Terminal${R}    ${PINK}B${R} ${TEXT}Brave${R}     ${PINK}Z${R} ${TEXT}Zen${R}      ${PINK}E${R} ${TEXT}Finder${R}            ${MAUVE}│${R}
    ${MAUVE}│${R} ${PINK}D${R} ${TEXT}Discord${R}     ${PINK}C${R} ${TEXT}Claude${R}    ${PINK}V${R} ${TEXT}VSCode${R}   ${PINK}M${R} ${TEXT}Spotify${R}           ${MAUVE}│${R}
    ${MAUVE}│${R} ${PINK}O${R} ${TEXT}Obsidian${R}    ${PINK}A${R} ${TEXT}Apple Music${R}                                  ${MAUVE}│${R}
    ${MAUVE}╰───────────────────────────────────────────────────────────────────╯${R}

    ${SURFACE1}╭───────────────────────────────────────────────────────────────────╮${R}
    ${SURFACE1}│${R} ${PEACH}${ICON_SETTINGS} SERVICES${R}                                                     ${SURFACE1}│${R}
    ${SURFACE1}├───────────────────────────────────────────────────────────────────┤${R}
    ${SURFACE1}│${R} ${PEACH}ctrl+opt${R}+${TEXT}r${R}  ${SUBTEXT0}restart yabai${R}   ${PEACH}ctrl+opt${R}+${TEXT}s${R}  ${SUBTEXT0}reload skhd${R}         ${SURFACE1}│${R}
    ${SURFACE1}│${R} ${PEACH}ctrl+opt${R}+${TEXT}g${R}  ${SUBTEXT0}greeting${R}        ${PINK}luvr${R}          ${SUBTEXT0}open menu${R}            ${SURFACE1}│${R}
    ${SURFACE1}╰───────────────────────────────────────────────────────────────────╯${R}

    ${SURFACE1}╭───────────────────────────────────────────────────────────────────╮${R}
    ${SURFACE1}│${R} ${PEACH}${ICON_MOUSE} MOUSE${R}  ${DIM}(hold fn)${R}                                              ${SURFACE1}│${R}
    ${SURFACE1}├───────────────────────────────────────────────────────────────────┤${R}
    ${SURFACE1}│${R} ${PEACH}fn${R}+${TEXT}left click${R}   ${SUBTEXT0}move window${R}     ${PEACH}fn${R}+${TEXT}right click${R}  ${SUBTEXT0}resize${R}      ${SURFACE1}│${R}
    ${SURFACE1}╰───────────────────────────────────────────────────────────────────╯${R}

    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}

EOF

echo ""
read -n 1 -s -r -p "    Press any key to close..."
echo ""
tput cnorm
