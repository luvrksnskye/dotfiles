#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║         🌙 Skye's Dreamy Catppuccin Mocha Palette 🌙               ║
# ║                                                                    ║
# ║  Enhanced for smooth animations and screen recording               ║
# ║              ✨ Made with love for Skye ✨                          ║
# ╚═══════════════════════════════════════════════════════════════════╝

# ═══════════════════════════════════════════════════════════════════════
#                      BASE COLORS (The cozy dark foundation)
# ═══════════════════════════════════════════════════════════════════════

export CRUST="0xff11111b"
export MANTLE="0xff181825"
export BASE="0xff1e1e2e"

# ═══════════════════════════════════════════════════════════════════════
#                      SURFACE COLORS (Layered elements)
# ═══════════════════════════════════════════════════════════════════════

export SURFACE0="0xff313244"
export SURFACE1="0xff45475a"
export SURFACE2="0xff585b70"

# ═══════════════════════════════════════════════════════════════════════
#                      OVERLAY COLORS (Subtle accents)
# ═══════════════════════════════════════════════════════════════════════

export OVERLAY0="0xff6c7086"
export OVERLAY1="0xff7f849c"
export OVERLAY2="0xff9399b2"

# ═══════════════════════════════════════════════════════════════════════
#                           TEXT COLORS
# ═══════════════════════════════════════════════════════════════════════

export SUBTEXT0="0xffa6adc8"
export SUBTEXT1="0xffbac2de"
export TEXT="0xffcdd6f4"

# ═══════════════════════════════════════════════════════════════════════
#                    ACCENT COLORS (Dreamy pastels ✨)
# ═══════════════════════════════════════════════════════════════════════

export ROSEWATER="0xfff5e0dc"
export FLAMINGO="0xfff2cdcd"
export PINK="0xfff5c2e7"
export MAUVE="0xffcba6f7"
export RED="0xfff38ba8"
export MAROON="0xffeba0ac"
export PEACH="0xfffab387"
export YELLOW="0xfff9e2af"
export GREEN="0xffa6e3a1"
export TEAL="0xff94e2d5"
export SKY="0xff89dceb"
export SAPPHIRE="0xff74c7ec"
export BLUE="0xff89b4fa"
export LAVENDER="0xffb4befe"

# ═══════════════════════════════════════════════════════════════════════
#                         TRANSPARENT
# ═══════════════════════════════════════════════════════════════════════

export TRANSPARENT="0x00000000"

# ═══════════════════════════════════════════════════════════════════════
#                    BAR COLORS (Glass effect)
# ═══════════════════════════════════════════════════════════════════════

# Main bar background (85% opacity for that dreamy glass look)
export BAR_COLOR="0xd91e1e2e"

# Bar border (subtle mauve glow)
export BAR_BORDER="0x4dcba6f7"

# Alternative bar styles (uncomment to use)
# Fully opaque:
# export BAR_COLOR="0xff1e1e2e"
# More transparent:
# export BAR_COLOR="0xb31e1e2e"

# ═══════════════════════════════════════════════════════════════════════
#                    ITEM BACKGROUNDS
# ═══════════════════════════════════════════════════════════════════════

# Default item background (60% opacity)
export ITEM_BG="0x99313244"

# Hover state (80% opacity)
export ITEM_BG_HOVER="0xcc45475a"

# Active/Selected state
export ITEM_BG_ACTIVE="0xcc585b70"

# ═══════════════════════════════════════════════════════════════════════
#                         POPUP COLORS
# ═══════════════════════════════════════════════════════════════════════

# Popup background (95% opacity for readability)
export POPUP_BG="0xf2181825"

# Popup border
export POPUP_BORDER="$MAUVE"

# ═══════════════════════════════════════════════════════════════════════
#                        MEDIA COLORS
# ═══════════════════════════════════════════════════════════════════════

# Media player background (80% opacity)
export MEDIA_BG="0xcc313244"

# Spotify green
export SPOTIFY_GREEN="0xff1db954"

# YouTube red
export YOUTUBE_RED="0xfff38ba8"

# ═══════════════════════════════════════════════════════════════════════
#                    FADED/TRANSPARENT ACCENTS
#                 (For glows, highlights, and animations)
# ═══════════════════════════════════════════════════════════════════════

# 30% opacity versions (for subtle backgrounds)
export MAUVE_FADED="0x4dcba6f7"
export PINK_FADED="0x4df5c2e7"
export LAVENDER_FADED="0x4db4befe"
export SKY_FADED="0x4d89dceb"
export GREEN_FADED="0x4da6e3a1"
export PEACH_FADED="0x4dfab387"
export RED_FADED="0x4df38ba8"
export YELLOW_FADED="0x4df9e2af"
export BLUE_FADED="0x4d89b4fa"
export TEAL_FADED="0x4d94e2d5"

# 50% opacity versions (for more visible effects)
export MAUVE_GLOW="0x80cba6f7"
export PINK_GLOW="0x80f5c2e7"
export LAVENDER_GLOW="0x80b4befe"
export SKY_GLOW="0x8089dceb"
export GREEN_GLOW="0x80a6e3a1"
export PEACH_GLOW="0x80fab387"
export RED_GLOW="0x80f38ba8"

# 15% opacity (very subtle, for hover hints)
export MAUVE_HINT="0x26cba6f7"
export PINK_HINT="0x26f5c2e7"
export GREEN_HINT="0x26a6e3a1"

# ═══════════════════════════════════════════════════════════════════════
#                    ANIMATION HELPER COLORS
#                (Pre-calculated for smooth transitions)
# ═══════════════════════════════════════════════════════════════════════

# Color animation start/end pairs
# Usage: animate from ANIM_START_* to ANIM_END_*
export ANIM_PULSE_START="$ITEM_BG"
export ANIM_PULSE_END="$MAUVE_FADED"

export ANIM_GLOW_START="$TRANSPARENT"
export ANIM_GLOW_END="$MAUVE_GLOW"

export ANIM_HOVER_START="$ITEM_BG"
export ANIM_HOVER_END="$ITEM_BG_HOVER"

# ═══════════════════════════════════════════════════════════════════════
#                      SKYE'S SPECIAL COLORS 💜
# ═══════════════════════════════════════════════════════════════════════

# Personal accent (Skye's favorite!)
export SKYE_ACCENT="$MAUVE"
export SKYE_SECONDARY="$PINK"
export SKYE_GLOW="$MAUVE_GLOW"

# ═══════════════════════════════════════════════════════════════════════
#                    SEMANTIC COLORS
#              (Use these for consistent meaning)
# ═══════════════════════════════════════════════════════════════════════

# Status colors
export COLOR_SUCCESS="$GREEN"
export COLOR_WARNING="$YELLOW"
export COLOR_ERROR="$RED"
export COLOR_INFO="$BLUE"
export COLOR_MUTED="$OVERLAY1"
export COLOR_DISABLED="$OVERLAY0"

# Interactive states
export COLOR_FOCUS="$MAUVE"
export COLOR_HOVER="$PINK"
export COLOR_ACTIVE="$LAVENDER"
export COLOR_SELECTED="$MAUVE"

# Media sources
export COLOR_SPOTIFY="$GREEN"
export COLOR_APPLE="$PINK"
export COLOR_YOUTUBE="$RED"
export COLOR_BROWSER="$SKY"
