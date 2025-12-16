#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            KEYBINDING HINTS                                ║
# ║                     Yabai + skhd (Catppuccin Mocha)                          ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Colors - Catppuccin Mocha (True Color)
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_DIM='\033[2m'
C_LAVENDER='\033[38;2;180;190;254m'
C_PINK='\033[38;2;245;194;231m'
C_MAUVE='\033[38;2;203;166;247m'
C_BLUE='\033[38;2;137;180;250m'
C_SKY='\033[38;2;137;220;235m'
C_TEAL='\033[38;2;148;226;213m'
C_GREEN='\033[38;2;166;227;161m'
C_YELLOW='\033[38;2;249;226;175m'
C_PEACH='\033[38;2;250;179;135m'
C_TEXT='\033[38;2;205;214;244m'
C_SUBTLE='\033[38;2;108;112;134m' # Overlay0
C_HIGHLIGHT='\033[38;2;245;224;220m' # Rosewater

# Animation delay
DELAY=0.005

# Animate and colorize the key hints
animate_hints() {
    while IFS= read -r line; do
        echo -e "$line"
        sleep $DELAY
    done
}

# Clear screen and hide cursor
clear
tput civis
trap 'tput cnorm; exit' INT TERM

# Pipe the here-document to the animation function
animate_hints <<EOF
${C_LAVENDER}
 ╔═══════════════════════════════════════════════════════════════════════════════╗
 ║                                                                               ║
 ║   ${C_MAUVE}██╗   ██╗ █████╗ ██████╗  █████╗ ██╗                                       ${C_LAVENDER}║
 ║   ${C_MAUVE}╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║                                       ${C_LAVENDER}║
 ║    ${C_MAUVE}╚████╔╝ ███████║██████╔╝███████║██║                                       ${C_LAVENDER}║
 ║     ${C_MAUVE}╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║                                       ${C_LAVENDER}║
 ║      ${C_MAUVE}██║   ██║  ██║██████╔╝██║  ██║██║                                       ${C_LAVENDER}║
 ║      ${C_MAUVE}╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝                                       ${C_LAVENDER}║
 ║                                                                               ║
 ║                       ${C_BOLD}${C_SKY}Keybinding Reference${C_RESET}                               ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   ${C_BOLD}${C_GREEN}FOCUS WINDOWS                         ${C_BOLD}${C_GREEN}MOVE/SWAP WINDOWS                     ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────  ────────────────────────────────────  ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + H/J/K/L       ${C_TEXT} Focus (vim)      ${C_PEACH}Alt + Shift + H/J/K/L   ${C_TEXT}Swap (vim)    ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Arrows        ${C_TEXT} Focus (arrows)   ${C_PEACH}Alt + Shift + Arrows    ${C_TEXT}Swap (arrows) ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Tab           ${C_TEXT} Recent space     ${C_PEACH}Ctrl + Alt + H/J/K/L    ${C_TEXT}Warp/Insert   ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + P/N           ${C_TEXT} Prev/Next space                                        ${C_LAVENDER}║
 ║                                                                               ║
 ║   ${C_BOLD}${C_GREEN}INSERT WINDOWS                        ${C_BOLD}${C_GREEN}LAYOUT                                ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────  ────────────────────────────────────  ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl+Shift+Alt + K  ${C_TEXT} Insert above     ${C_PEACH}Alt + /                 ${C_TEXT}Toggle split  ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl+Shift+Alt + J  ${C_TEXT} Insert below     ${C_PEACH}Alt + F                 ${C_TEXT}Float/Tile    ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl+Shift+Alt + H  ${C_TEXT} Insert left      ${C_PEACH}Alt + Shift + F         ${C_TEXT}Fullscreen    ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl+Shift+Alt + L  ${C_TEXT} Insert right     ${C_PEACH}Alt + R                 ${C_TEXT}Rotate 90°    ${C_LAVENDER}║
 ║                                                                               ║
 ║   ${C_BOLD}${C_GREEN}RESIZE (animated)                     ${C_BOLD}${C_GREEN}MINIMIZE (animated)                   ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────  ────────────────────────────────────  ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl + Alt + Arrows ${C_TEXT} Resize window    ${C_PEACH}Alt + W                 ${C_TEXT}Minimize      ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Shift + =/−   ${C_TEXT} Grow/Shrink      ${C_PEACH}Alt + Shift + W         ${C_TEXT}Minimize all  ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl+Shift+Alt+Arrow ${C_TEXT}Fine resize      ${C_PEACH}Ctrl + Alt + W          ${C_TEXT}Restore last  ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + mouse drag    ${C_TEXT} Free resize                                            ${C_LAVENDER}║
 ║                                                                               ║
 ║   ${C_BOLD}${C_GREEN}WORKSPACES                            ${C_BOLD}${C_GREEN}QUICK ACTIONS                         ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────  ────────────────────────────────────  ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + 1-4           ${C_TEXT} Focus space      ${C_PEACH}Esc                     ${C_TEXT}Close window  ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Shift + 1-4   ${C_TEXT} Send to space    ${C_PEACH}Alt + Q                 ${C_TEXT}Close window  ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + 0             ${C_TEXT} Balance windows  ${C_PEACH}Alt + S                 ${C_TEXT}Toggle sticky ${C_LAVENDER}║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   ${C_BOLD}${C_BLUE}LAUNCH APPS  (Alt + Shift + Letter)                                         ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────────────────────────────────────────    ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + T     ${C_TEXT} Terminal          ${C_PINK}Alt + Shift + D        ${C_TEXT}Discord       ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + B     ${C_TEXT} Brave Browser     ${C_PINK}Alt + Shift + C        ${C_TEXT}Claude        ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + Z     ${C_TEXT} Zen Browser       ${C_PINK}Alt + Shift + V        ${C_TEXT}VS Code       ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + E     ${C_TEXT} Finder            ${C_PINK}Alt + Shift + M        ${C_TEXT}Spotify       ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + O     ${C_TEXT} Obsidian          ${C_PINK}Alt + Shift + A        ${C_TEXT}Apple Music   ${C_LAVENDER}║
 ║   ${C_PINK}Alt + Shift + N     ${C_TEXT} Notes                                                  ${C_LAVENDER}║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   ${C_BOLD}${C_YELLOW}SERVICE                               ${C_BOLD}${C_YELLOW}UTILITIES                             ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────  ────────────────────────────────────  ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl + Alt + R      ${C_TEXT} Restart Yabai    ${C_PEACH}Ctrl + Alt + G          ${C_TEXT}Greeting      ${C_LAVENDER}║
 ║   ${C_PEACH}Ctrl + Alt + S      ${C_TEXT} Reload skhd      ${C_PEACH}luvr greet              ${C_TEXT}Greeting      ${C_LAVENDER}║
 ║                                                                               ║
 ║   ${C_BOLD}${C_YELLOW}MOUSE (hold Alt)                                                            ${C_LAVENDER}║
 ║   ${C_SUBTLE}────────────────────────────────────────────────────────────────────────    ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Left Click    ${C_TEXT} Move window                                            ${C_LAVENDER}║
 ║   ${C_PEACH}Alt + Right Click   ${C_TEXT} Resize window                                          ${C_LAVENDER}║
 ║                                                                               ║
 ╚═══════════════════════════════════════════════════════════════════════════════╝
${C_RESET}
EOF

echo ""
read -n 1 -s -r -p "  Press any key to close..."
echo ""
tput cnorm

