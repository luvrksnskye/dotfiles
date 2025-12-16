#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         MUSIC PLUGIN                                       ║
# ║                   Supports Spotify + Apple Music                           ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

# Get media info - try multiple sources
get_media_info() {
    local title=""
    local artist=""
    local state="stopped"
    local source=""

    # Try nowplaying-cli first (universal - works with all media apps)
    if command -v nowplaying-cli &> /dev/null; then
        title=$(nowplaying-cli get title 2>/dev/null)
        artist=$(nowplaying-cli get artist 2>/dev/null)
        local rate=$(nowplaying-cli get playbackRate 2>/dev/null)
        
        if [ -n "$title" ] && [ "$title" != "null" ] && [ "$title" != "" ]; then
            [ "$rate" = "1" ] && state="playing" || state="paused"
            source="media"
        fi
    fi

    # If no media from nowplaying-cli, try Spotify directly
    if [ -z "$title" ] || [ "$title" = "null" ]; then
        if pgrep -x "Spotify" &> /dev/null; then
            local spotify_info=$(osascript -e '
                if application "Spotify" is running then
                    tell application "Spotify"
                        if player state is playing then
                            return (artist of current track) & "|||" & (name of current track) & "|||playing"
                        else if player state is paused then
                            return (artist of current track) & "|||" & (name of current track) & "|||paused"
                        end if
                    end tell
                end if
                return ""
            ' 2>/dev/null)
            
            if [ -n "$spotify_info" ]; then
                artist=$(echo "$spotify_info" | cut -d'|' -f1)
                title=$(echo "$spotify_info" | cut -d'|' -f4)
                state=$(echo "$spotify_info" | cut -d'|' -f7)
                source="spotify"
            fi
        fi
    fi

    # If still no media, try Apple Music
    if [ -z "$title" ] || [ "$title" = "null" ]; then
        if pgrep -x "Music" &> /dev/null; then
            local music_info=$(osascript -e '
                if application "Music" is running then
                    tell application "Music"
                        if player state is playing then
                            return (artist of current track) & "|||" & (name of current track) & "|||playing"
                        else if player state is paused then
                            return (artist of current track) & "|||" & (name of current track) & "|||paused"
                        end if
                    end tell
                end if
                return ""
            ' 2>/dev/null)
            
            if [ -n "$music_info" ]; then
                artist=$(echo "$music_info" | cut -d'|' -f1)
                title=$(echo "$music_info" | cut -d'|' -f4)
                state=$(echo "$music_info" | cut -d'|' -f7)
                source="apple"
            fi
        fi
    fi

    echo "$title|||$artist|||$state|||$source"
}

# Get info
INFO=$(get_media_info)
TITLE=$(echo "$INFO" | cut -d'|' -f1)
ARTIST=$(echo "$INFO" | cut -d'|' -f4)
STATE=$(echo "$INFO" | cut -d'|' -f7)
SOURCE=$(echo "$INFO" | cut -d'|' -f10)

# Set icon and color based on state and source
if [ -n "$TITLE" ] && [ "$TITLE" != "null" ] && [ "$TITLE" != "" ]; then
    # Build display string
    if [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ]; then
        DISPLAY="$ARTIST - $TITLE"
    else
        DISPLAY="$TITLE"
    fi
    
    # Truncate if too long
    if [ ${#DISPLAY} -gt 50 ]; then
        DISPLAY="${DISPLAY:0:47}..."
    fi
    
    # Set icon based on source and state
    case "$SOURCE" in
        spotify)
            ICON="󰓇"
            if [ "$STATE" = "playing" ]; then
                COLOR="$GREEN"
            else
                COLOR="$OVERLAY1"
            fi
            ;;
        apple)
            ICON="󰎆"
            if [ "$STATE" = "playing" ]; then
                COLOR="$PINK"
            else
                COLOR="$OVERLAY1"
            fi
            ;;
        *)
            if [ "$STATE" = "playing" ]; then
                ICON="󰐊"
                COLOR="$GREEN"
            else
                ICON="󰏤"
                COLOR="$OVERLAY1"
            fi
            ;;
    esac
    
    sketchybar --animate tanh 15 --set "$NAME" \
        icon="$ICON" \
        icon.color="$COLOR" \
        label="$DISPLAY" \
        label.color="$TEXT" \
        drawing=on
else
    # Nothing playing
    sketchybar --set "$NAME" \
        icon="󰎆" \
        icon.color="$OVERLAY1" \
        label="Not Playing" \
        label.color="$SUBTEXT0" \
        drawing=on
fi
