#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                    🎵 SKYE'S DREAMY MUSIC PLUGIN 🎵                         ║
# ║                                                                             ║
# ║  Supports: Spotify • Apple Music • YouTube • Browser Media                  ║
# ║                                                                             ║
# ║  Features:                                                                  ║
# ║  • Universal media detection via nowplaying-cli                             ║
# ║  • YouTube detection from any browser                                       ║
# ║  • Animated transitions between tracks                                      ║
# ║  • Source-specific icons (Spotify green, YouTube red, etc.)                 ║
# ║                                                                             ║
# ║              ✨ Made with love for Skye ✨                                   ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

# ═══════════════════════════════════════════════════════════════════════
#                         ICONS & COLORS
# ═══════════════════════════════════════════════════════════════════════

ICON_SPOTIFY="󰓇"
ICON_APPLE="󰎆"
ICON_YOUTUBE=""
ICON_BROWSER="󰖟"
ICON_PLAY="󰐊"
ICON_PAUSE="󰏤"
ICON_MUSIC="󰎆"
ICON_VINYL="󰴸"

COLOR_SPOTIFY="$GREEN"
COLOR_APPLE="$PINK"
COLOR_YOUTUBE="$RED"
COLOR_BROWSER="$SKY"
COLOR_PAUSED="$OVERLAY1"
COLOR_NONE="$OVERLAY1"

# ═══════════════════════════════════════════════════════════════════════
#                       MEDIA DETECTION
# ═══════════════════════════════════════════════════════════════════════

get_media_info() {
    local title=""
    local artist=""
    local album=""
    local state="stopped"
    local source="unknown"
    local bundle_id=""

    # Primary method: nowplaying-cli (catches ALL media including browser)
    if command -v nowplaying-cli &> /dev/null; then
        title=$(nowplaying-cli get title 2>/dev/null)
        artist=$(nowplaying-cli get artist 2>/dev/null)
        album=$(nowplaying-cli get album 2>/dev/null)
        local rate=$(nowplaying-cli get playbackRate 2>/dev/null)
        bundle_id=$(nowplaying-cli get clientBundleIdentifier 2>/dev/null | tr '[:upper:]' '[:lower:]')
        
        if [ -n "$title" ] && [ "$title" != "null" ] && [ "$title" != "" ]; then
            [ "$rate" = "1" ] && state="playing" || state="paused"
            
            # Detect source from bundle identifier
            case "$bundle_id" in
                *spotify*)
                    source="spotify"
                    ;;
                *music*|*itunes*)
                    source="apple"
                    ;;
                *chrome*|*safari*|*firefox*|*arc*|*brave*|*edge*|*opera*|*vivaldi*)
                    # Check if likely YouTube
                    # YouTube videos often have no artist, or artist is channel name
                    if [ -z "$artist" ] || [ "$artist" = "null" ] || \
                       echo "$album" | grep -qi "youtube" || \
                       echo "$bundle_id" | grep -qi "youtube"; then
                        source="youtube"
                    else
                        source="browser"
                    fi
                    ;;
                *)
                    source="media"
                    ;;
            esac
        fi
    fi

    # Fallback: Direct Spotify query
    if [ -z "$title" ] || [ "$title" = "null" ]; then
        if pgrep -x "Spotify" &> /dev/null; then
            local spotify_info=$(osascript -e '
                try
                    if application "Spotify" is running then
                        tell application "Spotify"
                            if player state is playing then
                                return (name of current track) & "|||" & (artist of current track) & "|||" & (album of current track) & "|||playing"
                            else if player state is paused then
                                return (name of current track) & "|||" & (artist of current track) & "|||" & (album of current track) & "|||paused"
                            end if
                        end tell
                    end if
                end try
                return ""
            ' 2>/dev/null)
            
            if [ -n "$spotify_info" ]; then
                title=$(echo "$spotify_info" | cut -d'|' -f1)
                artist=$(echo "$spotify_info" | cut -d'|' -f4)
                album=$(echo "$spotify_info" | cut -d'|' -f7)
                state=$(echo "$spotify_info" | cut -d'|' -f10)
                source="spotify"
            fi
        fi
    fi

    # Fallback: Direct Apple Music query
    if [ -z "$title" ] || [ "$title" = "null" ]; then
        if pgrep -x "Music" &> /dev/null; then
            local music_info=$(osascript -e '
                try
                    if application "Music" is running then
                        tell application "Music"
                            if player state is playing then
                                return (name of current track) & "|||" & (artist of current track) & "|||" & (album of current track) & "|||playing"
                            else if player state is paused then
                                return (name of current track) & "|||" & (artist of current track) & "|||" & (album of current track) & "|||paused"
                            end if
                        end tell
                    end if
                end try
                return ""
            ' 2>/dev/null)
            
            if [ -n "$music_info" ]; then
                title=$(echo "$music_info" | cut -d'|' -f1)
                artist=$(echo "$music_info" | cut -d'|' -f4)
                album=$(echo "$music_info" | cut -d'|' -f7)
                state=$(echo "$music_info" | cut -d'|' -f10)
                source="apple"
            fi
        fi
    fi

    # Clean up null values
    [ "$artist" = "null" ] && artist=""
    [ "$album" = "null" ] && album=""

    echo "$title|||$artist|||$album|||$state|||$source"
}

# ═══════════════════════════════════════════════════════════════════════
#                         MAIN UPDATE
# ═══════════════════════════════════════════════════════════════════════

INFO=$(get_media_info)
TITLE=$(echo "$INFO" | cut -d'|' -f1)
ARTIST=$(echo "$INFO" | cut -d'|' -f4)
ALBUM=$(echo "$INFO" | cut -d'|' -f7)
STATE=$(echo "$INFO" | cut -d'|' -f10)
SOURCE=$(echo "$INFO" | cut -d'|' -f13)

# Determine icon and color based on source and state
get_icon_and_color() {
    local src="$1"
    local playing="$2"
    
    if [ "$playing" = "playing" ]; then
        case "$src" in
            spotify)
                echo "$ICON_SPOTIFY|$COLOR_SPOTIFY"
                ;;
            apple)
                echo "$ICON_APPLE|$COLOR_APPLE"
                ;;
            youtube)
                echo "$ICON_YOUTUBE|$COLOR_YOUTUBE"
                ;;
            browser)
                echo "$ICON_BROWSER|$COLOR_BROWSER"
                ;;
            *)
                echo "$ICON_PLAY|$GREEN"
                ;;
        esac
    else
        case "$src" in
            spotify)
                echo "$ICON_SPOTIFY|$COLOR_PAUSED"
                ;;
            apple)
                echo "$ICON_APPLE|$COLOR_PAUSED"
                ;;
            youtube)
                echo "$ICON_YOUTUBE|$COLOR_PAUSED"
                ;;
            browser)
                echo "$ICON_BROWSER|$COLOR_PAUSED"
                ;;
            *)
                echo "$ICON_PAUSE|$COLOR_PAUSED"
                ;;
        esac
    fi
}

# ═══════════════════════════════════════════════════════════════════════
#                         UPDATE DISPLAY
# ═══════════════════════════════════════════════════════════════════════

if [ -n "$TITLE" ] && [ "$TITLE" != "null" ] && [ "$TITLE" != "" ]; then
    # Build display string
    if [ -n "$ARTIST" ]; then
        DISPLAY="$ARTIST • $TITLE"
    else
        DISPLAY="$TITLE"
    fi
    
    # Truncate if too long (max 45 chars)
    if [ ${#DISPLAY} -gt 45 ]; then
        DISPLAY="${DISPLAY:0:42}..."
    fi
    
    # Get icon and color
    ICON_COLOR=$(get_icon_and_color "$SOURCE" "$STATE")
    ICON=$(echo "$ICON_COLOR" | cut -d'|' -f1)
    COLOR=$(echo "$ICON_COLOR" | cut -d'|' -f2)
    
    # Update play button in popup
    if [ "$STATE" = "playing" ]; then
        PLAY_ICON="$ICON_PAUSE"
    else
        PLAY_ICON="$ICON_PLAY"
    fi
    
    # Apply update with smooth animation
    sketchybar --animate tanh 15 --set "$NAME" \
        icon="$ICON" \
        icon.color="$COLOR" \
        label="$DISPLAY" \
        label.color="$TEXT" \
        drawing=on
    
    # Update popup controls
    sketchybar --set music.play icon="$PLAY_ICON"
    
    # Add subtle glow effect when playing
    if [ "$STATE" = "playing" ]; then
        # Pulse effect on new track (check if title changed)
        LAST_TITLE=$(cat /tmp/skye_last_track 2>/dev/null)
        if [ "$TITLE" != "$LAST_TITLE" ]; then
            echo "$TITLE" > /tmp/skye_last_track
            # Trigger bounce animation via helper if available
            if [ -e /tmp/skye_animator.pipe ]; then
                echo "bounce music" > /tmp/skye_animator.pipe
            fi
        fi
    fi
else
    # Nothing playing - show idle state
    sketchybar --set "$NAME" \
        icon="$ICON_VINYL" \
        icon.color="$OVERLAY1" \
        label="Not Playing" \
        label.color="$SUBTEXT0" \
        drawing=on
    
    # Clear last track
    rm -f /tmp/skye_last_track 2>/dev/null
fi

# ═══════════════════════════════════════════════════════════════════════
#                    SOURCE INDICATOR (Optional)
# ═══════════════════════════════════════════════════════════════════════

# You can enable this to show a small source indicator
# sketchybar --set music.source label="$SOURCE"
