#!/bin/bash

# 🎵 Music Click Handler

if [ "$BUTTON" = "left" ]; then
    # Toggle popup
    sketchybar --set music popup.drawing=toggle
elif [ "$BUTTON" = "right" ]; then
    # Play/Pause
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli togglePlayPause 2>/dev/null
    else
        osascript -e 'tell application "Spotify" to playpause' 2>/dev/null || \
        osascript -e 'tell application "Music" to playpause' 2>/dev/null
    fi
    # Update display
    sleep 0.3
    sketchybar --trigger routine
fi
