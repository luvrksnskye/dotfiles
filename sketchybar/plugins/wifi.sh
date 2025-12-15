#!/bin/bash

# 📶 WiFi Plugin

source "$CONFIG_DIR/colors.sh"

WIFI_SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null | grep -o "SSID: .*" | sed 's/^SSID: //' | head -n 1)

if [ -z "$WIFI_SSID" ] || [ "$WIFI_SSID" = "" ]; then
    sketchybar --set "$NAME" \
        icon="󰖪" \
        icon.color="$OVERLAY1"
else
    sketchybar --set "$NAME" \
        icon="󰖩" \
        icon.color="$TEAL"
fi
