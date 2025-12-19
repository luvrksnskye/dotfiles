#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                    🌙 FRONT APP PLUGIN 🌙                                   ║
# ║                                                                             ║
# ║  Shows the current app with smooth animated transitions                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "front_app_switched" ]; then
    # Animate the label change
    sketchybar --animate tanh 15 --set "$NAME" label="$INFO"
fi
