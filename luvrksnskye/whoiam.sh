#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                             WHOIAM                                        ║
# ║                       Custom User Info Display                             ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Catppuccin Mocha Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_ROSEWATER='\033[38;5;223m'
C_FLAMINGO='\033[38;5;216m'
C_PINK='\033[38;5;218m'
C_MAUVE='\033[38;5;141m'
C_RED='\033[38;5;203m'
C_MAROON='\033[38;5;209m'
C_PEACH='\033[38;5;216m'
C_YELLOW='\033[38;5;222m'
C_GREEN='\033[38;5;114m'
C_TEAL='\033[38;5;116m'
C_SKY='\033[38;5;117m'
C_SAPPHIRE='\033[38;5;81m'
C_BLUE='\033[38;5;111m'
C_LAVENDER='\033[38;5;183m'
C_TEXT='\033[38;5;189m'
C_SUBTEXT0='\033[38;5;245m'

# Get system information
USER=$(whoami)
HOSTNAME=$(hostname -s)
OS=$(sw_vers -productName)
OS_VERSION=$(sw_vers -productVersion)
UPTIME=$(uptime | sed 's/.*up \([^,]*\),.*/\1/')
SHELL=$(basename "$SHELL")
DATE=$(date "+%A, %B %d, %Y")
TIME=$(date "+%I:%M %p")

# ANSI color gradient function
gradient_print() {
    local text="$1"
    local colors=("$C_LAVENDER" "$C_MAUVE" "$C_PINK" "$C_PEACH" "$C_YELLOW")
    local len=${#text}
    local num_colors=${#colors[@]}
    local output=""
    
    for ((i=0; i<len; i++)); do
        local color_index=$((i * num_colors / len))
        local color=${colors[$color_index]}
        output+="${color}${text:$i:1}"
    done
    
    echo -e "$output$C_RESET"
}

clear

# ASCII art cat
echo ""
gradient_print "⧣+ ̊.✦+ ⧣+ ̊ 𓂃★ ⸝⸝ ⧣+ ̊.✦+ ⧣+ ̊"
echo -e "${C_MAUVE} /) /)        ${C_PINK}╭──────────────────────────────╮"
echo -e "${C_MAUVE}(。•ᄉ•。)      ${C_PINK}│                              │"
echo -e "${C_MAUVE} (${C_PINK}\(${C_MAUVE})${C_PINK})${C_MAUVE}        ${C_PINK}│   ${C_YELLOW}User Info${C_PINK}                   │"
echo -e "${C_PINK}          │                              │"
echo -e "${C_PINK}          ╰──────────────────────────────╯"
echo ""
gradient_print "luvrksnskye!"
echo ""

# User information
echo -e "${C_LAVENDER}✦+ ˊ˗"
echo -e "${C_MAUVE}.╭∪─∪──────────${C_LAVENDER} ✦ +."
echo -e "${C_MAUVE}.┊ ◟@${C_RESET} User     : ${C_BOLD}${C_YELLOW}$USER${C_RESET}"
echo -e "${C_MAUVE}.┊.𐐪${C_RESET} Uptime   : ${C_TEAL}$UPTIME${C_RESET}"
echo -e "${C_MAUVE}.┊ꜝꜝ.${C_RESET}Pronouns : ${C_PINK}she/they${C_RESET}"
echo -e "${C_MAUVE}.┊ ⨳ ゙${C_RESET}Date     : ${C_PEACH}$DATE${C_RESET}"
echo -e "${C_MAUVE}.┊ ◟ヾ${C_RESET} Shell    : ${C_BLUE}$SHELL${C_RESET}"
echo -e "${C_MAUVE}.┊.𐐪${C_RESET} OS       : ${C_GREEN}$OS $OS_VERSION${C_RESET}"
echo -e "${C_MAUVE}.┊ ◟@${C_RESET} Extra    : ${C_SKY}hai!!!${C_RESET}"
echo -e "${C_MAUVE}╰─────────────${C_LAVENDER} ✦ +.${C_RESET}"
echo ""
gradient_print "⧣+ ̊.✦+ ⧣+ ̊ 𓂃★ ⸝⸝ ⧣+ ̊.✦+ ⧣+ ̊"
echo ""

# Add original whoami output with separator
echo -e "${C_SUBTEXT0}${C_DIM}── Original whoami output ──${C_RESET}"
echo -e "${C_DIM}$(whoami)${C_RESET}"
echo ""