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
alias reload="source ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

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