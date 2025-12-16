#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        WALLPAPER SELECTOR                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/. cache/luvrksnskye/current_wallpaper"

# Display a notification
send_notification() {
    local message="$1"
    /usr/bin/osascript -e "display notification \"${message}\" with title \"Wallpaper Selector\""
}

mkdir -p "$HOME/.cache/luvrksnskye"
mkdir -p "$WALLPAPER_DIR"

# Colors — CATPPUCCIN MOCHA (True Color)
C_RESET='\033[0m'
C_DIM='\033[2m'
C_BOLD='\033[1m'
C_MAUVE='\033[38;2;203;166;247m'
C_LAVENDER='\033[38;2;180;190;254m'
C_PINK='\033[38;2;245;194;231m'
C_BLUE='\033[38;2;137;180;250m'
C_SKY='\033[38;2;137;220;235m'
C_TEAL='\033[38;2;148;226;213m'
C_GREEN='\033[38;2;166;227;161m'
C_YELLOW='\033[38;2;249;226;175m'
C_PEACH='\033[38;2;250;179;135m'
C_TEXT='\033[38;2;205;214;244m'
C_SUBTEXT='\033[38;2;166;173;200m'
C_OVERLAY='\033[38;2;125;130;152m'
C_SURFACE='\033[38;2;69;71;90m'
C_BASE='\033[38;2;30;30;46m'
C_MANTLE='\033[38;2;24;24;37m'
C_CRUST='\033[38;2;17;17;27m'

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
    │                         WALLPAPER                               │
    │                                                                  │
    │                          SELECTOR                                │
    │                                                                  │
    │                                                                  │
    ╰──────────────────────────────────────────────────────────────────╯
EOF
  echo -e "${C_RESET}"
}

print_footer() {
  echo ""
  echo -e "${C_DIM}────────────────────────────────────────────────────────────────────${C_RESET}"
  echo ""
  echo -e "  ${C_SUBTEXT} Navigation${C_RESET}"
  echo -e "  ${C_MAUVE}↑/↓${C_RESET}         Move selection"
  echo -e "  ${C_MAUVE}⏎ Enter${C_RESET}       Apply wallpaper"
  echo -e "  ${C_MAUVE}⇆ Tab${C_RESET}         Toggle preview"
  echo -e "  ${C_MAUVE}⎋ Esc${C_RESET}         Cancel"
  echo ""
  echo -e "  ${C_SUBTEXT}✨ Transition effects${C_RESET}"
  echo -e "  ${C_SKY}1${C_RESET} liquid   ${C_TEAL}2${C_RESET} wave   ${C_LAVENDER}3${C_RESET} grow   ${C_PEACH}4${C_RESET} fade   ${C_MAUVE}5${C_RESET} spiral   ${C_PINK}6${C_RESET} fold   ${C_BLUE}7${C_RESET} slide"
  echo -e "  ${C_SUBTEXT}Press ${C_YELLOW}8${C_RESET} to change slide direction${C_RESET}"
  echo ""
}

# Main selection logic
main() {
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
    send_notification "No wallpapers found. Add images to ${WALLPAPER_DIR}." # Added notification
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
  export DIRECTION="left"

  # Function to change transition
  change_transition() {
    case "$1" in
      1) TRANSITION="liquid" ;;
      2) TRANSITION="wave" ;;
      3) TRANSITION="grow" ;;
      4) TRANSITION="fade" ;;
      5) TRANSITION="spiral" ;;
      6) TRANSITION="fold" ;;
      7) TRANSITION="slide" ;;
      *) TRANSITION="wave" ;;
    esac
    echo -e "\n  ${C_GREEN}Transition: ${C_RESET}${C_PINK}$TRANSITION${C_RESET}"
  }

  # Function to change slide direction
  change_direction() {
      case "$DIRECTION" in
          left) DIRECTION="right" ;;
          right) DIRECTION="up" ;;
          up) DIRECTION="down" ;;
          down) DIRECTION="left" ;;
      esac
      echo -e "\n  ${C_GREEN}Slide Direction: ${C_RESET}${C_PINK}$DIRECTION${C_RESET}"
  }

  export -f change_transition
  export -f change_direction


  # Custom preview command
  PREVIEW_CMD="bash -lc '
  sel=\"\$1\"
  sel=\"\${sel#\* }\"
  sel=\"\${sel#  }\"
  file=\"$WALLPAPER_DIR/\$sel\"

  # Get terminal size
  TERM_WIDTH=\$(tput cols)
  TERM_HEIGHT=\$(tput lines)

  # fzf preview window is 50% of terminal width
  # Allocate 48% of terminal width for image to leave some padding
  PREVIEW_WIDTH=\$((\$TERM_WIDTH * 48 / 100))
  PREVIEW_HEIGHT=\$((\$TERM_HEIGHT * 80 / 100)) # Use 80% of terminal height

  # Deduct some space for FZF UI and padding
  PREVIEW_WIDTH=\$((PREVIEW_WIDTH - 4)) # Account for fzf border and padding
  PREVIEW_HEIGHT=\$((PREVIEW_HEIGHT - 2)) # Account for fzf border and padding

  # Ensure minimum size to display some content
  [ \$PREVIEW_WIDTH -lt 10 ] && PREVIEW_WIDTH=10
  [ \$PREVIEW_HEIGHT -lt 5 ] && PREVIEW_HEIGHT=5

  if command -v chafa &>/dev/null; then
      chafa --size=\${PREVIEW_WIDTH}x\${PREVIEW_HEIGHT} --symbols=ascii+block+border --colors=256 --fill=space \"\$file\"
  elif command -v viu &>/dev/null; then
      viu --width \$PREVIEW_WIDTH --height \$PREVIEW_HEIGHT \"\$file\"
  elif command -v timg &>/dev/null; then
      timg -w \$PREVIEW_WIDTH -h \$PREVIEW_HEIGHT \"\$file\"
  elif command -v imgcat &>/dev/null; then
      # imgcat does not have size parameters, relies on terminal emulator.
      # This might overflow the frame.
      imgcat \"\$file\" 2>/dev/null
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
    --bind="7:execute(change_transition 7)+refresh-preview" \
    --bind="8:execute(change_direction)+refresh-preview" \
    --bind="tab:toggle-preview"
  )

  if [ -n "$SELECTED" ]; then
    FILE="$SELECTED"
    FILE="${FILE#\* }"
    FILE="${FILE#  }"

    FULL_PATH="$WALLPAPER_DIR/$FILE"

    if [ -f "$FULL_PATH" ]; then
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

      echo "$FULL_PATH" > "$CACHE_FILE"

      clear
      echo ""
      echo -e "${C_LAVENDER}"
      cat << 'EOF'
    ✨ Wallpaper Applied ✨
EOF
      echo -e "${C_RESET}"
      echo -e "  ${C_GREEN}$(basename "$FULL_PATH")${C_RESET}"
      echo ""
      echo -e "  ${C_SUBTEXT}Transition:  ${C_RESET}${C_PINK}$TRANSITION${C_RESET}"
      if [ "$TRANSITION" = "slide" ]; then
        echo -e "  ${C_SUBTEXT}Direction:   ${C_RESET}${C_PINK}$DIRECTION${C_RESET}"
      fi
      echo ""
      send_notification "Wallpaper set to $(basename "$FULL_PATH")"
    else
      echo ""
      echo -e "  ${C_PINK}Error: File not found${C_RESET}"
      echo "  $FULL_PATH"
      echo ""
      send_notification "Error: Wallpaper not found at $FULL_PATH"
    fi
  else
    send_notification "Wallpaper selection cancelled."
  fi
}

# Run main logic
main "$@"