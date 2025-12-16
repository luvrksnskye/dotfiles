#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            RELOAD CONFIGS                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Colors - Catppuccin Mocha (True Color)
C_RESET='\033[0m'
C_LAVENDER='\033[38;2;180;190;254m'
C_GREEN='\033[38;2;166;227;161m'
C_PINK='\033[38;2;245;194;231m'
C_DIM='\033[38;2;108;112;134m'
C_TEXT='\033[38;2;205;214;244m'

# Function to print a status line
print_status() {
    local service_name="$1"
    local status="$2"
    local color="$3"

    printf "  ${C_TEXT}%-15s ${C_DIM}.................... ${color}%s${C_RESET}\n" "$service_name" "$status"
}

clear
echo -e "\n${C_LAVENDER}  ╭───────────────────────────╮"
echo -e "${C_LAVENDER}  │                           │"
echo -e "${C_LAVENDER}  │   Reloading Services...   │"
echo -e "${C_LAVENDER}  │                           │"
echo -e "${C_LAVENDER}  ╰───────────────────────────╯\n${C_RESET}"

# Reload Yabai
if command -v yabai &> /dev/null; then
    if yabai --restart-service 2>/dev/null; then
        print_status "Yabai" "reloaded" "$C_GREEN"
    else
        print_status "Yabai" "failed" "$C_PINK"
    fi
else
    print_status "Yabai" "not installed" "$C_DIM"
fi

# Reload skhd
if command -v skhd &> /dev/null; then
    if skhd --reload 2>/dev/null; then
        print_status "skhd" "reloaded" "$C_GREEN"
    else
        print_status "skhd" "failed" "$C_PINK"
    fi
else
    print_status "skhd" "not installed" "$C_DIM"
fi

# Reload SketchyBar
if pgrep -x "sketchybar" &> /dev/null; then
    if sketchybar --reload 2>/dev/null; then
        print_status "SketchyBar" "reloaded" "$C_GREEN"
    else
        print_status "SketchyBar" "failed" "$C_PINK"
    fi
else
    print_status "SketchyBar" "not running" "$C_DIM"
fi

# Reload Borders
if pgrep -x "borders" &> /dev/null; then
    if brew services restart borders >/dev/null 2>&1; then
        print_status "Borders" "reloaded" "$C_GREEN"
    else
        print_status "Borders" "failed" "$C_PINK"
    fi
else
    print_status "Borders" "not running" "$C_DIM"
fi

echo -e "\n${C_GREEN}  ✔ All services checked.\n${C_RESET}"

