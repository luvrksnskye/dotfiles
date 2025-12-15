#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           SET WALLPAPER                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER="$1"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"

# Colors
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_DIM='\033[2m'

mkdir -p "$HOME/.cache/luvrksnskye"

if [ -z "$WALLPAPER" ]; then
    echo ""
    echo -e "  ${C_PINK}Usage:${C_RESET} luvr wall-set /path/to/wallpaper.jpg"
    echo ""
    exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
    echo ""
    echo -e "  ${C_PINK}File not found:${C_RESET} $WALLPAPER"
    echo ""
    exit 1
fi

# Get absolute path
WALLPAPER=$(realpath "$WALLPAPER")

osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
echo "$WALLPAPER" > "$CACHE_FILE"

echo ""
echo -e "${C_LAVENDER}"
cat << 'EOF'
    ╭──────────────────────────────────────────────────────────────────╮
    │                    Wallpaper Applied                             │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
echo -e "${C_RESET}"
echo ""
echo -e "  ${C_GREEN}Set:${C_RESET} $(basename "$WALLPAPER")"
echo ""
