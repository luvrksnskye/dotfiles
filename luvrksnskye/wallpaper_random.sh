#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        RANDOM WALLPAPER                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"
HISTORY_FILE="$CACHE_DIR/wallpaper_history"

mkdir -p "$CACHE_DIR"

# Colors — CATPPUCCIN MOCHA
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'

WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*. jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "  ${C_PINK}No wallpapers found${C_RESET}"
    echo -e "  Add images to:   ${C_LAVENDER}$WALLPAPER_DIR${C_RESET}"
    echo ""
    exit 1
fi

# Avoid recent
if [ -f "$HISTORY_FILE" ] && [ -s "$HISTORY_FILE" ]; then
    RECENT=$(tail -5 "$HISTORY_FILE")
    AVAILABLE=$(echo "$WALLPAPERS" | grep -vFf <(echo "$RECENT") 2>/dev/null)
    
    if [ -n "$AVAILABLE" ]; then
        WALLPAPER=$(echo "$AVAILABLE" | shuf -n 1)
    else
        WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
    fi
else
    WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
fi

if [ -n "$WALLPAPER" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Use wallpaper_set.sh
    if [ -x "$SCRIPT_DIR/wallpaper_set.sh" ]; then
        "$SCRIPT_DIR/wallpaper_set.sh" "$WALLPAPER" "wave"
    else
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    fi
    
    echo "$WALLPAPER" >> "$HISTORY_FILE"
    
    # Keep last 20
    if [ -f "$HISTORY_FILE" ]; then
        tail -20 "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi
fi