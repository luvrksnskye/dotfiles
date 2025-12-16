#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         YABAI SPACE PLUGIN                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

# Get the space ID from argument
SPACE_ID="$1"

# Get focused space from Yabai
FOCUSED_SPACE=$(yabai -m query --spaces --space | jq -r '.index' 2>/dev/null)

if [ "$SPACE_ID" = "$FOCUSED_SPACE" ]; then
    sketchybar --animate tanh 15 --set "$NAME" \
        icon.highlight=on \
        icon.color="$MAUVE" \
        background.drawing=on \
        background.color="$MAUVE_FADED"
else
    # Check if space has windows
    WINDOW_COUNT=$(yabai -m query --windows --space "$SPACE_ID" 2>/dev/null | jq 'length' 2>/dev/null)
    
    if [ -n "$WINDOW_COUNT" ] && [ "$WINDOW_COUNT" -gt 0 ]; then
        # Has windows but not focused
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$SUBTEXT0" \
            background.drawing=off
    else
        # Empty space
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$OVERLAY0" \
            background.drawing=off
    fi
fi
