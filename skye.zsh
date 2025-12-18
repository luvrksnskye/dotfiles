# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           SKYE'S ZSH CONFIG                                ║
# ║                                                                            ║
# ║                  Add to ~/.zshrc: source ~/.config/skye.zsh                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                              PATH                                          │
# └────────────────────────────────────────────────────────────────────────────┘

export PATH="$HOME/.config/luvrksnskye:$PATH"

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                              ALIASES                                       │
# └────────────────────────────────────────────────────────────────────────────┘

# System
alias cls="clear"
# alias reload="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias whoiam="luvrksnskye whoami"

# Function to reload everything
unalias reload &>/dev/null
reload() {
    echo "Reloading Zsh configuration..."
    source ~/.zshrc

    echo "Reloading yabai..."
    yabai --restart-service

    echo "Reloading skhd..."
    skhd --reload

    echo "Reloading sketchybar..."
    brew services restart sketchybar

    echo "Reloading borders..."
    brew services restart borders

    echo "All configurations reloaded successfully!"
}

# Recording mode - stops yabai completely
rec-mode() {
    echo "🎬 Stopping yabai for recording..."
    yabai --stop-service
    echo "✅ Yabai stopped. Ready to record!"
}

# Normal mode - starts yabai again
normal-mode() {
    echo "✨ Starting yabai..."
    yabai --start-service
    echo "✅ Yabai running. Back to normal!"
}


# Editor
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias v.="nvim ."

# Tools
alias nf="neofetch"
alias cv="cava"
alias f="open -a Finder ."
alias rain="terminal-rain"

# Apps
alias brave="open -a 'Brave Browser'"
alias zen="open -a 'Zen Browser'"
alias g="open -a Ghostty"

# Yabai & skhd
alias yr="yabai --restart-service"
alias sr="skhd --reload"
alias sbr="brew services restart sketchybar"
alias br="brew services restart borders"

# luvrksnskye shortcuts
alias luvr="luvrksnskye"
alias wall="luvrksnskye wall"
alias wallr="luvrksnskye wall-random"
alias keys="luvrksnskye keys"

# New Autocomplete Aliases
alias kcg="kew cure great"
alias k="kew"
alias momo="momoisay freestyle"
alias gem="gemini"
alias wttr="curl wttr.in"

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                             FUNCTIONS                                      │
# └────────────────────────────────────────────────────────────────────────────┘

# Create and enter directory
mkcd() { 
    mkdir -p "$1" && cd "$1"
}

# Weather
weather() { 
    curl -s "wttr.in/${1:-Caracas}?format=3"
}

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

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                            COMPLETION                                      │
# └────────────────────────────────────────────────────────────────────────────┘

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Custom Autocomplete Functions
_autocomplete_kcg() {
    compadd "kew cure great"
}
compdef _autocomplete_kcg kcg

_autocomplete_k() {
    compadd "kew"
}
compdef _autocomplete_k k

_autocomplete_momo() {
    compadd "momoisay freestyle"
}
compdef _autocomplete_momo momo

_autocomplete_gem() {
    compadd "gemini"
}
compdef _autocomplete_gem gem

_autocomplete_wttr() {
    compadd "curl wttr.in"
}
compdef _autocomplete_wttr wttr

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                              HISTORY                                       │
# └────────────────────────────────────────────────────────────────────────────┘

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                     WALLPAPER FUNCTIONS                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

wallf() { luvrksnskye wall-set "$1" "fade"; }
wallg() { luvrksnskye wall-set "$1" "grow"; }
wallw() { luvrksnskye wall-set "$1" "wave"; }
wallx() { luvrksnskye wall-set "$1" "liquid"; }
walls() { luvrksnskye wall-set "$1" "spiral"; }
wallz() { luvrksnskye wall-set "$1" "fold"; }