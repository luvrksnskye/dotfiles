#!/bin/bash

# 🌤 Weather Plugin - Caracas, Venezuela

source "$CONFIG_DIR/colors.sh"

LOCATION="Caracas"

# Weather icons mapping
get_icon_and_color() {
    local condition="$1"
    condition=$(echo "$condition" | tr '[:upper:]' '[:lower:]')
    
    case "$condition" in
        *clear*|*sunny*)
            echo "󰖙|$YELLOW"
            ;;
        *partly*|*parcialmente*)
            echo "󰖕|$SKY"
            ;;
        *cloud*|*overcast*|*nublado*)
            echo "󰖐|$OVERLAY2"
            ;;
        *rain*|*lluvia*|*drizzle*)
            echo "󰖗|$BLUE"
            ;;
        *thunder*|*storm*|*tormenta*)
            echo "󰖓|$MAUVE"
            ;;
        *snow*|*nieve*)
            echo "󰖘|$TEXT"
            ;;
        *fog*|*mist*|*niebla*)
            echo "󰖑|$OVERLAY1"
            ;;
        *)
            echo "󰖐|$SKY"
            ;;
    esac
}

# Fetch weather
WEATHER=$(/usr/bin/curl -s --max-time 5 "wttr.in/${LOCATION}?format=%C|%t" 2>/dev/null)

if [ -n "$WEATHER" ] && [ "$WEATHER" != "Unknown location" ]; then
    CONDITION=$(echo "$WEATHER" | cut -d'|' -f1 | xargs)
    TEMP=$(echo "$WEATHER" | cut -d'|' -f2 | tr -d '+' | xargs)
    
    ICON_COLOR=$(get_icon_and_color "$CONDITION")
    ICON=$(echo "$ICON_COLOR" | cut -d'|' -f1)
    COLOR=$(echo "$ICON_COLOR" | cut -d'|' -f2)
    
    sketchybar --animate tanh 15 --set "$NAME" \
        icon="$ICON" \
        icon.color="$COLOR" \
        label="$TEMP"
else
    sketchybar --set "$NAME" \
        icon="󰖐" \
        icon.color="$OVERLAY1" \
        label="--°"
fi
