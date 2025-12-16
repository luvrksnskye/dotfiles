#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         SKYE'S DOTFILES INSTALLER                          ║
# ║                              Yabai Edition                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_DIM='\033[2m'

clear
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
    ║                      Yabai Edition                                 ║
    ║                                                                    ║
    ╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${C_RESET}"
echo ""

backup() {
    if [ -e "$1" ]; then
        echo -e "  ${C_DIM}Backing up${C_RESET} $(basename "$1")"
        mv "$1" "$1.backup. $(date +%Y%m%d%H%M%S)"
    fi
}

install_item() {
    local name="$1" src="$2" dest="$3"
    echo -ne "  ${C_DIM}$name${C_RESET}"
    printf '%*s' $((18 - ${#name})) ''
    if [ -e "$src" ]; then
        backup "$dest"
        cp -r "$src" "$dest"
        find "$dest" -type f \( -name "*.sh" -o -name "*rc" \) -exec chmod +x {} \; 2>/dev/null
        echo -e "${C_GREEN}done${C_RESET}"
    else
        echo -e "${C_PINK}not found${C_RESET}"
    fi
}

mkdir -p "$HOME/.config" "$HOME/Pictures/Wallpapers" "$HOME/.cache/luvrksnskye"

echo -e "  ${C_PINK}Window Manager${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
install_item "Yabai" "$SCRIPT_DIR/yabai" "$HOME/.config/yabai"
install_item "skhd" "$SCRIPT_DIR/skhd" "$HOME/.config/skhd"
echo ""

echo -e "  ${C_PINK}Bar & Borders${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
install_item "SketchyBar" "$SCRIPT_DIR/sketchybar" "$HOME/.config/sketchybar"
install_item "Borders" "$SCRIPT_DIR/borders" "$HOME/.config/borders"
echo ""

echo -e "  ${C_PINK}Utilities${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
install_item "luvrksnskye" "$SCRIPT_DIR/luvrksnskye" "$HOME/.config/luvrksnskye"
chmod +x "$HOME/.config/luvrksnskye/"* 2>/dev/null
echo ""

echo -e "  ${C_PINK}Wallpaper${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
if [ -d "$SCRIPT_DIR/wallpaper" ]; then
    install_item "wallpaper_animate" "$SCRIPT_DIR/wallpaper/wallpaper_animate" "$HOME/.config/luvrksnskye/wallpaper_animate"
    cp "$SCRIPT_DIR/wallpaper/wallpaper_"*. sh "$HOME/.config/luvrksnskye/" 2>/dev/null
    chmod +x "$HOME/.config/luvrksnskye/wallpaper_"* 2>/dev/null
    echo -e "  ${C_DIM}wallpaper scripts${C_RESET}${C_GREEN}done${C_RESET}"
fi
echo ""

echo -e "  ${C_PINK}Shell${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
if [ -f "$SCRIPT_DIR/skye.zsh" ]; then
    backup "$HOME/.config/skye.zsh"
    cp "$SCRIPT_DIR/skye.zsh" "$HOME/.config/skye.zsh"
    echo -e "  ${C_DIM}skye.zsh${C_RESET}          ${C_GREEN}done${C_RESET}"
fi
install_item "Starship" "$SCRIPT_DIR/starship" "$HOME/.config/starship"
install_item "Nushell" "$SCRIPT_DIR/nushell" "$HOME/.config/nushell"
echo ""

echo -e "  ${C_PINK}Terminal${C_RESET}"
echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
install_item "Ghostty" "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty"
install_item "Neofetch" "$SCRIPT_DIR/neofetch" "$HOME/.config/neofetch"
install_item "Cava" "$SCRIPT_DIR/cava" "$HOME/.config/cava"
echo ""

echo -e "${C_LAVENDER}"
cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════════╗
    ║                    Installation Complete                           ║
    ╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${C_RESET}"

echo ""
echo -e "  ${C_PINK}Dependencies${C_RESET}"
echo ""
echo "    # Required (SIP must be partially disabled for animations)"
echo "    brew install koekeishiya/formulae/yabai"
echo "    brew install koekeishiya/formulae/skhd"
echo "    brew install sketchybar"
echo "    brew tap FelixKratz/formulae && brew install borders"
echo "    brew install --cask font-jetbrains-mono-nerd-font"
echo ""
echo "    # Recommended"
echo "    brew install fzf jq nowplaying-cli chafa neofetch cava"
echo ""
echo -e "  ${C_PINK}Setup${C_RESET}"
echo ""
echo "    1. Add to ~/.zshrc:"
echo "       source ~/.config/skye.zsh"
echo ""
echo "    2. Configure sudoers for yabai (see yabai wiki)"
echo ""
echo "    3. Start services:"
echo "       yabai --start-service"
echo "       skhd --start-service"
echo "       brew services start sketchybar"
echo "       brew services start borders"
echo ""
echo -e "  ${C_PINK}Commands${C_RESET}"
echo ""
echo "    luvr / whoiam / wall / wallr / wallls / keys"
echo ""