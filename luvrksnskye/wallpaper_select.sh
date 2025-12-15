#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        WALLPAPER SELECTOR                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"

mkdir -p "$HOME/.cache/luvrksnskye"
mkdir -p "$WALLPAPER_DIR"

# Colors — CATPPUCCIN MOCHA (NO TOCAR)
C_RESET='\033[0m'
C_DIM='\033[2m'
C_PURPLE='\033[38;5;141m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_GRAY='\033[38;5;245m'

print_header() {
  clear
  echo ""
  echo -e "${C_LAVENDER}"
  cat << 'EOF'
    ╭──────────────────────────────────────────────────────────────────╮
    │                                                                  │
    │   ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗     │
    │   ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗    │
    │   ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝    │
    │   ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝     │
    │   ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║         │
    │    ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝         │
    │                                                                  │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
  echo -e "${C_RESET}"
}

print_footer() {
  echo ""
  echo -e "${C_DIM}────────────────────────────────────────────────────────────────────${C_RESET}"
  echo ""
  echo -e "  ${C_GRAY}Navigation${C_RESET}"
  echo -e "  ${C_PURPLE}Up/Down${C_RESET}     Move selection"
  echo -e "  ${C_PURPLE}Enter${C_RESET}       Apply wallpaper"
  echo -e "  ${C_PURPLE}Esc${C_RESET}         Cancel"
  echo ""
}

# Check fzf
if ! command -v fzf &>/dev/null; then
  print_header
  echo ""
  echo -e "  ${C_PINK}fzf is required${C_RESET}"
  echo -e "  ${C_LAVENDER}brew install fzf${C_RESET}"
  echo ""
  exit 1
fi

# Find wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( \
  -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \
\) 2>/dev/null | sort)

if [ -z "$WALLPAPERS" ]; then
  print_header
  echo ""
  echo -e "  ${C_PINK}No wallpapers found${C_RESET}"
  echo -e "  Add images to: ${C_LAVENDER}$WALLPAPER_DIR${C_RESET}"
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

SELECTED=$(display_list | fzf \
  --ansi \
  --no-bold \
  --cycle \
  --reverse \
  --border=rounded \
  --border-label=" Select Wallpaper " \
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
  --preview="bash -lc '
sel=\"\$1\"
sel=\"\${sel#\* }\"
sel=\"\${sel#  }\"
file=\"$WALLPAPER_DIR/\$sel\"

if command -v chafa &>/dev/null; then
  chafa --size=40x20 \"\$file\" 2>/dev/null
elif command -v imgcat &>/dev/null; then
  imgcat --width 40 \"\$file\" 2>/dev/null
else
  echo \"Preview not available\"
  echo \"brew install chafa\"
fi
' _ {}" \
  --header=$'\n  Current wallpaper marked with *\n'
)

if [ -n "$SELECTED" ]; then
  FILE="$SELECTED"
  FILE="${FILE#\* }"
  FILE="${FILE#  }"

  FULL_PATH="$WALLPAPER_DIR/$FILE"

  if [ -f "$FULL_PATH" ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
    echo "$FULL_PATH" > "$CACHE_FILE"

    clear
    echo ""
    echo -e "${C_LAVENDER}Wallpaper Applied${C_RESET}"
    echo -e "  ${C_GREEN}$(basename "$FULL_PATH")${C_RESET}"
    echo ""
  else
    echo ""
    echo -e "  ${C_PINK}Error: File not found${C_RESET}"
    echo "  $FULL_PATH"
    echo ""
  fi
fi
