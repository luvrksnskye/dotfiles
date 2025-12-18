#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  GREETING  *:･ﾟ✧*:･ﾟ✧                                     │
# │                                                                             │
# │              Time-based Animated Greeting                                   │
# │              Catppuccin Mocha ·                   │
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

# ═══════════════════════════════════════════════════════════════════════════════
# NERD FONT ICONS
# ═══════════════════════════════════════════════════════════════════════════════

ICON_SUN=""         # nf-fa-sun_o
ICON_CLOUD=""       # nf-weather-day_sunny_overcast
ICON_SUNSET="󰖝"      # nf-md-weather_sunset
ICON_MOON=""        # nf-fa-moon_o
ICON_STAR=""        # nf-fa-star
ICON_HEART=""       # nf-fa-heart
ICON_COFFEE=""      # nf-fa-coffee
ICON_SPARKLE="󰫢"     # nf-md-shimmer

# ═══════════════════════════════════════════════════════════════════════════════
# TIME DETECTION
# ═══════════════════════════════════════════════════════════════════════════════

HOUR=$(date +%H)

get_period() {
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

PERIOD=$(get_period)

# ═══════════════════════════════════════════════════════════════════════════════
# ANIMATION
# ═══════════════════════════════════════════════════════════════════════════════

DELAY=0.015
FAST_DELAY=0.008

animate_line() {
    local text="$1"
    local delay="${2:-$DELAY}"
    echo -e "$text"
    sleep $delay
}

type_text() {
    local text="$1"
    local color="${2:-$TEXT}"
    local delay="${3:-0.03}"
    
    echo -ne "$color"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "$R"
}

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

clear
tput civis
trap 'tput cnorm; exit' INT TERM

echo ""
animate_line "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}" $FAST_DELAY
echo ""

case "$PERIOD" in
    morning)
        ICON="$ICON_SUN"
        COLOR="$YELLOW"
        ACCENT="$PEACH"
        GREETING="Good Morning"
        MESSAGE="Rise and shine"
        EXTRA="$ICON_COFFEE Time for coffee?"
        ;;
    afternoon)
        ICON="$ICON_CLOUD"
        COLOR="$SKY"
        ACCENT="$TEAL"
        GREETING="Good Afternoon"
        MESSAGE="Keep up the great work"
        EXTRA="$ICON_STAR You're doing amazing"
        ;;
    evening)
        ICON="$ICON_SUNSET"
        COLOR="$PEACH"
        ACCENT="$MAUVE"
        GREETING="Good Evening"
        MESSAGE="Time to wind down"
        EXTRA="$ICON_HEART Take it easy"
        ;;
    night)
        ICON="$ICON_MOON"
        COLOR="$MAUVE"
        ACCENT="$PINK"
        GREETING="Good Night"
        MESSAGE="Sweet dreams"
        EXTRA="$ICON_SPARKLE Rest well"
        ;;
esac

# Main greeting box
animate_line "    ${MAUVE}╭─────────────────────────────────────────╮${R}" $FAST_DELAY
animate_line "    ${MAUVE}│${R}                                         ${MAUVE}│${R}" $FAST_DELAY
echo -ne "    ${MAUVE}│${R}     ${COLOR}${ICON}${R}  "
type_text "${B}${GREETING}, Skye!${R}" "$COLOR" 0.04
animate_line "    ${MAUVE}│${R}                                         ${MAUVE}│${R}" $FAST_DELAY
echo -ne "    ${MAUVE}│${R}        "
type_text "${MESSAGE}" "$ACCENT" 0.03
animate_line "    ${MAUVE}│${R}                                         ${MAUVE}│${R}" $FAST_DELAY
animate_line "    ${MAUVE}╰─────────────────────────────────────────╯${R}" $FAST_DELAY

echo ""

# Extra message
animate_line "    ${DIM}${ACCENT}${EXTRA}${R}" $DELAY

echo ""

# Date and time
DATE_STR=$(date "+%A, %B %d")
TIME_STR=$(date "+%I:%M %p")

animate_line "    ${DIM}${SUBTEXT0}${DATE_STR}${R}" $DELAY
animate_line "    ${TEXT}${TIME_STR}${R}" $DELAY

echo ""
animate_line "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}" $FAST_DELAY
echo ""

tput cnorm
