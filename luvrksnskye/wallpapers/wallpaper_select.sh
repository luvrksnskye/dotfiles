#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  WALLPAPER SELECTOR  *:･ﾟ✧*:･ﾟ✧                           │
# │                                                                             │
# │              Beautiful & Responsive Preview                                 │
# │              Catppuccin Mocha · Feminine Edition                            │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"
mkdir -p "$WALLPAPER_DIR"

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS — Catppuccin Mocha (Feminine)
# ═══════════════════════════════════════════════════════════════════════════════

R='\033[0m'
B='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'

ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
MAROON='\033[38;2;235;160;172m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
SAPPHIRE='\033[38;2;116;199;236m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT1='\033[38;2;186;194;222m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE1='\033[38;2;69;71;90m'

# ═══════════════════════════════════════════════════════════════════════════════
# NOTIFICATIONS
# ═══════════════════════════════════════════════════════════════════════════════

notify() {
    local message="$1"
    local title="${2:-Wallpaper}"
    osascript -e "display notification \"${message}\" with title \"${title}\"" 2>/dev/null
}

# ═══════════════════════════════════════════════════════════════════════════════
# SETUP
# ═══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"
TRANSITION="${1:-wave}"
DIRECTION="left"

# Export for fzf
export WALLPAPER_DIR CACHE_FILE TRANSITION DIRECTION
export PINK MAUVE LAVENDER GREEN PEACH R DIM SUBTEXT0 TEXT

# ═══════════════════════════════════════════════════════════════════════════════
# CHECK DEPENDENCIES
# ═══════════════════════════════════════════════════════════════════════════════

if ! command -v fzf &>/dev/null; then
    echo ""
    echo -e "  ${PINK}✧ fzf is required${R}"
    echo -e "  ${LAVENDER}brew install fzf${R}"
    echo ""
    exit 1
fi

# ═══════════════════════════════════════════════════════════════════════════════
# FIND WALLPAPERS
# ═══════════════════════════════════════════════════════════════════════════════

WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \
\) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
    echo ""
    echo -e "  ${PINK}✧ No wallpapers found${R}"
    echo -e "  ${LAVENDER}Add images to: $WALLPAPER_DIR${R}"
    echo ""
    notify "No wallpapers found" "Add images to ~/Pictures/Wallpapers"
    exit 1
fi

# Current wallpaper
CURRENT=""
[ -f "$CACHE_FILE" ] && CURRENT=$(cat "$CACHE_FILE")

# ═══════════════════════════════════════════════════════════════════════════════
# BUILD DISPLAY LIST
# ═══════════════════════════════════════════════════════════════════════════════

display_list() {
    while IFS= read -r path; do
        name=$(basename "$path")
        if [ "$path" = "$CURRENT" ]; then
            echo "♡ $name"
        else
            echo "  $name"
        fi
    done <<< "$WALLPAPERS"
}

# ═══════════════════════════════════════════════════════════════════════════════
# BEAUTIFUL PREVIEW COMMAND
# ═══════════════════════════════════════════════════════════════════════════════

# Create preview script
PREVIEW_SCRIPT=$(mktemp)
cat > "$PREVIEW_SCRIPT" << 'PREVIEW_EOF'
#!/bin/bash

# Colors
R='\033[0m'
B='\033[1m'
DIM='\033[2m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'
PEACH='\033[38;2;250;179;135m'
SKY='\033[38;2;137;220;235m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE1='\033[38;2;69;71;90m'

sel="$1"
sel="${sel#♡ }"
sel="${sel#  }"
file="$WALLPAPER_DIR/$sel"

# Get preview dimensions (responsive)
COLS=$(tput cols 2>/dev/null || echo 80)
LINES=$(tput lines 2>/dev/null || echo 24)

# Calculate preview size (50% of terminal, with padding)
PREVIEW_W=$(( (COLS / 2) - 6 ))
PREVIEW_H=$(( LINES - 12 ))

# Minimum sizes
[ $PREVIEW_W -lt 20 ] && PREVIEW_W=20
[ $PREVIEW_H -lt 8 ] && PREVIEW_H=8

# Maximum sizes for clean look
[ $PREVIEW_W -gt 80 ] && PREVIEW_W=80
[ $PREVIEW_H -gt 30 ] && PREVIEW_H=30

# Header
echo ""
echo -e "${MAUVE}  ╭────────────────────────────────────────╮${R}"
echo -e "${MAUVE}  │${R}  ${PINK}✧${R} ${B}${TEXT}Preview${R}                              ${MAUVE}│${R}"
echo -e "${MAUVE}  ╰────────────────────────────────────────╯${R}"
echo ""

# Image preview with container
if command -v chafa &>/dev/null; then
    # Use chafa with symbols that work well
    echo -e "${SURFACE1}  ┌$(printf '─%.0s' $(seq 1 $PREVIEW_W))┐${R}"
    chafa --size="${PREVIEW_W}x${PREVIEW_H}" \
          --format=symbols \
          --symbols=block+border \
          --colors=256 \
          --dither=ordered \
          --work=9 \
          "$file" 2>/dev/null | while IFS= read -r line; do
        echo -e "${SURFACE1}  │${R}${line}${SURFACE1}│${R}"
    done
    echo -e "${SURFACE1}  └$(printf '─%.0s' $(seq 1 $PREVIEW_W))┘${R}"
elif command -v viu &>/dev/null; then
    echo -e "${SURFACE1}  ┌$(printf '─%.0s' $(seq 1 $PREVIEW_W))┐${R}"
    viu -w "$PREVIEW_W" -h "$PREVIEW_H" "$file" 2>/dev/null | while IFS= read -r line; do
        echo -e "${SURFACE1}  │${R}${line}"
    done
    echo -e "${SURFACE1}  └$(printf '─%.0s' $(seq 1 $PREVIEW_W))┘${R}"
elif command -v timg &>/dev/null; then
    timg -g "${PREVIEW_W}x${PREVIEW_H}" "$file" 2>/dev/null
elif command -v imgcat &>/dev/null; then
    imgcat "$file" 2>/dev/null
else
    echo -e "${MAUVE}  ╭────────────────────────────────╮${R}"
    echo -e "${MAUVE}  │${R}                                ${MAUVE}│${R}"
    echo -e "${MAUVE}  │${R}   ${PINK}Preview requires chafa${R}       ${MAUVE}│${R}"
    echo -e "${MAUVE}  │${R}   ${DIM}brew install chafa${R}           ${MAUVE}│${R}"
    echo -e "${MAUVE}  │${R}                                ${MAUVE}│${R}"
    echo -e "${MAUVE}  ╰────────────────────────────────╯${R}"
fi

echo ""

# File info
echo -e "${MAUVE}  ╭────────────────────────────────────────╮${R}"
echo -e "${MAUVE}  │${R}  ${PINK}❀${R} ${B}${TEXT}Info${R}                                  ${MAUVE}│${R}"
echo -e "${MAUVE}  ├────────────────────────────────────────┤${R}"

# Filename (truncated if needed)
fname=$(basename "$file")
if [ ${#fname} -gt 34 ]; then
    fname="${fname:0:31}..."
fi
printf "${MAUVE}  │${R}  ${SUBTEXT0}Name:${R} ${TEXT}%-34s${R}${MAUVE}│${R}\n" "$fname"

# File size
if [ -f "$file" ]; then
    size=$(ls -lh "$file" 2>/dev/null | awk '{print $5}')
    printf "${MAUVE}  │${R}  ${SUBTEXT0}Size:${R} ${TEXT}%-34s${R}${MAUVE}│${R}\n" "$size"
fi

# Dimensions (if identify available)
if command -v identify &>/dev/null; then
    dims=$(identify -format "%wx%h" "$file" 2>/dev/null)
    if [ -n "$dims" ]; then
        printf "${MAUVE}  │${R}  ${SUBTEXT0}Dims:${R} ${TEXT}%-34s${R}${MAUVE}│${R}\n" "$dims"
    fi
fi

# Format
ext="${file##*.}"
ext_upper=$(echo "$ext" | tr '[:lower:]' '[:upper:]')
printf "${MAUVE}  │${R}  ${SUBTEXT0}Type:${R} ${TEXT}%-34s${R}${MAUVE}│${R}\n" "$ext_upper"

echo -e "${MAUVE}  ╰────────────────────────────────────────╯${R}"
echo ""

# Current transition
echo -e "${LAVENDER}  ╭────────────────────────────────────────╮${R}"
echo -e "${LAVENDER}  │${R}  ${SKY}✦${R} ${TEXT}Transition: ${GREEN}${TRANSITION:-wave}${R}                  ${LAVENDER}│${R}"
echo -e "${LAVENDER}  ╰────────────────────────────────────────╯${R}"

PREVIEW_EOF
chmod +x "$PREVIEW_SCRIPT"

# ═══════════════════════════════════════════════════════════════════════════════
# FZF SELECTOR
# ═══════════════════════════════════════════════════════════════════════════════

clear

# Header
echo ""
echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧  ${LAVENDER}✧${PINK}·${MAUVE}˚${LAVENDER}❀${MAUVE}˚${PINK}·${LAVENDER}✧${R}"
echo ""

# Transition state file
TRANS_FILE=$(mktemp)
echo "$TRANSITION" > "$TRANS_FILE"
DIR_FILE=$(mktemp)
echo "$DIRECTION" > "$DIR_FILE"

export TRANS_FILE DIR_FILE

SELECTED=$(display_list | fzf \
    --ansi \
    --no-bold \
    --cycle \
    --reverse \
    --border=rounded \
    --border-label="  ╱|、 ♡ Wallpaper Selector (˚ˎ 。7  " \
    --border-label-pos=3 \
    --margin=1,3 \
    --padding=1 \
    --prompt="  ❀ " \
    --pointer=" ♡" \
    --marker="✧" \
    --color='bg+:#313244,bg:#1e1e2e,spinner:#f5c2e7,hl:#f5c2e7' \
    --color='fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5c2e7' \
    --color='marker:#f5c2e7,fg+:#f5c2e7,prompt:#cba6f7,hl+:#f5c2e7' \
    --color='border:#cba6f7,label:#f5c2e7,query:#f5c2e7' \
    --preview-window='right:50%:wrap:border-rounded' \
    --preview="WALLPAPER_DIR='$WALLPAPER_DIR' TRANSITION=\$(cat '$TRANS_FILE') '$PREVIEW_SCRIPT' {}" \
    --header=$'
  ♡ Current wallpaper marked with ♡
  
  ╭───────────────────────────────────────╮
  │  ✧ Effects                            │
  ├───────────────────────────────────────┤
  │  [1] wave    [2] fade    [3] grow     │
  │  [4] liquid  [5] spiral  [6] fold     │
  │  [7] slide   [8] bloom   [9] glitch   │
  │  [0] direction (slide)                │
  ╰───────────────────────────────────────╯
  
  [tab] toggle preview  [enter] apply
' \
    --bind="1:execute-silent(echo wave > '$TRANS_FILE')+refresh-preview" \
    --bind="2:execute-silent(echo fade > '$TRANS_FILE')+refresh-preview" \
    --bind="3:execute-silent(echo grow > '$TRANS_FILE')+refresh-preview" \
    --bind="4:execute-silent(echo liquid > '$TRANS_FILE')+refresh-preview" \
    --bind="5:execute-silent(echo spiral > '$TRANS_FILE')+refresh-preview" \
    --bind="6:execute-silent(echo fold > '$TRANS_FILE')+refresh-preview" \
    --bind="7:execute-silent(echo slide > '$TRANS_FILE')+refresh-preview" \
    --bind="8:execute-silent(echo bloom > '$TRANS_FILE')+refresh-preview" \
    --bind="9:execute-silent(echo glitch > '$TRANS_FILE')+refresh-preview" \
    --bind="0:execute-silent(
        d=\$(cat '$DIR_FILE')
        case \$d in
            left) echo right > '$DIR_FILE' ;;
            right) echo up > '$DIR_FILE' ;;
            up) echo down > '$DIR_FILE' ;;
            *) echo left > '$DIR_FILE' ;;
        esac
    )+refresh-preview" \
    --bind="tab:toggle-preview"
)

# Read final transition
TRANSITION=$(cat "$TRANS_FILE" 2>/dev/null || echo "wave")
DIRECTION=$(cat "$DIR_FILE" 2>/dev/null || echo "left")

# Cleanup
rm -f "$PREVIEW_SCRIPT" "$TRANS_FILE" "$DIR_FILE"

# ═══════════════════════════════════════════════════════════════════════════════
# APPLY WALLPAPER
# ═══════════════════════════════════════════════════════════════════════════════

if [ -n "$SELECTED" ]; then
    FILE="$SELECTED"
    FILE="${FILE#♡ }"
    FILE="${FILE#  }"
    
    FULL_PATH="$WALLPAPER_DIR/$FILE"
    
    if [ -f "$FULL_PATH" ]; then
        # Apply with animation
        if [ -x "$ANIMATOR" ]; then
            if [ "$TRANSITION" = "slide" ]; then
                "$ANIMATOR" "$FULL_PATH" "$TRANSITION" "$DIRECTION" 2>/dev/null || \
                osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
            else
                "$ANIMATOR" "$FULL_PATH" "$TRANSITION" 2>/dev/null || \
                osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
            fi
        else
            osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
        fi
        
        # Save to cache
        echo "$FULL_PATH" > "$CACHE_FILE"
        
        # Success message
        clear
        echo ""
        echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧  ${MAUVE}✧${LAVENDER}·${PINK}˚${MAUVE}❀${PINK}˚${LAVENDER}·${MAUVE}✧${R}"
        echo ""
        echo -e "    ${MAUVE}╭─────────────────────────────────────╮${R}"
        echo -e "    ${MAUVE}│${R}                                     ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}   ${PINK}✧${R} ${B}${TEXT}Wallpaper Applied${R} ${PINK}✧${R}             ${MAUVE}│${R}"
        echo -e "    ${MAUVE}│${R}                                     ${MAUVE}│${R}"
        echo -e "    ${MAUVE}├─────────────────────────────────────┤${R}"
        echo -e "    ${MAUVE}│${R}   ${SUBTEXT0}File:${R} ${GREEN}$(basename "$FULL_PATH" | cut -c1-26)${R}"
        echo -e "    ${MAUVE}│${R}   ${SUBTEXT0}Effect:${R} ${LAVENDER}$TRANSITION${R}"
        [ "$TRANSITION" = "slide" ] && echo -e "    ${MAUVE}│${R}   ${SUBTEXT0}Direction:${R} ${SKY}$DIRECTION${R}"
        echo -e "    ${MAUVE}│${R}                                     ${MAUVE}│${R}"
        echo -e "    ${MAUVE}╰─────────────────────────────────────╯${R}"
        echo ""
        
        notify "$(basename "$FULL_PATH")" "Wallpaper Applied ✧"
    else
        echo -e "    ${RED}✧ File not found${R}"
        notify "File not found" "Error"
    fi
else
    notify "Selection cancelled" "Wallpaper"
fi
