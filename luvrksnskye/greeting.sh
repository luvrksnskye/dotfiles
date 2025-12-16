#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        ANIMATED GREETING                                   ║
# ║                 Time-based message with ASCII art                          ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Colors - Catppuccin Mocha (True Color)
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_LAVENDER='\033[38;2;180;190;254m'
C_PINK='\033[38;2;245;194;231m'
C_MAUVE='\033[38;2;203;166;247m'
C_BLUE='\033[38;2;137;180;250m'
C_SKY='\033[38;2;137;220;235m'
C_TEAL='\033[38;2;148;226;213m'
C_GREEN='\033[38;2;166;227;161m'
C_YELLOW='\033[38;2;249;226;175m'
C_PEACH='\033[38;2;250;179;135m'
C_TEXT='\033[38;2;205;214;244m'

# Animation delay
DELAY=0.03
FAST_DELAY=0.015

# Get current hour
HOUR=$(date +%H)

# Determine greeting based on time
get_greeting() {
    if [ $HOUR -ge 5 ] && [ $HOUR -lt 12 ]; then
        echo "morning"
    elif [ $HOUR -ge 12 ] && [ $HOUR -lt 17 ]; then
        echo "afternoon"
    elif [ $HOUR -ge 17 ] && [ $HOUR -lt 21 ]; then
        echo "evening"
    else
        echo "night"
    fi
}

# Animate text character by character
animate_text() {
    local text="$1"
    local color="${2:-$C_TEXT}"
    local delay="${3:-$DELAY}"
    
    echo -ne "$color"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "$C_RESET"
}

# Animate line by line
animate_block() {
    local color="$1"
    shift
    for line in "$@"; do
        echo -e "${color}${line}${C_RESET}"
        sleep $FAST_DELAY
    done
}

# Clear and hide cursor
clear
tput civis

# Trap to restore cursor on exit
trap 'tput cnorm; exit' INT TERM

PERIOD=$(get_greeting)

case "$PERIOD" in
    morning)
        COLOR=$C_YELLOW
        sleep 0.2
        animate_block "$C_PEACH" \
            "" \
            "" \
            ""
        
        sleep 0.3
        echo ""
        animate_text "  ╭─────────────────────────────────────╮" "$C_LAVENDER" $FAST_DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Good Morning, Skye!" "$C_YELLOW" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Rise and shine " "$C_PEACH" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  ╰─────────────────────────────────────╯" "$C_LAVENDER" $FAST_DELAY
        ;;
        
    afternoon)
        COLOR=$C_SKY
        sleep 0.2
        animate_block "$C_SKY" \
            "" \
            "" \
            ""
        
        sleep 0.3
        echo ""
        animate_text "  ╭─────────────────────────────────────╮" "$C_LAVENDER" $FAST_DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Good Afternoon, Skye!" "$C_SKY" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Keep up the great work  flexing_biceps" "$C_TEAL" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  ╰─────────────────────────────────────╯" "$C_LAVENDER" $FAST_DELAY
        ;;
        
    evening)
        COLOR=$C_PEACH
        sleep 0.2
        animate_block "$C_PEACH" \
            "" \
            "" \
            ""
        
        sleep 0.3
        echo ""
        animate_text "  ╭─────────────────────────────────────╮" "$C_LAVENDER" $FAST_DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Good Evening, Skye!" "$C_PEACH" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Time to wind down " "$C_MAUVE" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  ╰─────────────────────────────────────╯" "$C_LAVENDER" $FAST_DELAY
        ;;
        
    night)
        COLOR=$C_MAUVE
        sleep 0.2
        animate_block "$C_MAUVE" \
            "" \
            "" \
            ""
        
        sleep 0.3
        echo ""
        animate_text "  ╭─────────────────────────────────────╮" "$C_LAVENDER" $FAST_DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Good Night, Skye!" "$C_MAUVE" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  │   Sweet dreams " "$C_PINK" $DELAY
        echo -e "  ${C_LAVENDER}│${C_RESET}"
        animate_text "  ╰─────────────────────────────────────╯" "$C_LAVENDER" $FAST_DELAY
        ;;
esac

echo ""

# Show date and time
TIME=$(date "+%A, %B %d")
CLOCK=$(date "+%I:%M %p")

sleep 0.2
echo -e "  ${C_DIM}${TIME}${C_RESET}"
echo -e "  ${C_TEXT}${CLOCK}${C_RESET}"
echo ""

# Restore cursor
tput cnorm
