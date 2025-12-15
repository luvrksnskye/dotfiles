#!/bin/bash

# 🔊 Volume Plugin

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
    VOLUME="$INFO"

    case "$VOLUME" in
        [7-9][0-9]|100)
            ICON="󰕾"
            COLOR="$PEACH"
            ;;
        [4-6][0-9])
            ICON="󰖀"
            COLOR="$PEACH"
            ;;
        [1-3][0-9])
            ICON="󰕿"
            COLOR="$YELLOW"
            ;;
        [1-9])
            ICON="󰕿"
            COLOR="$OVERLAY2"
            ;;
        0)
            ICON="󰖁"
            COLOR="$OVERLAY1"
            ;;
        *)
            ICON="󰖁"
            COLOR="$OVERLAY1"
            ;;
    esac

    sketchybar --animate tanh 10 --set "$NAME" \
        icon="$ICON" \
        icon.color="$COLOR" \
        label="$VOLUME%" \
        label.drawing=on
    
    # Hide label after 2 seconds
    sleep 2 && sketchybar --set "$NAME" label.drawing=off &
fi
