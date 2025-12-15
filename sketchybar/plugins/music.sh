#!/bin/bash

# 🎵 Music Plugin

source "$CONFIG_DIR/colors.sh"

# Try nowplaying-cli first (universal)
if command -v nowplaying-cli &> /dev/null; then
    TITLE=$(nowplaying-cli get title 2>/dev/null)
    ARTIST=$(nowplaying-cli get artist 2>/dev/null)
    STATE=$(nowplaying-cli get playbackRate 2>/dev/null)
    
    if [ -n "$TITLE" ] && [ "$TITLE" != "null" ] && [ "$TITLE" != "" ]; then
        if [ "$STATE" = "1" ]; then
            ICON="󰓇"
            COLOR="$GREEN"
        else
            ICON="󰏤"
            COLOR="$OVERLAY1"
        fi
        
        if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
            DISPLAY="$ARTIST - $TITLE"
        else
            DISPLAY="$TITLE"
        fi
        
        sketchybar --animate tanh 15 --set "$NAME" \
            icon="$ICON" \
            icon.color="$COLOR" \
            label="$DISPLAY" \
            label.color="$TEXT"
        exit 0
    fi
fi

# Fallback: Try Spotify
SPOTIFY_RUNNING=$(pgrep -x "Spotify" 2>/dev/null)
if [ -n "$SPOTIFY_RUNNING" ]; then
    SPOTIFY_INFO=$(osascript -e '
        if application "Spotify" is running then
            tell application "Spotify"
                if player state is playing then
                    return (artist of current track) & " - " & (name of current track) & "|playing"
                else if player state is paused then
                    return (artist of current track) & " - " & (name of current track) & "|paused"
                end if
            end tell
        end if
        return ""
    ' 2>/dev/null)
    
    if [ -n "$SPOTIFY_INFO" ]; then
        DISPLAY=$(echo "$SPOTIFY_INFO" | cut -d'|' -f1)
        STATE=$(echo "$SPOTIFY_INFO" | cut -d'|' -f2)
        
        if [ "$STATE" = "playing" ]; then
            ICON="󰓇"
            COLOR="$GREEN"
        else
            ICON="󰏤"
            COLOR="$OVERLAY1"
        fi
        
        sketchybar --animate tanh 15 --set "$NAME" \
            icon="$ICON" \
            icon.color="$COLOR" \
            label="$DISPLAY" \
            label.color="$TEXT"
        exit 0
    fi
fi

# Fallback: Try Apple Music
MUSIC_RUNNING=$(pgrep -x "Music" 2>/dev/null)
if [ -n "$MUSIC_RUNNING" ]; then
    MUSIC_INFO=$(osascript -e '
        if application "Music" is running then
            tell application "Music"
                if player state is playing then
                    return (artist of current track) & " - " & (name of current track) & "|playing"
                else if player state is paused then
                    return (artist of current track) & " - " & (name of current track) & "|paused"
                end if
            end tell
        end if
        return ""
    ' 2>/dev/null)
    
    if [ -n "$MUSIC_INFO" ]; then
        DISPLAY=$(echo "$MUSIC_INFO" | cut -d'|' -f1)
        STATE=$(echo "$MUSIC_INFO" | cut -d'|' -f2)
        
        if [ "$STATE" = "playing" ]; then
            ICON="󰎆"
            COLOR="$PINK"
        else
            ICON="󰏤"
            COLOR="$OVERLAY1"
        fi
        
        sketchybar --animate tanh 15 --set "$NAME" \
            icon="$ICON" \
            icon.color="$COLOR" \
            label="$DISPLAY" \
            label.color="$TEXT"
        exit 0
    fi
fi

# Nothing playing
sketchybar --set "$NAME" \
    icon="󰎆" \
    icon.color="$OVERLAY1" \
    label="Not Playing" \
    label.color="$SUBTEXT0"
