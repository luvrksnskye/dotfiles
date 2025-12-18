#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  POMODORO TIMER  *:･ﾟ✧*:･ﾟ✧                               │
# │                                                                             │
# │              Focus Time with Style                                          │
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
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

WORK_TIME=25      # minutes
SHORT_BREAK=5     # minutes
LONG_BREAK=15     # minutes
SESSIONS_BEFORE_LONG=4

DATA_DIR="$HOME/.local/share/luvrksnskye"
STATS_FILE="$DATA_DIR/pomodoro_stats.txt"
mkdir -p "$DATA_DIR"

# ═══════════════════════════════════════════════════════════════════════════════
# UTILITIES
# ═══════════════════════════════════════════════════════════════════════════════

hide_cursor() { tput civis 2>/dev/null; }
show_cursor() { tput cnorm 2>/dev/null; }

cleanup() {
    show_cursor
    echo -e "$R"
    stty echo 2>/dev/null
}
trap cleanup EXIT INT TERM

notify() {
    local message="$1"
    local title="${2:-Pomodoro}"
    osascript -e "display notification \"${message}\" with title \"${title}\" sound name \"Glass\"" 2>/dev/null
}

play_sound() {
    # Try to play a gentle sound
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
}

# ═══════════════════════════════════════════════════════════════════════════════
# UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════════

draw_tomato() {
    local color="$1"
    echo -e "${color}"
    echo "           🍅"
    echo -e "${R}"
}

draw_progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local filled=$(( (current * width) / total ))
    local empty=$(( width - filled ))
    local color="$3"
    
    printf "    ${SURFACE1}["
    printf "${color}"
    for ((i=0; i<filled; i++)); do printf "━"; done
    printf "${SURFACE1}"
    for ((i=0; i<empty; i++)); do printf "─"; done
    printf "]${R}"
}

format_time() {
    local seconds=$1
    printf "%02d:%02d" $((seconds / 60)) $((seconds % 60))
}

# ═══════════════════════════════════════════════════════════════════════════════
# TIMER DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

show_timer() {
    local remaining=$1
    local total=$2
    local session_type="$3"
    local session_num=$4
    local color="$5"
    
    clear
    hide_cursor
    
    echo ""
    echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧  ${LAVENDER}✧${PINK}·${MAUVE}˚${LAVENDER}❀${MAUVE}˚${PINK}·${LAVENDER}✧${R}"
    echo ""
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${PINK}✧${R} ${B}${TEXT}P O M O D O R O${R} ${PINK}✧${R}                  ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    # Session info
    echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
    if [ "$session_type" = "work" ]; then
        echo -e "    ${LAVENDER}│${R}     ${RED}☕${R} ${TEXT}Focus Time${R}  ${DIM}Session $session_num${R}            ${LAVENDER}│${R}"
    elif [ "$session_type" = "short" ]; then
        echo -e "    ${LAVENDER}│${R}     ${GREEN}🌿${R} ${TEXT}Short Break${R}                        ${LAVENDER}│${R}"
    else
        echo -e "    ${LAVENDER}│${R}     ${SKY}✨${R} ${TEXT}Long Break${R}  ${DIM}You earned it!${R}         ${LAVENDER}│${R}"
    fi
    echo -e "    ${LAVENDER}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    # Big timer display
    local time_str=$(format_time $remaining)
    echo -e "    ${SURFACE1}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${SURFACE1}│${R}                                           ${SURFACE1}│${R}"
    echo -e "    ${SURFACE1}│${R}              ${B}${color}  $time_str  ${R}               ${SURFACE1}│${R}"
    echo -e "    ${SURFACE1}│${R}                                           ${SURFACE1}│${R}"
    echo -e "    ${SURFACE1}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    # Progress bar
    draw_progress_bar $((total - remaining)) $total "$color"
    echo ""
    echo ""
    
    # Controls
    echo -e "    ${DIM}${OVERLAY0}[space] pause  [s] skip  [q] quit${R}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN TIMER
# ═══════════════════════════════════════════════════════════════════════════════

run_timer() {
    local duration=$1
    local session_type="$2"
    local session_num=$3
    local color="$4"
    
    local total_seconds=$((duration * 60))
    local remaining=$total_seconds
    local paused=false
    
    # Non-blocking input
    stty -echo -icanon time 0 min 0 2>/dev/null
    
    while [ $remaining -gt 0 ]; do
        show_timer $remaining $total_seconds "$session_type" $session_num "$color"
        
        # Check for input
        key=$(dd bs=1 count=1 2>/dev/null)
        
        case "$key" in
            ' ')
                if $paused; then
                    paused=false
                else
                    paused=true
                    echo -e "    ${YELLOW}⏸  PAUSED${R}  ${DIM}Press space to resume${R}"
                fi
                ;;
            's'|'S')
                stty echo icanon 2>/dev/null
                return 1  # Skip
                ;;
            'q'|'Q')
                stty echo icanon 2>/dev/null
                return 2  # Quit
                ;;
        esac
        
        if ! $paused; then
            sleep 1
            remaining=$((remaining - 1))
        else
            sleep 0.1
        fi
    done
    
    stty echo icanon 2>/dev/null
    return 0  # Completed
}

# ═══════════════════════════════════════════════════════════════════════════════
# SESSION COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════

session_complete() {
    local session_type="$1"
    
    play_sound
    
    if [ "$session_type" = "work" ]; then
        notify "Focus session complete! Time for a break 🌿" "Pomodoro"
    else
        notify "Break over! Ready to focus? ☕" "Pomodoro"
    fi
    
    clear
    echo ""
    echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧${R}"
    echo ""
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    
    if [ "$session_type" = "work" ]; then
        echo -e "    ${MAUVE}│${R}     ${GREEN}✓${R} ${B}${TEXT}Focus session complete!${R}            ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}       ${SUBTEXT0}Time for a well-deserved break${R}    ${MAUVE}│${R}"
    else
        echo -e "    ${MAUVE}│${R}     ${SKY}✦${R} ${B}${TEXT}Break over!${R}                         ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}       ${SUBTEXT0}Ready to focus again?${R}              ${MAUVE}│${R}"
    fi
    
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    echo -e "    ${DIM}Press any key to continue...${R}"
    
    show_cursor
    read -n 1 -s
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN MENU
# ═══════════════════════════════════════════════════════════════════════════════

show_menu() {
    clear
    hide_cursor
    
    echo ""
    echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧  ${LAVENDER}✧${PINK}·${MAUVE}˚${LAVENDER}❀${MAUVE}˚${PINK}·${LAVENDER}✧${R}"
    echo ""
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${PINK}🍅${R} ${B}${TEXT}P O M O D O R O${R}                     ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${DIM}${SUBTEXT0}Focus. Rest. Repeat.${R}                 ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${LAVENDER}│${R}  ${PINK}${B}❀ START${R}                                   ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}├───────────────────────────────────────────┤${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[1]${R} ${TEXT}Quick session${R}     ${DIM}25 min${R}           ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[2]${R} ${TEXT}Full pomodoro${R}     ${DIM}4 sessions${R}       ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[3]${R} ${TEXT}Custom timer${R}      ${DIM}set time${R}         ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${PINK}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${PINK}│${R}  ${SKY}${B}✦ CURRENT SETTINGS${R}                       ${PINK}│${R}"
    echo -e "    ${PINK}├───────────────────────────────────────────┤${R}"
    echo -e "    ${PINK}│${R}   ${SUBTEXT0}Focus:${R}       ${TEXT}${WORK_TIME} minutes${R}               ${PINK}│${R}"
    echo -e "    ${PINK}│${R}   ${SUBTEXT0}Short break:${R} ${TEXT}${SHORT_BREAK} minutes${R}                ${PINK}│${R}"
    echo -e "    ${PINK}│${R}   ${SUBTEXT0}Long break:${R}  ${TEXT}${LONG_BREAK} minutes${R}               ${PINK}│${R}"
    echo -e "    ${PINK}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -e "    ${SURFACE1}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${SURFACE1}│${R}   ${RED}[q]${R} ${SUBTEXT0}Quit${R}                                 ${SURFACE1}│${R}"
    echo -e "    ${SURFACE1}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -ne "    ${PINK}❀${R} ${TEXT}Choose: ${R}"
    show_cursor
}

# ═══════════════════════════════════════════════════════════════════════════════
# QUICK SESSION
# ═══════════════════════════════════════════════════════════════════════════════

quick_session() {
    run_timer $WORK_TIME "work" 1 "$RED"
    local result=$?
    
    if [ $result -eq 0 ]; then
        session_complete "work"
        # Log stats
        echo "$(date '+%Y-%m-%d %H:%M') - Completed focus session ($WORK_TIME min)" >> "$STATS_FILE"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# FULL POMODORO
# ═══════════════════════════════════════════════════════════════════════════════

full_pomodoro() {
    local session=1
    
    while [ $session -le $SESSIONS_BEFORE_LONG ]; do
        # Work session
        run_timer $WORK_TIME "work" $session "$RED"
        local result=$?
        
        if [ $result -eq 2 ]; then
            return  # User quit
        fi
        
        if [ $result -eq 0 ]; then
            session_complete "work"
            echo "$(date '+%Y-%m-%d %H:%M') - Completed focus session $session ($WORK_TIME min)" >> "$STATS_FILE"
        fi
        
        # Break
        if [ $session -eq $SESSIONS_BEFORE_LONG ]; then
            # Long break after 4 sessions
            run_timer $LONG_BREAK "long" $session "$SKY"
            result=$?
        else
            # Short break
            run_timer $SHORT_BREAK "short" $session "$GREEN"
            result=$?
        fi
        
        if [ $result -eq 2 ]; then
            return  # User quit
        fi
        
        if [ $result -eq 0 ]; then
            session_complete "break"
        fi
        
        session=$((session + 1))
    done
    
    # Celebrate!
    clear
    echo ""
    echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧${R}"
    echo ""
    echo -e "    ${GREEN}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${GREEN}│${R}                                           ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}     ${YELLOW}🎉${R} ${B}${TEXT}Amazing work!${R} ${YELLOW}🎉${R}                  ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}                                           ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}     ${SUBTEXT0}You completed a full pomodoro!${R}        ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}     ${SUBTEXT0}4 focus sessions = 100 minutes${R}        ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}                                           ${GREEN}│${R}"
    echo -e "    ${GREEN}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    notify "🎉 Full pomodoro complete! You're amazing!" "Pomodoro"
    
    echo -e "    ${DIM}Press any key to continue...${R}"
    read -n 1 -s
}

# ═══════════════════════════════════════════════════════════════════════════════
# CUSTOM TIMER
# ═══════════════════════════════════════════════════════════════════════════════

custom_timer() {
    clear
    echo ""
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${PINK}⏱${R}  ${B}${TEXT}Custom Timer${R}                       ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -ne "    ${TEXT}Enter minutes (1-120): ${R}"
    show_cursor
    read minutes
    
    if [[ "$minutes" =~ ^[0-9]+$ ]] && [ "$minutes" -ge 1 ] && [ "$minutes" -le 120 ]; then
        run_timer "$minutes" "work" 1 "$PEACH"
        local result=$?
        
        if [ $result -eq 0 ]; then
            session_complete "work"
            echo "$(date '+%Y-%m-%d %H:%M') - Completed custom session ($minutes min)" >> "$STATS_FILE"
        fi
    else
        echo -e "    ${RED}Invalid input${R}"
        sleep 1
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════════

# Handle command line args
case "$1" in
    quick|q|1)
        quick_session
        exit 0
        ;;
    full|f|2)
        full_pomodoro
        exit 0
        ;;
    [0-9]*)
        WORK_TIME="$1"
        quick_session
        exit 0
        ;;
esac

# Interactive menu
while true; do
    show_menu
    read -n 1 choice
    echo ""
    
    case "$choice" in
        1)
            quick_session
            ;;
        2)
            full_pomodoro
            ;;
        3)
            custom_timer
            ;;
        q|Q)
            clear
            echo ""
            echo -e "    ${PINK}✧${R} ${TEXT}Stay focused! ${PINK}♡${R}"
            echo ""
            exit 0
            ;;
    esac
done
