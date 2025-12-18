#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  SET WALLPAPER  *:･ﾟ✧*:･ﾟ✧                                │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER="$1"
DURATION="${2:-1.2}"

CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

# Colors
R='\033[0m'
DIM='\033[2m'
PINK='\033[38;2;245;194;231m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'

if [ -z "$WALLPAPER" ]; then
    echo ""
    echo -e "    ${PINK}${R} ${TEXT}Usage:${R} wallpaper_set <path> [duration]"
    echo ""
    echo -e "    ${DIM}Duration in seconds (default: 1.2)${R}"
    echo ""
    exit 1
fi

# If just filename, search in Wallpapers folder
if [ ! -f "$WALLPAPER" ]; then
    if [ -f "$HOME/Pictures/Wallpapers/$WALLPAPER" ]; then
        WALLPAPER="$HOME/Pictures/Wallpapers/$WALLPAPER"
    else
        echo ""
        echo -e "    ${PINK}${R} ${TEXT}File not found:${R} $WALLPAPER"
        echo ""
        exit 1
    fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"

# Apply wallpaper with animation
if [ -x "$ANIMATOR" ]; then
    "$ANIMATOR" "$WALLPAPER" "$DURATION" 2>/dev/null || \
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
else
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
fi

# Save to cache
echo "$WALLPAPER" > "$CACHE_FILE"

echo ""
echo -e "    ${GREEN}${R} ${TEXT}$(basename "$WALLPAPER")${R}"
echo ""
