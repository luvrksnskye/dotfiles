#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                   🎵 SKYE'S MUSIC CLICK HANDLER 🎵                          ║
# ║                                                                             ║
# ║  Supports: Spotify • Apple Music • YouTube • Any Browser Media              ║
# ║                                                                             ║
# ║  Controls:                                                                  ║
# ║  • Left Click: Toggle popup / Play-Pause                                    ║
# ║  • Right Click: Next track                                                  ║
# ║  • Middle Click / Scroll: Previous track                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

# ═══════════════════════════════════════════════════════════════════════
#                       MEDIA CONTROL FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════

toggle_play_pause() {
    # Try nowplaying-cli first (works with ALL media including YouTube)
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli togglePlayPause 2>/dev/null && return 0
    fi
    
    # Fallback: Try Spotify
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to playpause' 2>/dev/null && return 0
    fi
    
    # Fallback: Try Apple Music
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to playpause' 2>/dev/null && return 0
    fi
    
    # Fallback: Media key simulation (works for most apps)
    osascript -e 'tell application "System Events" to key code 49' 2>/dev/null
}

next_track() {
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli next 2>/dev/null && return 0
    fi
    
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to next track' 2>/dev/null && return 0
    fi
    
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to next track' 2>/dev/null && return 0
    fi
}

prev_track() {
    if command -v nowplaying-cli &> /dev/null; then
        nowplaying-cli previous 2>/dev/null && return 0
    fi
    
    if pgrep -x "Spotify" &> /dev/null; then
        osascript -e 'tell application "Spotify" to previous track' 2>/dev/null && return 0
    fi
    
    if pgrep -x "Music" &> /dev/null; then
        osascript -e 'tell application "Music" to previous track' 2>/dev/null && return 0
    fi
}

# Open the source app
open_source() {
    local bundle_id=""
    
    if command -v nowplaying-cli &> /dev/null; then
        bundle_id=$(nowplaying-cli get clientBundleIdentifier 2>/dev/null | tr '[:upper:]' '[:lower:]')
    fi
    
    case "$bundle_id" in
        *spotify*)
            open -a "Spotify"
            ;;
        *music*|*itunes*)
            open -a "Music"
            ;;
        *chrome*)
            open -a "Google Chrome"
            ;;
        *safari*)
            open -a "Safari"
            ;;
        *firefox*)
            open -a "Firefox"
            ;;
        *arc*)
            open -a "Arc"
            ;;
        *brave*)
            open -a "Brave Browser"
            ;;
        *)
            # Default: try to open the frontmost music-like app
            open -a "Music" 2>/dev/null || open -a "Spotify" 2>/dev/null
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════
#                         HANDLE CLICK
# ═══════════════════════════════════════════════════════════════════════

# Animation feedback
animate_click() {
    # Quick pulse animation
    sketchybar --animate tanh 5 --set "$NAME" \
        background.color="$PINK_FADED"
    sleep 0.1
    sketchybar --animate tanh 10 --set "$NAME" \
        background.color="$MEDIA_BG"
}

case "$BUTTON" in
    left)
        if [ "$MODIFIER" = "shift" ]; then
            # Shift+Click: Open source app
            open_source
        else
            # Regular click: Toggle popup or play/pause
            if [ "$CLICK_COUNT" = "2" ]; then
                # Double click: Open source app
                open_source
            else
                # Single click: Toggle popup
                sketchybar --set music popup.drawing=toggle
            fi
        fi
        ;;
    right)
        # Right click: Next track
        animate_click &
        next_track
        ;;
    other|middle)
        # Middle click: Previous track
        animate_click &
        prev_track
        ;;
    scroll_up)
        # Scroll up: Next track
        next_track
        ;;
    scroll_down)
        # Scroll down: Previous track
        prev_track
        ;;
esac

# Update display after action (with slight delay for state to update)
sleep 0.3
sketchybar --trigger media_change 2>/dev/null
