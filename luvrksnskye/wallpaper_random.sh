#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                          RANDOM WALLPAPER                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"
HISTORY_FILE="$HOME/.cache/luvrksnskye/wallpaper_history"

mkdir -p "$HOME/.cache/luvrksnskye"

# Colors
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_DIM='\033[2m'

# Find random wallpaper (excluding recently used if possible)
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "  ${C_PINK}No wallpapers found${C_RESET}"
    echo ""
    echo -e "  Add images to: ${C_LAVENDER}$WALLPAPER_DIR${C_RESET}"
    echo ""
    exit 1
fi

# Try to avoid recently used wallpapers
if [ -f "$HISTORY_FILE" ]; then
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
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    
    echo "$WALLPAPER" > "$CACHE_FILE"
    echo "$WALLPAPER" >> "$HISTORY_FILE"
    
    # Keep history to last 20 entries
    if [ -f "$HISTORY_FILE" ]; then
        tail -20 "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi
    
    echo ""
    echo -e "${C_LAVENDER}"
    cat << 'EOF'
    ╭──────────────────────────────────────────────────────────────────╮
    │                     Random Wallpaper                             │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
    echo -e "${C_RESET}"
    echo ""
    echo -e "  ${C_GREEN}Set:${C_RESET} $(basename "$WALLPAPER")"
    echo ""
fi
