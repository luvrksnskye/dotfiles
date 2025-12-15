#!/bin/bash

# 🔋 Battery Plugin

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
    exit 0
fi

# Icon and color based on percentage
if [[ "$CHARGING" != "" ]]; then
    ICON="󰂄"
    COLOR="$LAVENDER"
elif [ "$PERCENTAGE" -gt 80 ]; then
    ICON="󰁹"
    COLOR="$GREEN"
elif [ "$PERCENTAGE" -gt 60 ]; then
    ICON="󰂀"
    COLOR="$GREEN"
elif [ "$PERCENTAGE" -gt 40 ]; then
    ICON="󰁾"
    COLOR="$YELLOW"
elif [ "$PERCENTAGE" -gt 20 ]; then
    ICON="󰁼"
    COLOR="$PEACH"
elif [ "$PERCENTAGE" -gt 10 ]; then
    ICON="󰁻"
    COLOR="$RED"
else
    ICON="󰂎"
    COLOR="$RED"
fi

sketchybar --animate tanh 15 --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="${PERCENTAGE}%"
