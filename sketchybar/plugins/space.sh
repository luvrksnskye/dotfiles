#!/bin/bash

# 🌙 Space Plugin

source "$CONFIG_DIR/colors.sh"

if [ "$SELECTED" = "true" ]; then
    sketchybar --animate tanh 15 --set "$NAME" \
        icon.highlight=on \
        icon.color="$MAUVE" \
        background.drawing=on \
        background.color="$MAUVE_FADED"
else
    sketchybar --animate tanh 15 --set "$NAME" \
        icon.highlight=off \
        icon.color="$OVERLAY1" \
        background.drawing=off
fi
