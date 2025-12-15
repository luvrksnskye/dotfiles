#!/bin/bash

# Clock Plugin - Caracas Time (12h format)

TIME=$(TZ='America/Caracas' date '+%a %d %b  %I:%M %p')

sketchybar --set "$NAME" label="$TIME"
