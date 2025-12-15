#!/bin/bash

# 🔵 Bluetooth Plugin

source "$CONFIG_DIR/colors.sh"

# Check if blueutil is installed
if command -v blueutil &> /dev/null; then
    BT_STATUS=$(blueutil --power 2>/dev/null)
    if [ "$BT_STATUS" = "1" ]; then
        sketchybar --set "$NAME" \
            icon="󰂯" \
            icon.color="$BLUE"
    else
        sketchybar --set "$NAME" \
            icon="󰂲" \
            icon.color="$OVERLAY1"
    fi
else
    # Fallback - assume on
    sketchybar --set "$NAME" \
        icon="󰂯" \
        icon.color="$BLUE"
fi
