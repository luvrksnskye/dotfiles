#!/bin/bash

# 🌙 Aerospace Workspace Plugin

source "$CONFIG_DIR/colors.sh"

# Get the workspace ID from argument
WORKSPACE_ID="$1"

# Get focused workspace from Aerospace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --animate tanh 15 --set "$NAME" \
        icon.highlight=on \
        icon.color="$MAUVE" \
        background.drawing=on \
        background.color="$MAUVE_FADED"
else
    # Check if workspace has windows
    WINDOW_COUNT=$(aerospace list-windows --workspace "$WORKSPACE_ID" 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$WINDOW_COUNT" -gt 0 ]; then
        # Has windows but not focused
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$SUBTEXT0" \
            background.drawing=off
    else
        # Empty workspace
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$OVERLAY0" \
            background.drawing=off
    fi
fi
