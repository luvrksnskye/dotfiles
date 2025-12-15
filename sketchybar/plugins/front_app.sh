#!/bin/bash

# 📱 Front App Plugin

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    sketchybar --animate tanh 15 --set "$NAME" label="$INFO"
fi
