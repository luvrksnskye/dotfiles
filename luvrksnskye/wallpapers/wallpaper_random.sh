#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  RANDOM WALLPAPER  *:･ﾟ✧*:･ﾟ✧                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"
HISTORY_FILE="$CACHE_DIR/wallpaper_history"

mkdir -p "$CACHE_DIR"

# Colors
R='\033[0m'
B='\033[1m'
DIM='\033[2m'

PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'

# Icons
ICON_RANDOM=""      # nf-fa-random
ICON_CHECK=""       # nf-fa-check
ICON_IMAGE=""       # nf-fa-image

# Notification
notify() {
    osascript -e "display notification \"$1\" with title \"${2:-Wallpaper}\"" 2>/dev/null
}

WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \
\) 2>/dev/null)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "    ${PINK}${ICON_IMAGE}${R} ${TEXT}No wallpapers found${R}"
    echo -e "    ${DIM}Add images to: ${LAVENDER}$WALLPAPER_DIR${R}"
    echo ""
    exit 1
fi

# Avoid recent wallpapers
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
    
    # Random transition
    TRANSITIONS=("wave" "fade" "grow" "liquid" "spiral" "fold")
    RANDOM_TRANS=${TRANSITIONS[$RANDOM % ${#TRANSITIONS[@]}]}
    
    # Use wallpaper_set.sh
    if [ -x "$SCRIPT_DIR/wallpaper_set.sh" ]; then
        "$SCRIPT_DIR/wallpaper_set.sh" "$WALLPAPER" "$RANDOM_TRANS"
    else
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
        
        echo ""
        echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}$(basename "$WALLPAPER")${R}"
        echo ""
    fi
    
    # Save to history
    echo "$WALLPAPER" >> "$HISTORY_FILE"
    
    # Keep last 20
    if [ -f "$HISTORY_FILE" ]; then
        tail -20 "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
        mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi
    
    notify "$(basename "$WALLPAPER")" "Random Wallpaper"
fi
