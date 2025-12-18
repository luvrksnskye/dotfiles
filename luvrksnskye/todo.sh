#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  TODO LIST  *:･ﾟ✧*:･ﾟ✧                                        │
# │                                                                             │
# │              Cute Task Manager                                              │
# │              Catppuccin Mocha                                               │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS — Catppuccin Mocha 
# ═══════════════════════════════════════════════════════════════════════════════

R='\033[0m'
B='\033[1m'
DIM='\033[2m'
STRIKE='\033[9m'

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

ICON_TODO=""        # nf-fa-tasks
ICON_CHECK=""       # nf-fa-check
ICON_CIRCLE=""      # nf-fa-circle
ICON_CIRCLE_O=""    # nf-fa-circle_o
ICON_STAR=""        # nf-fa-star
ICON_DIAMOND=""     # nf-fa-diamond
ICON_HEART=""       # nf-fa-heart
ICON_ADD=""         # nf-fa-plus
ICON_DELETE=""      # nf-fa-trash
ICON_EDIT=""        # nf-fa-pencil
ICON_LIST=""        # nf-fa-list
ICON_CLOCK=""       # nf-fa-clock_o
ICON_ARROW=""       # nf-fa-angle_right

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

DATA_DIR="$HOME/.local/share/luvrksnskye"
TODO_FILE="$DATA_DIR/todos.txt"
DONE_FILE="$DATA_DIR/todos_done.txt"
mkdir -p "$DATA_DIR"

touch "$TODO_FILE" "$DONE_FILE"

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
# TASK FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

count_tasks() {
    wc -l < "$TODO_FILE" | tr -d ' '
}

count_done() {
    wc -l < "$DONE_FILE" | tr -d ' '
}

add_task() {
    local task="$1"
    local priority="${2:-normal}"
    local timestamp=$(date '+%Y-%m-%d %H:%M')
    
    echo "${priority}|${timestamp}|${task}" >> "$TODO_FILE"
}

get_task() {
    local num=$1
    sed -n "${num}p" "$TODO_FILE"
}

delete_task() {
    local num=$1
    sed -i.bak "${num}d" "$TODO_FILE"
    rm -f "$TODO_FILE.bak"
}

complete_task() {
    local num=$1
    local task=$(get_task $num)
    
    if [ -n "$task" ]; then
        echo "$(date '+%Y-%m-%d %H:%M')|${task}" >> "$DONE_FILE"
        delete_task $num
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY TASKS
# ═══════════════════════════════════════════════════════════════════════════════

display_tasks() {
    local count=$(count_tasks)
    
    if [ "$count" -eq 0 ]; then
        echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
        echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}     ${PINK}${ICON_STAR}${R} ${DIM}${SUBTEXT0}No tasks yet!${R}                      ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}       ${DIM}${OVERLAY0}Add one with [a]${R}                   ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
        echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
        return
    fi
    
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}  ${PINK}${B}${ICON_LIST} YOUR TASKS${R}  ${DIM}(${count} total)${R}                 ${MAUVE}│${R}"
    echo -e "    ${MAUVE}├───────────────────────────────────────────┤${R}"
    
    local i=1
    while IFS='|' read -r priority timestamp task; do
        local pcolor="$TEXT"
        local picon="$ICON_CIRCLE_O"
        case "$priority" in
            high)
                pcolor="$RED"
                picon="$ICON_DIAMOND"
                ;;
            medium)
                pcolor="$YELLOW"
                picon="$ICON_STAR"
                ;;
            low)
                pcolor="$TEAL"
                picon="$ICON_CIRCLE_O"
                ;;
        esac
        
        local display_task="$task"
        if [ ${#task} -gt 30 ]; then
            display_task="${task:0:27}..."
        fi
        
        printf "    ${MAUVE}│${R}   ${LAVENDER}[%d]${R} ${pcolor}${picon}${R} ${TEXT}%-30s${R}  ${MAUVE}│${R}\n" "$i" "$display_task"
        
        i=$((i + 1))
    done < "$TODO_FILE"
    
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

show_todo() {
    clear
    hide_cursor
    
    local total=$(count_tasks)
    local done=$(count_done)
    
    echo ""
    echo -e "    ${PINK}*${MAUVE}.${LAVENDER}.${PINK}*${LAVENDER}.${MAUVE}.${PINK}*  ${MAUVE}*${LAVENDER}.${PINK}.${MAUVE}*${PINK}.${LAVENDER}.${MAUVE}*  ${LAVENDER}*${PINK}.${MAUVE}.${LAVENDER}*${MAUVE}.${PINK}.${LAVENDER}*${R}"
    echo ""
    
    echo -e "    ${PINK}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}│${R}     ${MAUVE}${ICON_TODO}${R} ${B}${TEXT}T O D O   L I S T${R}                  ${PINK}│${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}│${R}     ${SUBTEXT0}Tasks: ${TEXT}$total${R}  ${SUBTEXT0}|${R}  ${SUBTEXT0}Done today: ${GREEN}$done${R}   ${PINK}│${R}"
    echo -e "    ${PINK}│${R}                                           ${PINK}│${R}"
    echo -e "    ${PINK}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    display_tasks
    
    echo ""
    echo -e "    ${LAVENDER}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${LAVENDER}│${R}  ${SKY}${B}${ICON_STAR} ACTIONS${R}                                ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}├───────────────────────────────────────────┤${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[a]${R} ${TEXT}${ICON_ADD} Add task${R}     ${MAUVE}[d]${R} ${TEXT}${ICON_DELETE} Delete${R}        ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[c]${R} ${TEXT}${ICON_CHECK} Complete${R}    ${MAUVE}[e]${R} ${TEXT}${ICON_EDIT} Edit${R}          ${LAVENDER}│${R}"
    echo -e "    ${LAVENDER}│${R}   ${MAUVE}[v]${R} ${TEXT}${ICON_LIST} View done${R}   ${MAUVE}[x]${R} ${TEXT}${ICON_DELETE} Clear done${R}   ${LAVENDER}│${R}"
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
# ADD TASK
# ═══════════════════════════════════════════════════════════════════════════════

add_task_interactive() {
    clear
    echo ""
    echo -e "    ${MAUVE}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}     ${PINK}${ICON_ADD}${R} ${B}${TEXT}Add New Task${R}                        ${MAUVE}│${R}"
    echo -e "    ${MAUVE}│${R}                                           ${MAUVE}│${R}"
    echo -e "    ${MAUVE}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    echo -ne "    ${TEXT}Task: ${R}"
    show_cursor
    read -r task
    
    if [ -z "$task" ]; then
        return
    fi
    
    echo ""
    echo -e "    ${LAVENDER}Priority:${R}"
    echo -e "    ${RED}[1]${R} ${ICON_DIAMOND} High   ${YELLOW}[2]${R} ${ICON_STAR} Medium   ${TEAL}[3]${R} ${ICON_CIRCLE_O} Low"
    echo -ne "    ${TEXT}Choose (1-3): ${R}"
    read -n 1 priority_choice
    echo ""
    
    local priority="normal"
    case "$priority_choice" in
        1) priority="high" ;;
        2) priority="medium" ;;
        3) priority="low" ;;
    esac
    
    add_task "$task" "$priority"
    
    echo ""
    echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Task added!${R}"
    sleep 0.5
}

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE TASK
# ═══════════════════════════════════════════════════════════════════════════════

complete_task_interactive() {
    local count=$(count_tasks)
    
    if [ "$count" -eq 0 ]; then
        echo -e "    ${YELLOW}No tasks to complete${R}"
        sleep 1
        return
    fi
    
    echo ""
    echo -ne "    ${TEXT}Complete task #: ${R}"
    show_cursor
    read num
    
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$count" ]; then
        complete_task "$num"
        echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Task completed! Great job!${R} ${PINK}${ICON_HEART}${R}"
        sleep 0.5
    else
        echo -e "    ${RED}Invalid task number${R}"
        sleep 0.5
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# DELETE TASK
# ═══════════════════════════════════════════════════════════════════════════════

delete_task_interactive() {
    local count=$(count_tasks)
    
    if [ "$count" -eq 0 ]; then
        echo -e "    ${YELLOW}No tasks to delete${R}"
        sleep 1
        return
    fi
    
    echo ""
    echo -ne "    ${TEXT}Delete task #: ${R}"
    show_cursor
    read num
    
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$count" ]; then
        delete_task "$num"
        echo -e "    ${RED}${ICON_DELETE}${R} ${TEXT}Task deleted${R}"
        sleep 0.5
    else
        echo -e "    ${RED}Invalid task number${R}"
        sleep 0.5
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# VIEW DONE TASKS
# ═══════════════════════════════════════════════════════════════════════════════

view_done() {
    clear
    echo ""
    echo -e "    ${GREEN}╭───────────────────────────────────────────╮${R}"
    echo -e "    ${GREEN}│${R}                                           ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}     ${PINK}${ICON_CHECK}${R} ${B}${TEXT}Completed Tasks${R}                    ${GREEN}│${R}"
    echo -e "    ${GREEN}│${R}                                           ${GREEN}│${R}"
    echo -e "    ${GREEN}╰───────────────────────────────────────────╯${R}"
    echo ""
    
    if [ ! -s "$DONE_FILE" ]; then
        echo -e "    ${DIM}${SUBTEXT0}No completed tasks yet${R}"
    else
        local i=1
        while IFS='|' read -r done_time priority timestamp task; do
            echo -e "    ${GREEN}${ICON_CHECK}${R} ${DIM}${STRIKE}${task}${R}"
            echo -e "      ${DIM}${OVERLAY0}${ICON_CLOCK} ${done_time}${R}"
            echo ""
            i=$((i + 1))
            
            if [ $i -gt 10 ]; then
                echo -e "    ${DIM}... and more${R}"
                break
            fi
        done < <(tail -r "$DONE_FILE" 2>/dev/null || tac "$DONE_FILE" 2>/dev/null || cat "$DONE_FILE")
    fi
    
    echo ""
    echo -e "    ${DIM}Press any key to go back...${R}"
    read -n 1 -s
}

# ═══════════════════════════════════════════════════════════════════════════════
# CLEAR DONE
# ═══════════════════════════════════════════════════════════════════════════════

clear_done() {
    echo ""
    echo -ne "    ${YELLOW}Clear all completed tasks? (y/n): ${R}"
    read -n 1 confirm
    echo ""
    
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        > "$DONE_FILE"
        echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Done list cleared${R}"
        sleep 0.5
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# EDIT TASK
# ═══════════════════════════════════════════════════════════════════════════════

edit_task_interactive() {
    local count=$(count_tasks)
    
    if [ "$count" -eq 0 ]; then
        echo -e "    ${YELLOW}No tasks to edit${R}"
        sleep 1
        return
    fi
    
    echo ""
    echo -ne "    ${TEXT}Edit task #: ${R}"
    show_cursor
    read num
    
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$count" ]; then
        local old_task=$(get_task $num)
        IFS='|' read -r old_priority old_time old_text <<< "$old_task"
        
        echo -e "    ${DIM}Current: ${old_text}${R}"
        echo -ne "    ${TEXT}New text (enter to keep): ${R}"
        read new_text
        
        if [ -z "$new_text" ]; then
            new_text="$old_text"
        fi
        
        delete_task "$num"
        add_task "$new_text" "$old_priority"
        
        echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Task updated${R}"
        sleep 0.5
    else
        echo -e "    ${RED}Invalid task number${R}"
        sleep 0.5
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# COMMAND LINE INTERFACE
# ═══════════════════════════════════════════════════════════════════════════════

case "$2" in
    add|a)
        shift 2
        if [ -n "$*" ]; then
            add_task "$*" "normal"
            echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Task added: $*${R}"
        else
            echo -e "    ${RED}Usage: luvr todo add <task>${R}"
        fi
        exit 0
        ;;
    list|ls|l)
        echo ""
        display_tasks
        echo ""
        exit 0
        ;;
    done|d)
        shift 2
        if [ -n "$1" ]; then
            complete_task "$1"
            echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}Task completed!${R}"
        fi
        exit 0
        ;;
esac

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN LOOP
# ═══════════════════════════════════════════════════════════════════════════════

while true; do
    show_todo
    read -n 1 choice
    echo ""
    
    case "$choice" in
        a|A) add_task_interactive ;;
        c|C) complete_task_interactive ;;
        d|D) delete_task_interactive ;;
        e|E) edit_task_interactive ;;
        v|V) view_done ;;
        x|X) clear_done ;;
        q|Q)
            clear
            exit 0
            ;;
    esac
done
