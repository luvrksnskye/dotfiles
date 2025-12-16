#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                      MUSIC CLICK HANDLER                                   ║
# ║                   Supports Spotify + Apple Music                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝

toggle_play_pause() {
    # Try nowplaying-cli first
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli togglePlayPause 2>/dev/null && return
    fi
    
    # Try Spotify
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to playpause' 2>/dev/null && return
    fi
    
    # Try Apple Music
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to playpause' 2>/dev/null && return
    fi
}

next_track() {
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli next 2>/dev/null && return
    fi
    
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to next track' 2>/dev/null && return
    fi
    
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to next track' 2>/dev/null && return
    fi
}

prev_track() {
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli previous 2>/dev/null && return
    fi
    
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to previous track' 2>/dev/null && return
    fi
    
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to previous track' 2>/dev/null && return
    fi
}

case "$BUTTON" in
    left)
        toggle_play_pause
        ;;
    right)
        next_track
        ;;
    other)
        prev_track
        ;;
esac

# Update display after action
sleep 0.3
sketchybar --trigger media_change
