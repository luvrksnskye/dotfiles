#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  WALLPAPER SELECTOR  *:･ﾟ✧*:･ﾟ✧                           │
# ╰─────────────────────────────────────────────────────────────────────────────╯

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/luvrksnskye"
CACHE_FILE="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"
mkdir -p "$WALLPAPER_DIR"

# Colors
R='\033[0m'
B='\033[1m'
DIM='\033[2m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'
RED='\033[38;2;243;139;168m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'

export WALLPAPER_DIR CACHE_FILE

# Check fzf
if ! command -v fzf &>/dev/null; then
    echo -e "  ${PINK}✧ fzf required:${R} brew install fzf"
    exit 1
fi

# Find wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \
\) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
    echo -e "  ${PINK}✧ No wallpapers in:${R} $WALLPAPER_DIR"
    exit 1
fi

CURRENT=""
[ -f "$CACHE_FILE" ] && CURRENT=$(cat "$CACHE_FILE")

# Build list
display_list() {
    while IFS= read -r path; do
        name=$(basename "$path")
        [ "$path" = "$CURRENT" ] && echo "♡ $name" || echo "  $name"
    done <<< "$WALLPAPERS"
}

# Preview script
PREVIEW_SCRIPT=$(mktemp)
cat > "$PREVIEW_SCRIPT" << 'EOF'
#!/bin/bash
R='\033[0m'
B='\033[1m'
DIM='\033[2m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
GREEN='\033[38;2;166;227;161m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT0='\033[38;2;166;173;200m'

sel="$1"
sel="${sel#♡ }"
sel="${sel#  }"
file="$WALLPAPER_DIR/$sel"

W=${FZF_PREVIEW_COLUMNS:-50}
H=${FZF_PREVIEW_LINES:-20}
IW=$(( W - 4 ))
IH=$(( H - 10 ))
[ $IW -lt 20 ] && IW=20
[ $IH -lt 8 ] && IH=8

echo ""
echo -e "${MAUVE}  ╭──────────────────────────────────────╮${R}"
echo -e "${MAUVE}  │${R}  ${PINK}✧${R} ${B}${TEXT}Preview${R}                            ${MAUVE}│${R}"
echo -e "${MAUVE}  ╰──────────────────────────────────────╯${R}"
echo ""

if [ -f "$file" ]; then
    if command -v chafa &>/dev/null; then
        chafa "$file" --size="${IW}x${IH}" --symbols=all --colors=full --color-space=din99d 2>/dev/null
    elif command -v viu &>/dev/null; then
        viu -w "$IW" -h "$IH" "$file" 2>/dev/null
    elif command -v imgcat &>/dev/null; then
        imgcat --width "$IW" "$file" 2>/dev/null
    else
        echo -e "  ${DIM}Install chafa for preview: brew install chafa${R}"
    fi
fi

echo ""
fname=$(basename "$file")
[ ${#fname} -gt 30 ] && fname="${fname:0:27}..."

echo -e "${MAUVE}  ╭──────────────────────────────────────╮${R}"
if [ -f "$file" ]; then
    size=$(ls -lh "$file" 2>/dev/null | awk '{print $5}')
    dims=""
    if command -v sips &>/dev/null; then
        w=$(sips -g pixelWidth "$file" 2>/dev/null | tail -1 | awk '{print $2}')
        h=$(sips -g pixelHeight "$file" 2>/dev/null | tail -1 | awk '{print $2}')
        [ -n "$w" ] && [ -n "$h" ] && dims="${w}×${h}"
    fi
    printf "${MAUVE}  │${R}  ${TEXT}%-30s${R}    ${MAUVE}│${R}\n" "$fname"
    [ -n "$dims" ] && printf "${MAUVE}  │${R}  ${SUBTEXT0}%s  •  %s${R}                       ${MAUVE}│${R}\n" "$size" "$dims"
fi
echo -e "${MAUVE}  ╰──────────────────────────────────────╯${R}"
EOF
chmod +x "$PREVIEW_SCRIPT"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"

clear
echo ""
echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧${R}"
echo ""

SELECTED=$(display_list | fzf \
    --ansi \
    --cycle \
    --reverse \
    --border=rounded \
    --border-label="  ♡ Wallpaper Selector  " \
    --margin=1,2 \
    --padding=1 \
    --prompt="  ❀ " \
    --pointer=" ♡" \
    --color='bg+:#313244,bg:#1e1e2e,spinner:#f5c2e7,hl:#f5c2e7' \
    --color='fg:#cdd6f4,header:#cba6f7,info:#cba6f7,pointer:#f5c2e7' \
    --color='marker:#f5c2e7,fg+:#f5c2e7,prompt:#cba6f7,hl+:#f5c2e7' \
    --color='border:#cba6f7,label:#f5c2e7' \
    --preview-window='right:50%:border-rounded' \
    --preview="WALLPAPER_DIR='$WALLPAPER_DIR' '$PREVIEW_SCRIPT' {}" \
    --header=$'  ♡ = current wallpaper
  [enter] apply  [tab] toggle preview'
)

rm -f "$PREVIEW_SCRIPT"

if [ -n "$SELECTED" ]; then
    FILE="${SELECTED#♡ }"
    FILE="${FILE#  }"
    FULL_PATH="$WALLPAPER_DIR/$FILE"
    
    if [ -f "$FULL_PATH" ]; then
        if [ -x "$ANIMATOR" ]; then
            "$ANIMATOR" "$FULL_PATH" 2>/dev/null || \
            osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
        else
            osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
        fi
        
        echo "$FULL_PATH" > "$CACHE_FILE"
        
        clear
        echo ""
        echo -e "    ${PINK}✧${MAUVE}·${LAVENDER}˚${PINK}❀${LAVENDER}˚${MAUVE}·${PINK}✧${R}"
        echo ""
        echo -e "    ${GREEN}${R} ${TEXT}$(basename "$FULL_PATH")${R}"
        echo ""
        
        osascript -e "display notification \"$(basename "$FULL_PATH")\" with title \"Wallpaper\"" 2>/dev/null
    else
        echo -e "    ${RED}✧ File not found${R}"
    fi
fi
