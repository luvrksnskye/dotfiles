# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  SKYE'S ZSH CONFIG  *:･ﾟ✧*:･ﾟ✧                            │
# │                                                                             │
# │              Add to ~/.zshrc: source ~/.config/skye.zsh                     │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ═══════════════════════════════════════════════════════════════════════════════
# PATH
# ═══════════════════════════════════════════════════════════════════════════════

export PATH="$HOME/.config/luvrksnskye:$PATH"

# ═══════════════════════════════════════════════════════════════════════════════
# SUPER SHORT ALIASES - Quick Access
# ═══════════════════════════════════════════════════════════════════════════════

# Main command
alias luvr="luvrksnskye"
alias l="luvrksnskye"

# Wallpaper - SUPER SHORT
alias w="luvrksnskye wall"           # wallpaper selector
alias wr="luvrksnskye random"        # random wallpaper
alias wl="luvrksnskye list"          # list wallpapers
alias ws="luvrksnskye set"           # set wallpaper: ws image.jpg fade

# Productivity - SUPER SHORT
alias p="luvrksnskye pomo"           # pomodoro timer
alias t="luvrksnskye todo"           # todo list
alias m="luvrksnskye mood"           # mood tracker

# System - SUPER SHORT
alias me="luvrksnskye me"            # who am i
alias k="luvrksnskye keys"           # keybindings
alias hi="luvrksnskye greet"         # greeting
alias r="luvrksnskye reload"         # reload services
alias rain="terminal-rain"
# ═══════════════════════════════════════════════════════════════════════════════
# READABLE ALIASES - For clarity
# ═══════════════════════════════════════════════════════════════════════════════

alias wall="luvrksnskye wall"
alias wallr="luvrksnskye random"
alias pomo="luvrksnskye pomo"
alias todo="luvrksnskye todo"
alias mood="luvrksnskye mood"
alias whoiam="luvrksnskye me"
alias keys="luvrksnskye keys"
alias greet="luvrksnskye greet"
alias reload="luvrksnskye reload"

# ═══════════════════════════════════════════════════════════════════════════════
# SYSTEM ALIASES
# ═══════════════════════════════════════════════════════════════════════════════

alias cls="clear"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Editors
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias v.="nvim ."

# Quick open
alias f="open -a Finder ."

# ═══════════════════════════════════════════════════════════════════════════════
# YABAI & SKHD
# ═══════════════════════════════════════════════════════════════════════════════

alias yr="yabai --restart-service"
alias sr="skhd --reload"
alias sbr="brew services restart sketchybar"
alias br="brew services restart borders"

# Recording mode
rec-mode() {
    echo "Stopping yabai for recording..."
    yabai --stop-service
    echo "Ready to record!"
}

normal-mode() {
    echo "Starting yabai..."
    yabai --start-service
    echo "Back to normal!"
}

# ═══════════════════════════════════════════════════════════════════════════════
# APP LAUNCHERS
# ═══════════════════════════════════════════════════════════════════════════════

alias brave="open -a 'Brave Browser'"
alias zen="open -a 'Zen Browser'"
alias ghost="open -a Ghostty"
alias obs="open -a Obsidian"
alias disc="open -a Discord"
alias spot="open -a Spotify"
alias code="open -a 'Visual Studio Code'"

# ═══════════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

# Create and enter directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# Weather
weather() { curl -s "wttr.in/${1:-}?format=3"; }

# Quick extract
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# TODO QUICK COMMANDS
# ═══════════════════════════════════════════════════════════════════════════════

# Quick add todo: ta "buy groceries"
ta() { luvrksnskye todo todo add "$*"; }

# Quick list todos
tl() { luvrksnskye todo todo list; }

# Quick complete: td 1
td() { luvrksnskye todo todo done "$1"; }

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETION
# ═══════════════════════════════════════════════════════════════════════════════

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ═══════════════════════════════════════════════════════════════════════════════
# HISTORY
# ═══════════════════════════════════════════════════════════════════════════════

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ═══════════════════════════════════════════════════════════════════════════════
# QUICK REFERENCE (run 'aliases' to see this)
# ═══════════════════════════════════════════════════════════════════════════════

aliases() {
    echo ""
    echo "  ╭─────────────────────────────────────────────────╮"
    echo "  │         ✧ LUVR Quick Reference ✧               │"
    echo "  ├─────────────────────────────────────────────────┤"
    echo "  │  Command │ Description                          │"
    echo "  ├──────────┼──────────────────────────────────────┤"
    echo "  │  luvr    │ Open interactive menu                │"
    echo "  │  w       │ Wallpaper selector                   │"
    echo "  │  wr      │ Random wallpaper                     │"
    echo "  │  wl      │ List wallpapers                      │"
    echo "  │  ws      │ Set wallpaper (ws img.jpg)           │"
    echo "  │  p       │ Pomodoro timer                       │"
    echo "  │  t       │ Todo list                            │"
    echo "  │  m       │ Mood tracker                         │"
    echo "  │  me      │ Who am I card                        │"
    echo "  │  k       │ Keybindings                          │"
    echo "  │  hi      │ Greeting                             │"
    echo "  │  r       │ Reload services                      │"
    echo "  ├──────────┴──────────────────────────────────────┤"
    echo "  │  TODO: ta 'task' (add)  tl (list)  td 1 (done)  │"
    echo "  ╰─────────────────────────────────────────────────╯"
    echo ""
}
