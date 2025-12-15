#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                                                            ║
# ║   ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                        ║
# ║   ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                        ║
# ║   ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                        ║
# ║   ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                        ║
# ║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗                   ║
# ║   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝                   ║
# ║                                                                            ║
# ║                         Skye's Dotfiles                                    ║
# ║                                                                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_YELLOW='\033[38;5;222m'

print_header() {
    clear
    echo ""
    echo -e "${C_LAVENDER}"
    cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════════╗
    ║                                                                    ║
    ║   ███████╗██╗  ██╗██╗   ██╗███████╗                                ║
    ║   ██╔════╝██║ ██╔╝╚██╗ ██╔╝██╔════╝                                ║
    ║   ███████╗█████╔╝  ╚████╔╝ █████╗                                  ║
    ║   ╚════██║██╔═██╗   ╚██╔╝  ██╔══╝                                  ║
    ║   ███████║██║  ██╗   ██║   ███████╗                                ║
    ║   ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝                                ║
    ║                                                                    ║
    ║                    Dotfiles Installer                              ║
    ║                                                                    ║
    ╚════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${C_RESET}"
    echo ""
}

backup() {
    if [ -e "$1" ]; then
        local backup_path="$1.backup.$(date +%Y%m%d%H%M%S)"
        echo -e "  ${C_DIM}Backing up${C_RESET} $(basename "$1")"
        mv "$1" "$backup_path"
    fi
}

install_component() {
    local name="$1"
    local source="$2"
    local dest="$3"
    local is_file="${4:-false}"
    
    echo -ne "  ${C_DIM}$name${C_RESET}"
    printf '%*s' $((20 - ${#name})) ''
    
    if [ "$is_file" = "true" ]; then
        if [ -f "$source" ]; then
            backup "$dest"
            cp "$source" "$dest"
            chmod +x "$dest" 2>/dev/null || true
            echo -e "${C_GREEN}done${C_RESET}"
        else
            echo -e "${C_YELLOW}skipped${C_RESET} ${C_DIM}(not found)${C_RESET}"
        fi
    else
        if [ -d "$source" ]; then
            backup "$dest"
            cp -r "$source" "$dest"
            # Make scripts executable
            find "$dest" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
            find "$dest" -type f -name "*rc" -exec chmod +x {} \; 2>/dev/null || true
            echo -e "${C_GREEN}done${C_RESET}"
        else
            echo -e "${C_YELLOW}skipped${C_RESET} ${C_DIM}(not found)${C_RESET}"
        fi
    fi
}

print_header

echo -e "  ${C_LAVENDER}Installing configurations...${C_RESET}"
echo ""

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/Pictures/Wallpapers"
mkdir -p "$HOME/.cache/luvrksnskye"

# ──────────────────────────────────────────────────────────────────────────────
# Core Components
# ──────────────────────────────────────────────────────────────────────────────

echo -e "  ${C_PINK}Core${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"

# Aerospace
install_component "Aerospace" "$SCRIPT_DIR/aerospace.toml" "$HOME/.aerospace.toml" "true"

# SketchyBar
install_component "SketchyBar" "$SCRIPT_DIR/sketchybar" "$HOME/.config/sketchybar"

# JankyBorders
mkdir -p "$HOME/.config/borders"
install_component "Borders" "$SCRIPT_DIR/borders" "$HOME/.config/borders"

# luvrksnskye scripts
install_component "luvrksnskye" "$SCRIPT_DIR/luvrksnskye" "$HOME/.config/luvrksnskye"
chmod +x "$HOME/.config/luvrksnskye/"* 2>/dev/null || true

echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Shell Configuration
# ──────────────────────────────────────────────────────────────────────────────

echo -e "  ${C_PINK}Shell${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"

# ZSH - Install skye.zsh directly to ~/.config/
if [ -f "$SCRIPT_DIR/skye.zsh" ]; then
    echo -ne "  ${C_DIM}skye.zsh${C_RESET}"
    printf '%*s' 12 ''
    backup "$HOME/.config/skye.zsh"
    cp "$SCRIPT_DIR/skye.zsh" "$HOME/.config/skye.zsh"
    echo -e "${C_GREEN}done${C_RESET}"
else
    echo -e "  ${C_DIM}skye.zsh${C_RESET}            ${C_YELLOW}skipped${C_RESET}"
fi

# Starship
install_component "Starship" "$SCRIPT_DIR/starship" "$HOME/.config/starship"

# Powerlevel10k (just a reference, users have their own)
install_component "Powerlevel10k" "$SCRIPT_DIR/powerlevel10k" "$HOME/.config/powerlevel10k"

# Nushell
install_component "Nushell" "$SCRIPT_DIR/nushell" "$HOME/.config/nushell"

echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Terminal & Apps
# ──────────────────────────────────────────────────────────────────────────────

echo -e "  ${C_PINK}Terminal${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"

# Ghostty
install_component "Ghostty" "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty"

# Neofetch
install_component "Neofetch" "$SCRIPT_DIR/neofetch" "$HOME/.config/neofetch"

# Cava
install_component "Cava" "$SCRIPT_DIR/cava" "$HOME/.config/cava"

echo ""

# ──────────────────────────────────────────────────────────────────────────────
# Complete
# ──────────────────────────────────────────────────────────────────────────────

echo -e "${C_LAVENDER}"
cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════════╗
    ║                                                                    ║
    ║                    Installation Complete                           ║
    ║                                                                    ║
    ╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${C_RESET}"

echo ""
echo -e "  ${C_PINK}Dependencies${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
echo ""
echo -e "  ${C_LAVENDER}Required:${C_RESET}"
echo ""
echo "    brew install --cask nikitabobko/tap/aerospace"
echo "    brew install sketchybar"
echo "    brew tap FelixKratz/formulae && brew install borders"
echo "    brew install --cask font-jetbrains-mono-nerd-font"
echo ""
echo -e "  ${C_LAVENDER}Recommended:${C_RESET}"
echo ""
echo "    brew install fzf neofetch cava chafa nowplaying-cli"
echo ""
echo -e "  ${C_PINK}Setup${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
echo ""
echo -e "  1. Add to ${C_LAVENDER}~/.zshrc${C_RESET} (if not already there):"
echo ""
echo "     source ~/.config/skye.zsh"
echo ""
echo -e "  2. Reload shell:"
echo ""
echo "     source ~/.zshrc"
echo ""
echo -e "  3. Start services:"
echo ""
echo "     aerospace reload-config"
echo "     brew services restart sketchybar"
echo "     brew services restart borders"
echo ""
echo -e "  ${C_PINK}Commands${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
echo ""
echo -e "    ${C_LAVENDER}luvr${C_RESET}          Show all commands"
echo -e "    ${C_LAVENDER}keys${C_RESET}          Show keybindings"
echo -e "    ${C_LAVENDER}wall${C_RESET}          Select wallpaper"
echo -e "    ${C_LAVENDER}wallr${C_RESET}         Random wallpaper"
echo ""
