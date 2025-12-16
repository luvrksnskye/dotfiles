#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                   SET WALLPAPER WITH ANIMATION                            ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER="$1"
TRANSITION_TYPE="${2:-wave}"
CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

# Colors — CATPPUCCIN MOCHA
C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'

mkdir -p "$CACHE_DIR"

if [ -z "$WALLPAPER" ]; then
  echo ""
  echo -e "  ${C_PINK}Usage: ${C_RESET} wallpaper_set /path/to/image [wave|fade|grow]"
  echo ""
  exit 1
fi

# Si es solo nombre, busca en Pictures/Wallpapers
if [ !  -f "$WALLPAPER" ]; then
  if [ -f "$HOME/Pictures/Wallpapers/$WALLPAPER" ]; then
    WALLPAPER="$HOME/Pictures/Wallpapers/$WALLPAPER"
  else
    echo ""
    echo -e "  ${C_PINK}File not found: ${C_RESET} $WALLPAPER"
    echo ""
    exit 1
  fi
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"

if [ -x "$ANIMATOR" ]; then
  "$ANIMATOR" "$WALLPAPER" "$TRANSITION_TYPE" 2>/dev/null || \
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
else
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
fi

echo "$WALLPAPER" > "$CACHE_FILE"

echo ""
echo -e "  ${C_GREEN}✓${C_RESET} $(basename "$WALLPAPER")"
echo ""