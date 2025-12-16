#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                    LIST AVAILABLE WALLPAPERS                               ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"

# Colors — CATPPUCCIN MOCHA
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_DIM='\033[2m'

mkdir -p "$WALLPAPER_DIR"

WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "  ${C_PINK}No wallpapers found${C_RESET}"
    echo -e "  Add images to: ${C_LAVENDER}$WALLPAPER_DIR${C_RESET}"
    echo ""
    exit 1
fi

CURRENT=""
[ -f "$CACHE_FILE" ] && CURRENT=$(cat "$CACHE_FILE")

echo ""
echo -e "${C_LAVENDER}Available Wallpapers: ${C_RESET}"
echo ""

while IFS= read -r path; do
    name=$(basename "$path")
    if [ "$path" = "$CURRENT" ]; then
        echo -e "  ${C_GREEN}✓${C_RESET} $name"
    else
        echo -e "  ${C_DIM}○${C_RESET} $name"
    fi
done <<< "$WALLPAPERS"

echo ""