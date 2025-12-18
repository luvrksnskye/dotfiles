#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  MOOD TRACKER  *:･ﾟ✧*:･ﾟ✧                                    │
# │                                                                             │
# │              How are you feeling?                                           │
                  │
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

ICON_HEART=""       # nf-fa-heart
ICON_STAR=""        # nf-fa-star
ICON_SUN=""         # nf-fa-sun_o
ICON_CLOUD=""       # nf-fa-cloud
ICON_BOLT=""        # nf-fa-bolt
ICON_MOON=""        # nf-fa-moon_o
ICON_FIRE=""        # nf-fa-fire
ICON_LEAF=""        # nf-fa-leaf
ICON_CHART=""       # nf-fa-bar_chart
ICON_CALENDAR=""    # nf-fa-calendar
ICON_CLOCK=""       # nf-fa-clock_o
ICON_CHECK=""       # nf-fa-check
ICON_SPARKLE="󰫢"     # nf-md-shimmer

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

DATA_DIR="$HOME/.local/share/luvrksnskye"
MOOD_FILE="$DATA_DIR/mood_log.txt"
mkdir -p "$DATA_DIR"
touch "$MOOD_FILE"

# ═══════════════════════════════════════════════════════════════════════════════
# UTILITIES
# ═══════════════════════════════════════════════════════════════════════════════

hide_cursor() { tput civis 2>/dev/null; }
show_cursor() { tput cnorm 2>/dev/null; }

cleanup() {
    show_cursor
    echo -e "$R"
}
trap cleanup EXIT INT TERM

# ═══════════════════════════════════════════════════════════════════════════════
# MOOD FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

log_mood() {
    local mood="$1"
    local note="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    local day=$(date '+%A')
    
    echo "${timestamp}|${day}|${mood}|${note}" >> "$MOOD_FILE"
}

get_mood_icon() {
    case "$1" in
        amazing)  echo "${GREEN}${ICON_SUN}${R}" ;;
        good)     echo "${TEAL}${ICON_LEAF}${R}" ;;
        okay)     echo "${YELLOW}${ICON_CLOUD}${R}" ;;
        meh)      echo "${PEACH}${ICON_MOON}${R}" ;;
        bad)      echo "${RED}${ICON_BOLT}${R}" ;;
        *)        echo "${LAVENDER}${ICON_STAR}${R}" ;;
    esac
}

get_mood_color() {
    case "$1" in
        amazing)  echo "$GREEN" ;;
        good)     echo "$TEAL" ;;
        okay)     echo "$YELLOW" ;;
        meh)      echo "$PEACH" ;;
        bad)      echo "$RED" ;;
        *)        echo "$LAVENDER" ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

show_mood_tracker() {
    clear
    hide_cursor
    
    echo ""
    echo -e "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}"
    echo ""
    
    echo -e "    ${PINK}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}│${R}     ${MAUVE}${ICON_HEART}${R} ${B}${TEXT}M O O D   T R A C K E R${R}            ${PINK}│${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}│${R}     ${DIM}${SUBTEXT0}How are you feeling today?${R}           ${PINK}│${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}  ${PINK}${B}${ICON_SPARKLE} SELECT YOUR MOOD${R}                       ${MAUVE}│${R}"
    echo -e "    ${MAUVE}├───────────────────────────────────────────┤${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}   ${GREEN}[1]${R} ${ICON_SUN}  ${TEXT}Amazing${R}     ${DIM}feeling great!${R}     ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}   ${TEAL}[2]${R} ${ICON_LEAF}  ${TEXT}Good${R}        ${DIM}pretty good${R}        ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}   ${YELLOW}[3]${R} ${ICON_CLOUD}  ${TEXT}Okay${R}        ${DIM}just okay${R}          ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}   ${PEACH}[4]${R} ${ICON_MOON}  ${TEXT}Meh${R}         ${DIM}not great${R}          ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}   ${RED}[5]${R} ${ICON_BOLT}  ${TEXT}Bad${R}         ${DIM}struggling${R}          ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${LAVENDER}│${R}  ${SKY}${B}${ICON_CHART} OPTIONS${R}                               ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}├───────────────────────────────────────────┤${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[h]${R} ${TEXT}${ICON_CALENDAR} View history${R}                     ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[s]${R} ${TEXT}${ICON_CHART} Stats${R}                             ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${SURFACE1}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${SURFACE1}│${R}   ${RED}[q]${R} ${SUBTEXT0}Back to menu${R}                         ${SURFACE1}│${R}"
    echo -e "    ${SURFACE1}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -ne "    ${PINK}${ICON_HEART}${R} ${TEXT}Choose: ${R}"
    show_cursor
}

# ═══════════════════════════════════════════════════════════════════════════════
# LOG MOOD
# ═══════════════════════════════════════════════════════════════════════════════

log_mood_interactive() {
    local mood="$1"
    local mood_icon=$(get_mood_icon "$mood")
    local mood_color=$(get_mood_color "$mood")
    
    clear
    echo ""
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${mood_icon} ${B}${TEXT}Feeling ${mood_color}${mood}${R}${B}${TEXT}!${R}                     ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${SUBTEXT0}Add a note? (optional, press enter to skip)${R}"
    echo -ne "    ${TEXT}Note: ${R}"
    show_cursor
    read -r note
    
    log_mood "$mood" "$note"
    
    echo ""
    echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Mood logged!${R}"
    echo ""
    
    # Encouraging message based on mood
    case "$mood" in
        amazing)
            echo -e "    ${GREEN}${ICON_SPARKLE}${R} ${TEXT}That's wonderful! Keep shining!${R}"
            ;;
        good)
            echo -e "    ${TEAL}${ICON_LEAF}${R} ${TEXT}Great to hear! You're doing well!${R}"
            ;;
        okay)
            echo -e "    ${YELLOW}${ICON_STAR}${R} ${TEXT}That's okay! Tomorrow is a new day.${R}"
            ;;
        meh)
            echo -e "    ${PEACH}${ICON_HEART}${R} ${TEXT}It's okay to have these days. Be gentle with yourself.${R}"
            ;;
        bad)
            echo -e "    ${PINK}${ICON_HEART}${R} ${TEXT}I'm sorry you're struggling. You're not alone.${R}"
            echo -e "    ${DIM}${SUBTEXT0}Remember: it's okay to ask for help.${R}"
            ;;
    esac
    
    echo ""
    sleep 2
}

# ═══════════════════════════════════════════════════════════════════════════════
# VIEW HISTORY
# ═══════════════════════════════════════════════════════════════════════════════

view_history() {
    clear
    echo ""
    echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${LAVENDER}│${R}                                           ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}     ${PINK}${ICON_CALENDAR}${R} ${B}${TEXT}Mood History${R}                       ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}                                           ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    if [ ! -s "$MOOD_FILE" ]; then
        echo -e "    ${DIM}${SUBTEXT0}No mood entries yet${R}"
        echo ""
        echo -e "    ${DIM}Press any key to go back...${R}"
        read -n 1 -s
        return
    fi
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    
    local count=0
    while IFS='|' read -r timestamp day mood note; do
        if [ $count -ge 14 ]; then
            break
        fi
        
        local mood_icon=$(get_mood_icon "$mood")
        local mood_color=$(get_mood_color "$mood")
        
        # Format date nicely
        local date_part="${timestamp%% *}"
        local time_part="${timestamp#* }"
        
        echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}  ${DIM}${date_part}${R} ${OVERLAY0}${day}${R}                       ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}  ${mood_icon} ${mood_color}${mood}${R} ${DIM}${ICON_CLOCK} ${time_part}${R}                   ${MAUVE}│${R}"
        
        if [ -n "$note" ]; then
            local display_note="$note"
            if [ ${#note} -gt 35 ]; then
                display_note="${note:0:32}..."
            fi
            echo -e "    ${MAUVE}│${R}  ${DIM}\"${display_note}\"${R}"
        fi
        
        count=$((count + 1))
    done < <(tail -r "$MOOD_FILE" 2>/dev/null || tac "$MOOD_FILE" 2>/dev/null || cat "$MOOD_FILE")
    
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    
    echo ""
    echo -e "    ${DIM}Showing last $count entries${R}"
    echo ""
    echo -e "    ${DIM}Press any key to go back...${R}"
    read -n 1 -s
}

# ═══════════════════════════════════════════════════════════════════════════════
# STATS
# ═══════════════════════════════════════════════════════════════════════════════

view_stats() {
    clear
    echo ""
    echo -e "    ${SKY}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${SKY}│${R}                                           ${SKY}│${R}"
    echo -e "    ${SKY}│${R}     ${PINK}${ICON_CHART}${R} ${B}${TEXT}Mood Statistics${R}                    ${SKY}│${R}"
    echo -e "    ${SKY}│${R}                                           ${SKY}│${R}"
    echo -e "    ${SKY}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    if [ ! -s "$MOOD_FILE" ]; then
        echo -e "    ${DIM}${SUBTEXT0}No data yet${R}"
        echo ""
        echo -e "    ${DIM}Press any key to go back...${R}"
        read -n 1 -s
        return
    fi
    
    # Count moods
    local amazing=$(grep -c "|amazing|" "$MOOD_FILE" 2>/dev/null || echo 0)
    local good=$(grep -c "|good|" "$MOOD_FILE" 2>/dev/null || echo 0)
    local okay=$(grep -c "|okay|" "$MOOD_FILE" 2>/dev/null || echo 0)
    local meh=$(grep -c "|meh|" "$MOOD_FILE" 2>/dev/null || echo 0)
    local bad=$(grep -c "|bad|" "$MOOD_FILE" 2>/dev/null || echo 0)
    local total=$((amazing + good + okay + meh + bad))
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}  ${B}${TEXT}Total entries:${R} ${LAVENDER}$total${R}                       ${MAUVE}│${R}"
    echo -e "    ${MAUVE}├───────────────────────────────────────────┤${R}"
    
    # Draw bars
    draw_stat_bar() {
        local label="$1"
        local count="$2"
        local color="$3"
        local icon="$4"
        local max_width=20
        
        local bar_width=0
        if [ $total -gt 0 ]; then
            bar_width=$((count * max_width / total))
        fi
        
        printf "    ${MAUVE}│${R}  ${color}${icon}${R} %-8s " "$label"
        printf "${color}"
        for ((i=0; i<bar_width; i++)); do printf "━"; done
        printf "${SURFACE1}"
        for ((i=bar_width; i<max_width; i++)); do printf "─"; done
        printf "${R} %2d ${MAUVE}│${R}\n" "$count"
    }
    
    draw_stat_bar "Amazing" "$amazing" "$GREEN" "$ICON_SUN"
    draw_stat_bar "Good" "$good" "$TEAL" "$ICON_LEAF"
    draw_stat_bar "Okay" "$okay" "$YELLOW" "$ICON_CLOUD"
    draw_stat_bar "Meh" "$meh" "$PEACH" "$ICON_MOON"
    draw_stat_bar "Bad" "$bad" "$RED" "$ICON_BOLT"
    
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    
    # Calculate average
    if [ $total -gt 0 ]; then
        local score=$((amazing * 5 + good * 4 + okay * 3 + meh * 2 + bad * 1))
        local avg=$((score * 100 / total))
        local avg_int=$((avg / 100))
        local avg_dec=$((avg % 100))
        
        echo ""
        echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
        echo -e "    ${LAVENDER}│${R}  ${TEXT}Average mood score:${R} ${PINK}${avg_int}.${avg_dec}/5${R}             ${LAVENDER}│${R}"
        
        if [ $avg_int -ge 4 ]; then
            echo -e "    ${LAVENDER}│${R}  ${GREEN}${ICON_SPARKLE}${R} ${TEXT}You're doing amazing!${R}                 ${LAVENDER}│${R}"
        elif [ $avg_int -ge 3 ]; then
            echo -e "    ${LAVENDER}│${R}  ${TEAL}${ICON_LEAF}${R} ${TEXT}You're doing well!${R}                    ${LAVENDER}│${R}"
        else
            echo -e "    ${LAVENDER}│${R}  ${PINK}${ICON_HEART}${R} ${TEXT}Remember to take care of yourself${R}     ${LAVENDER}│${R}"
        fi
        
        echo -e "    ${LAVENDER}╰───────────────────────────────────────────╯${R}"
    fi
    
    echo ""
    echo -e "    ${DIM}Press any key to go back...${R}"
    read -n 1 -s
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN LOOP
# ═══════════════════════════════════════════════════════════════════════════════

while true; do
    show_mood_tracker
    read -n 1 choice
    echo ""
    
    case "$choice" in
        1) log_mood_interactive "amazing" ;;
        2) log_mood_interactive "good" ;;
        3) log_mood_interactive "okay" ;;
        4) log_mood_interactive "meh" ;;
        5) log_mood_interactive "bad" ;;
        h|H) view_history ;;
        s|S) view_stats ;;
        q|Q)
            clear
            exit 0
            ;;
    esac
done
