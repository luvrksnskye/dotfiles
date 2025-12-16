#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        WALLPAPER SELECTOR                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/. cache/luvrksnskye/current_wallpaper"

mkdir -p "$HOME/.cache/luvrksnskye"
mkdir -p "$WALLPAPER_DIR"

# Colors — CATPPUCCIN MOCHA
C_RESET='\033[0m'
C_DIM='\033[2m'
C_BOLD='\033[1m'
C_PURPLE='\033[38;5;141m'    # mauve
C_LAVENDER='\033[38;5;183m'  # lavender
C_PINK='\033[38;5;218m'      # pink
C_BLUE='\033[38;5;111m'      # blue
C_SKY='\033[38;5;117m'       # sky
C_TEAL='\033[38;5;116m'      # teal
C_GREEN='\033[38;5;114m'     # green
C_YELLOW='\033[38;5;222m'    # yellow
C_PEACH='\033[38;5;216m'     # peach
C_TEXT='\033[38;5;189m'      # text
C_SUBTEXT='\033[38;5;245m'   # subtext0
C_OVERLAY='\033[38;5;147m'   # overlay0
C_SURFACE='\033[38;5;127m'   # surface1
C_BASE='\033[38;5;30m'       # base
C_MANTLE='\033[38;5;23m'     # mantle
C_CRUST='\033[38;5;17m'      # crust

# Animator
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANIMATOR="$SCRIPT_DIR/wallpaper_animate"
TRANSITION_TYPE="${1:-wave}"

print_header() {
  clear
  echo ""
  echo -e "${C_LAVENDER}"
  cat << 'EOF'
    ╭──────────────────────────────────────────────────────────────────╮
    │                                                                  │
    │   ╱|、                    WALLPAPER                              │
    │  (˚ˎ 。7                                                         │
    │   |、˜〵                     SELECTOR                             │
    │   じしˍ,)ノ                                                       │
    │                                                                  │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
  echo -e "${C_RESET}"
}

print_footer() {
  echo ""
  echo -e "${C_DIM}────────────────────────────────────────────────────────────────────${C_RESET}"
  echo ""
  echo -e "  ${C_SUBTEXT}Navigation${C_RESET}"
  echo -e "  ${C_PURPLE}↑/↓${C_RESET}         Move selection"
  echo -e "  ${C_PURPLE}Enter${C_RESET}       Apply wallpaper"
  echo -e "  ${C_PURPLE}Tab${C_RESET}         Toggle preview"
  echo -e "  ${C_PURPLE}Esc${C_RESET}         Cancel"
  echo ""
  echo -e "  ${C_SUBTEXT}Transition effects${C_RESET}"
  echo -e "  ${C_SKY}1${C_RESET} liquid   ${C_TEAL}2${C_RESET} wave   ${C_LAVENDER}3${C_RESET} grow   ${C_PEACH}4${C_RESET} fade   ${C_PURPLE}5${C_RESET} spiral"
  echo ""
}

# Check fzf
if !  command -v fzf &>/dev/null; then
  print_header
  echo ""
  echo -e "  ${C_PINK}fzf is required${C_RESET}"
  echo -e "  ${C_LAVENDER}brew install fzf${C_RESET}"
  echo ""
  exit 1
fi

# Find wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \
\) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
  print_header
  echo ""
  echo -e "  ${C_PINK}No wallpapers found${C_RESET}"
  echo -e "  Add images to:  ${C_LAVENDER}$WALLPAPER_DIR${C_RESET}"
  echo ""
  exit 1
fi

CURRENT=""
[ -f "$CACHE_FILE" ] && CURRENT=$(cat "$CACHE_FILE")

display_list() {
  while IFS= read -r path; do
    name=$(basename "$path")
    if [ "$path" = "$CURRENT" ]; then
      echo "* $name"
    else
      echo "  $name"
    fi
  done <<< "$WALLPAPERS"
}

print_header
print_footer

# Set initial transition type
export TRANSITION="$TRANSITION_TYPE"

# Function to change transition
change_transition() {
  case "$1" in
    1) TRANSITION="liquid" ;;
    2) TRANSITION="wave" ;;
    3) TRANSITION="grow" ;;
    4) TRANSITION="fade" ;;
    5) TRANSITION="spiral" ;;
    6) TRANSITION="fold" ;;
    *) TRANSITION="wave" ;;
  esac
  echo -e "\n  ${C_GREEN}Transition: ${C_RESET}${C_PINK}$TRANSITION${C_RESET}"
}

export -f change_transition

# Custom preview command
PREVIEW_CMD="bash -lc '
sel=\"\$1\"
sel=\"\${sel#\* }\"
sel=\"\${sel#  }\"
file=\"$WALLPAPER_DIR/\$sel\"

# Get terminal size
TERM_WIDTH=\$(tput cols)
TERM_HEIGHT=\$(tput lines)
PREVIEW_WIDTH=\$((\$TERM_WIDTH * 45 / 100))
PREVIEW_HEIGHT=\$((\$TERM_HEIGHT - 10))

# Max/min constraints
[ \$PREVIEW_WIDTH -gt 80 ] && PREVIEW_WIDTH=80
[ \$PREVIEW_HEIGHT -gt 30 ] && PREVIEW_HEIGHT=30
[ \$PREVIEW_WIDTH -lt 40 ] && PREVIEW_WIDTH=40
[ \$PREVIEW_HEIGHT -lt 15 ] && PREVIEW_HEIGHT=15

if command -v chafa &>/dev/null; then
    chafa --size=\${PREVIEW_WIDTH}x\${PREVIEW_HEIGHT} --symbols=ascii+block+border --colors=256 --fill=space \"\$file\" 2>/dev/null
elif command -v imgcat &>/dev/null; then
    imgcat --width \$PREVIEW_WIDTH \"\$file\" 2>/dev/null
else
    echo \"╭────────────────────────────────╮\"
    echo \"│                                │\"
    echo \"│    Preview not available       │\"
    echo \"│    brew install chafa          │\"
    echo \"│                                │\"
    echo \"╰────────────────────────────────╯\"
fi

echo \"\"
echo \"\${C_DIM}File: \${C_RESET}\$(basename \"\$file\")\"
if command -v identify &>/dev/null; then
    info=\$(identify -format \"%wx%h\" \"\$file\" 2>/dev/null)
    echo \"\${C_DIM}Size:  \${C_RESET}\$info\"
fi
' _ {}"

# fzf selector with keybindings
SELECTED=$(display_list | fzf \
  --ansi \
  --no-bold \
  --cycle \
  --reverse \
  --border=rounded \
  --border-label=" ╱|、 Select Wallpaper (˚ˎ 。7 " \
  --border-label-pos=3 \
  --margin=1,2 \
  --padding=1 \
  --prompt="  " \
  --pointer=" >" \
  --color='bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8' \
  --color='fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc' \
  --color='marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' \
  --color='border:#cba6f7,label:#cba6f7' \
  --preview-window=right:50%:wrap \
  --preview="$PREVIEW_CMD" \
  --header=$'\n  Current wallpaper marked with *\n' \
  --bind="1:execute(change_transition 1)+refresh-preview" \
  --bind="2:execute(change_transition 2)+refresh-preview" \
  --bind="3:execute(change_transition 3)+refresh-preview" \
  --bind="4:execute(change_transition 4)+refresh-preview" \
  --bind="5:execute(change_transition 5)+refresh-preview" \
  --bind="6:execute(change_transition 6)+refresh-preview" \
  --bind="tab:toggle-preview"
)

if [ -n "$SELECTED" ]; then
  FILE="$SELECTED"
  FILE="${FILE#\* }"
  FILE="${FILE#  }"

  FULL_PATH="$WALLPAPER_DIR/$FILE"

  if [ -f "$FULL_PATH" ]; then
    if [ -x "$ANIMATOR" ]; then
      "$ANIMATOR" "$FULL_PATH" "$TRANSITION" 2>/dev/null || \
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
    else
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
    fi

    echo "$FULL_PATH" > "$CACHE_FILE"

    clear
    echo ""
    echo -e "${C_LAVENDER}"
    cat << 'EOF'
    ╱|、
    (˚ˎ 。7     Wallpaper Applied
    |、˜〵
    じしˍ,)ノ
EOF
    echo -e "${C_RESET}"
    echo -e "  ${C_GREEN}$(basename "$FULL_PATH")${C_RESET}"
    echo ""
    echo -e "  ${C_SUBTEXT}Transition:  ${C_RESET}${C_PINK}$TRANSITION${C_RESET}"
    echo ""
  else
    echo ""
    echo -e "  ${C_PINK}Error: File not found${C_RESET}"
    echo "  $FULL_PATH"
    echo ""
  fi
fi