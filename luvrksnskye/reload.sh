#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            RELOAD CONFIGS                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Colors
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_GREEN='\033[38;5;114m'
C_PINK='\033[38;5;218m'
C_DIM='\033[2m'

clear
echo ""
echo -e "${C_LAVENDER}"
cat << 'EOF'
    ╭──────────────────────────────────────────────────────────────────╮
    │                                                                  │
    │                    Reloading Configurations                      │
    │                                                                  │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
echo -e "${C_RESET}"
echo ""

# Reload Aerospace
if command -v aerospace &> /dev/null; then
    echo -ne "  ${C_DIM}Aerospace${C_RESET}        "
    if aerospace reload-config 2>/dev/null; then
        echo -e "${C_GREEN}done${C_RESET}"
    else
        echo -e "${C_PINK}failed${C_RESET}"
    fi
else
    echo -e "  ${C_DIM}Aerospace${C_RESET}        ${C_DIM}not installed${C_RESET}"
fi

# Reload SketchyBar
if pgrep -x "sketchybar" &> /dev/null; then
    echo -ne "  ${C_DIM}SketchyBar${C_RESET}       "
    if sketchybar --reload 2>/dev/null; then
        echo -e "${C_GREEN}done${C_RESET}"
    else
        echo -e "${C_PINK}failed${C_RESET}"
    fi
else
    echo -e "  ${C_DIM}SketchyBar${C_RESET}       ${C_DIM}not running${C_RESET}"
fi

# Reload Borders
if pgrep -x "borders" &> /dev/null; then
    echo -ne "  ${C_DIM}Borders${C_RESET}          "
    if brew services restart borders 2>/dev/null; then
        echo -e "${C_GREEN}done${C_RESET}"
    else
        echo -e "${C_PINK}failed${C_RESET}"
    fi
else
    echo -e "  ${C_DIM}Borders${C_RESET}          ${C_DIM}not running${C_RESET}"
fi

echo ""
echo -e "  ${C_GREEN}Complete${C_RESET}"
echo ""
