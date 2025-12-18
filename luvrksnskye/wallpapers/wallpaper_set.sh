#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  SET WALLPAPER  *:･ﾟ✧*:･ﾟ✧                                │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER="$1"
TRANSITION="${2:-wave}"
DIRECTION="${3:-left}"

CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

# Colors
R='\033[0m'
DIM='\033[2m'

PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'

# Icons
ICON_CHECK=""
ICON_IMAGE=""

if [ -z "$WALLPAPER" ]; then
    echo ""
    echo -e "    ${PINK}${ICON_IMAGE}${R} ${TEXT}Usage:${R} wallpaper_set <path> [effect] [direction]"
    echo ""
    echo -e "    ${DIM}Effects: wave, fade, grow, liquid, spiral, fold, slide, bloom, glitch${R}"
    echo ""
    exit 1
fi

# If just filename, search in Wallpapers folder
if [ ! -f "$WALLPAPER" ]; then
    if [ -f "$HOME/Pictures/Wallpapers/$WALLPAPER" ]; then
        WALLPAPER="$HOME/Pictures/Wallpapers/$WALLPAPER"
    else
        echo ""
        echo -e "    ${PINK}${ICON_IMAGE}${R} ${TEXT}File not found:${R} $WALLPAPER"
        echo ""
        exit 1
    fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"

# Apply wallpaper
if [ -x "$ANIMATOR" ]; then
    if [ "$TRANSITION" = "slide" ]; then
        "$ANIMATOR" "$WALLPAPER" "$TRANSITION" "$DIRECTION" 2>/dev/null || \
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    else
        "$ANIMATOR" "$WALLPAPER" "$TRANSITION" 2>/dev/null || \
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
    fi
else
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
fi

# Save to cache
echo "$WALLPAPER" > "$CACHE_FILE"

echo ""
echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}$(basename "$WALLPAPER")${R}"
echo -e "    ${DIM}${SUBTEXT0}Effect: ${LAVENDER}$TRANSITION${R}"
echo ""
