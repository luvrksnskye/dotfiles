#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                    🌙 WORKSPACE INDICATOR PLUGIN 🌙                         ║
# ║                                                                             ║
# ║  Works with: Aerospace, Yabai, or native macOS spaces                       ║
# ║  Features: Animated transitions, window count indicators                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

source "$CONFIG_DIR/colors.sh"

SPACE_ID="$1"

# ═══════════════════════════════════════════════════════════════════════
#                    GET FOCUSED WORKSPACE
# ═══════════════════════════════════════════════════════════════════════

get_focused_space() {
    # Try Aerospace first
    if command -v aerospace &> /dev/null; then
        aerospace list-workspaces --focused 2>/dev/null
        return
    fi
    
    # Try Yabai
    if command -v yabai &> /dev/null; then
        yabai -m query --spaces --space 2>/dev/null | jq -r '.index' 2>/dev/null
        return
    fi
    
    # Fallback: native macOS (less reliable)
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════
#                    GET WINDOW COUNT FOR SPACE
# ═══════════════════════════════════════════════════════════════════════

get_window_count() {
    local space="$1"
    
    # Try Yabai
    if command -v yabai &> /dev/null; then
        yabai -m query --windows --space "$space" 2>/dev/null | jq 'length' 2>/dev/null
        return
    fi
    
    # Try Aerospace
    if command -v aerospace &> /dev/null; then
        aerospace list-windows --workspace "$space" 2>/dev/null | wc -l | tr -d ' '
        return
    fi
    
    echo "0"
}

# ═══════════════════════════════════════════════════════════════════════
#                         UPDATE DISPLAY
# ═══════════════════════════════════════════════════════════════════════

FOCUSED=$(get_focused_space)
WINDOW_COUNT=$(get_window_count "$SPACE_ID")

if [ "$SPACE_ID" = "$FOCUSED" ]; then
    # This space is focused - highlight with animation
    sketchybar --animate tanh 15 --set "$NAME" \
        icon.highlight=on \
        icon.color="$MAUVE" \
        background.drawing=on \
        background.color="$MAUVE_FADED"
else
    # Not focused - check if has windows
    if [ -n "$WINDOW_COUNT" ] && [ "$WINDOW_COUNT" -gt 0 ] 2>/dev/null; then
        # Has windows but not focused - subtle highlight
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$SUBTEXT0" \
            background.drawing=off
    else
        # Empty space - dim
        sketchybar --animate tanh 15 --set "$NAME" \
            icon.highlight=off \
            icon.color="$OVERLAY0" \
            background.drawing=off
    fi
fi
