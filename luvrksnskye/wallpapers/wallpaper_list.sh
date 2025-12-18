#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  WALLPAPER LIST  *:･ﾟ✧*:･ﾟ✧                               │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"

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
OVERLAY0='\033[38;2;108;112;134m'

# Icons
ICON_IMAGE=""       # nf-fa-image
ICON_CHECK=""       # nf-fa-check
ICON_CIRCLE=""      # nf-fa-circle_o

mkdir -p "$WALLPAPER_DIR"

WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \
\) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "    ${PINK}${ICON_IMAGE}${R} ${TEXT}No wallpapers found${R}"
    echo -e "    ${DIM}Add images to: ${LAVENDER}$WALLPAPER_DIR${R}"
    echo ""
    exit 1
fi

CURRENT=""
[ -f "$CACHE_FILE" ] && CURRENT=$(cat "$CACHE_FILE")

count=$(echo "$WALLPAPERS" | wc -l | tr -d ' ')

echo ""
echo -e "    ${MAUVE}╭───────────────────────────────────────╮${R}"
echo -e "    ${MAUVE}│${R}                                       ${MAUVE}│${R}"
echo -e "    ${MAUVE}│${R}  ${PINK}${ICON_IMAGE}${R} ${B}${TEXT}Available Wallpapers${R}  ${DIM}($count)${R}    ${MAUVE}│${R}"
echo -e "    ${MAUVE}│${R}                                       ${MAUVE}│${R}"
echo -e "    ${MAUVE}╰───────────────────────────────────────╯${R}"
echo ""

while IFS= read -r path; do
    name=$(basename "$path")
    if [ "$path" = "$CURRENT" ]; then
        echo -e "    ${GREEN}${ICON_CHECK}${R} ${TEXT}$name${R}"
    else
        echo -e "    ${DIM}${ICON_CIRCLE}${R} ${SUBTEXT0}$name${R}"
    fi
done <<< "$WALLPAPERS"

echo ""
