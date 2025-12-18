#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         SKYE'S DOTFILES INSTALLER                          ║
# ║                              macOS Edition                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors - Catppuccin Mocha (True Color)
C_RESET='\033[0m'
C_PINK='\033[38;2;245;194;231m'
C_MAUVE='\033[38;2;203;166;247m'
C_RED='\033[38;2;243;139;168m'
C_PEACH='\033[38;2;250;179;135m'
C_YELLOW='\033[38;2;249;226;175m'
C_GREEN='\033[38;2;166;227;161m'
C_TEAL='\033[38;2;148;226;213m'
C_BLUE='\033[38;2;137;180;250m'
C_LAVENDER='\033[38;2;180;190;254m'
C_TEXT='\033[38;2;205;214;244m'
C_DIM='\033[38;2;108;112;134m'

print_header() {
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
EOF
    echo -e "    ║              ${C_PINK}Dotfiles Installer${C_LAVENDER}                              ║"
    echo -e "    ║                ${C_TEAL}macOS Edition${C_LAVENDER}                                 ║"
    echo -e "    ╚════════════════════════════════════════════════════════════════════╝"
    echo -e "${C_RESET}"
    echo ""
}

section() {
    echo ""
    echo -e "  ${C_PINK}$1${C_RESET}"
    echo -e "  ${C_DIM}────────────────────────────────────────${C_RESET}"
}

check_item() {
    local name="$1"
    local check_cmd="$2"
    echo -ne "  ${C_DIM}$name${C_RESET}"
    printf '%*s' $((28 - ${#name})) ''
    if eval "$check_cmd" >/dev/null 2>&1; then
        echo -e "${C_GREEN}installed${C_RESET}"
        return 0
    else
        echo -e "${C_YELLOW}not found${C_RESET}"
        return 1
    fi
}

install_brew_pkg() {
    local name="$1"
    local pkg="$2"
    local is_cask="${3:-false}"
    echo -ne "  ${C_DIM}Installing $name...${C_RESET}"
    if [ "$is_cask" = "true" ]; then
        brew install --cask "$pkg" >/dev/null 2>&1
    else
        brew install "$pkg" >/dev/null 2>&1
    fi
    echo -e "\r  ${C_DIM}$name${C_RESET}$(printf '%*s' $((28 - ${#name})) '')${C_GREEN}installed${C_RESET}"
}

backup() {
    if [ -e "$1" ]; then
        local backup_name="$1.backup.$(date +%Y%m%d%H%M%S)"
        mv "$1" "$backup_name"
    fi
}

install_config() {
    local name="$1"
    local src="$2"
    local dest="$3"
    echo -ne "  ${C_DIM}$name${C_RESET}"
    printf '%*s' $((28 - ${#name})) ''
    if [ -e "$src" ]; then
        backup "$dest"
        cp -r "$src" "$dest"
        find "$dest" -type f \( -name "*.sh" -o -name "*rc" \) -exec chmod +x {} \; 2>/dev/null
        echo -e "${C_GREEN}done${C_RESET}"
        return 0
    else
        echo -e "${C_RED}not found${C_RESET}"
        return 1
    fi
}

# ────────────────────────────────────────────────────────────────────────────────
print_header

# Check for Homebrew
section "Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
    echo -e "  ${C_RED}Homebrew not found!${C_RESET}"
    echo -e "  ${C_DIM}Install: https://brew.sh${C_RESET}"
    exit 1
fi
echo -e "  ${C_DIM}Homebrew${C_RESET}                    ${C_GREEN}found${C_RESET}"

# Tap repositories
section "Adding Brew Taps"
for tap in "homebrew/cask-fonts" "koekeishiya/formulae" "FelixKratz/formulae"; do
    echo -ne "  ${C_DIM}$tap${C_RESET}"
    printf '%*s' $((28 - ${#tap})) ''
    brew tap "$tap" >/dev/null 2>&1 || true
    echo -e "${C_GREEN}done${C_RESET}"
done

# Core Dependencies
section "Core Dependencies"
check_item "JetBrains Mono Nerd Font" "brew list --cask font-jetbrains-mono-nerd-font" || \
    install_brew_pkg "JetBrains Mono Nerd Font" "font-jetbrains-mono-nerd-font" true
check_item "Nushell" "command -v nu" || install_brew_pkg "Nushell" "nushell"
check_item "Starship" "command -v starship" || install_brew_pkg "Starship" "starship"

section "Window Manager"
check_item "Yabai" "command -v yabai" || install_brew_pkg "Yabai" "yabai"
check_item "skhd" "command -v skhd" || install_brew_pkg "skhd" "skhd"
check_item "SketchyBar" "command -v sketchybar" || install_brew_pkg "SketchyBar" "sketchybar"
check_item "Borders" "command -v borders" || install_brew_pkg "Borders" "borders"

section "Terminal & Tools"
check_item "fzf" "command -v fzf" || install_brew_pkg "fzf" "fzf"
check_item "jq" "command -v jq" || install_brew_pkg "jq" "jq"
check_item "bat" "command -v bat" || install_brew_pkg "bat" "bat"
check_item "eza" "command -v eza" || install_brew_pkg "eza" "eza"
check_item "ripgrep" "command -v rg" || install_brew_pkg "ripgrep" "ripgrep"
check_item "fd" "command -v fd" || install_brew_pkg "fd" "fd"
check_item "neofetch" "command -v neofetch" || install_brew_pkg "neofetch" "neofetch"
check_item "tmux" "command -v tmux" || install_brew_pkg "tmux" "tmux"
check_item "lazygit" "command -v lazygit" || install_brew_pkg "lazygit" "lazygit"

# Create directories
section "Creating Directories"
mkdir -p "$HOME/.config" "$HOME/.cache/starship" "$HOME/.cache/luvrksnskye" "$HOME/Pictures/Wallpapers"
echo -e "  ${C_DIM}All directories${C_RESET}            ${C_GREEN}ready${C_RESET}"

# Install configurations
section "Window Manager Configs"
install_config "Yabai" "$SCRIPT_DIR/yabai" "$HOME/.config/yabai"
install_config "skhd" "$SCRIPT_DIR/skhd" "$HOME/.config/skhd"

section "Bar & Borders"
install_config "SketchyBar" "$SCRIPT_DIR/sketchybar" "$HOME/.config/sketchybar"
install_config "Borders" "$SCRIPT_DIR/borders" "$HOME/.config/borders"

section "Utilities"
install_config "luvrksnskye" "$SCRIPT_DIR/luvrksnskye" "$HOME/.config/luvrksnskye"
[ -d "$HOME/.config/luvrksnskye" ] && chmod +x "$HOME/.config/luvrksnskye/"* 2>/dev/null || true

# Compile wallpaper animator
if [ -f "$SCRIPT_DIR/luvrksnskye/wallpapers/wallpaper_animate.m" ]; then
    echo -ne "  ${C_DIM}Compiling wallpaper_animate${C_RESET} "
    if (cd "$SCRIPT_DIR/luvrksnskye/wallpapers" && make clean && make) >/dev/null 2>&1; then
        cp "$SCRIPT_DIR/luvrksnskye/wallpapers/wallpaper_animate" "$HOME/.config/luvrksnskye/" 2>/dev/null
        echo -e "${C_GREEN}done${C_RESET}"
    else
        echo -e "${C_YELLOW}skipped${C_RESET}"
    fi
fi

section "Shell Configuration"
[ -f "$SCRIPT_DIR/skye.zsh" ] && { backup "$HOME/.config/skye.zsh"; cp "$SCRIPT_DIR/skye.zsh" "$HOME/.config/skye.zsh"; echo -e "  ${C_DIM}skye.zsh${C_RESET}                    ${C_GREEN}done${C_RESET}"; }
install_config "Powerlevel10k" "$SCRIPT_DIR/powerlevel10k" "$HOME/.config/powerlevel10k"
install_config "Starship" "$SCRIPT_DIR/starship" "$HOME/.config/starship"
install_config "Nushell" "$SCRIPT_DIR/nushell" "$HOME/.config/nushell"
install_config "Tmux" "$SCRIPT_DIR/tmux" "$HOME/.config/tmux"

# Copy to correct locations
[ -f "$SCRIPT_DIR/tmux/tmux.conf" ] && { backup "$HOME/.tmux.conf"; cp "$SCRIPT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"; }
[ -f "$SCRIPT_DIR/starship/starship.toml" ] && { backup "$HOME/.config/starship.toml"; cp "$SCRIPT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"; }

section "Terminal"
install_config "Ghostty" "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty"
install_config "Neofetch" "$SCRIPT_DIR/neofetch" "$HOME/.config/neofetch"
install_config "Cava" "$SCRIPT_DIR/cava" "$HOME/.config/cava"
install_config "Kew" "$SCRIPT_DIR/kew" "$HOME/.config/kew"

# Initialize shell tools
section "Initializing Shell Tools"
if command -v starship >/dev/null 2>&1; then
    starship init nu > "$HOME/.cache/starship/init.nu" 2>/dev/null
    echo -e "  ${C_DIM}Starship for Nushell${C_RESET}        ${C_GREEN}done${C_RESET}"
fi

# TPM
section "Tmux Plugin Manager"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" >/dev/null 2>&1
    echo -e "  ${C_DIM}TPM${C_RESET}                         ${C_GREEN}installed${C_RESET}"
else
    echo -e "  ${C_DIM}TPM${C_RESET}                         ${C_GREEN}exists${C_RESET}"
fi

# Complete
echo ""
echo -e "${C_LAVENDER}"
cat << 'EOF'
    ╔════════════════════════════════════════════════════════════════════╗
    ║                    Installation Complete!                          ║
    ╚════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${C_RESET}"

section "Post-Installation"
echo -e "  ${C_TEAL}1.${C_RESET} Add to ~/.zshrc: ${C_DIM}source ~/.config/skye.zsh${C_RESET}"
echo -e "  ${C_TEAL}2.${C_RESET} Configure sudoers for Yabai"
echo -e "  ${C_TEAL}3.${C_RESET} Start services:"
echo -e "     ${C_DIM}yabai --start-service && skhd --start-service${C_RESET}"
echo -e "     ${C_DIM}brew services start sketchybar && brew services start borders${C_RESET}"
echo -e "  ${C_TEAL}4.${C_RESET} Tmux plugins: ${C_DIM}Ctrl-a + I${C_RESET}"
echo ""

section "Commands"
echo -e "  ${C_MAUVE}luvr${C_RESET}        ${C_DIM}Show help${C_RESET}"
echo -e "  ${C_MAUVE}luvr greet${C_RESET}  ${C_DIM}Animated greeting${C_RESET}"
echo -e "  ${C_MAUVE}luvr keys${C_RESET}   ${C_DIM}Keybinding reference${C_RESET}"
echo -e "  ${C_MAUVE}luvr wall${C_RESET}   ${C_DIM}Wallpaper selector${C_RESET}"
echo -e "  ${C_MAUVE}reload${C_RESET}      ${C_DIM}Reload configs${C_RESET}"
echo ""
