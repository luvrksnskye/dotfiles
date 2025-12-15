#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            KEYBINDING HINTS                                ║
# ╚════════════════════════════════════════════════════════════════════════════╝

clear
cat << 'EOF'

 ╔═══════════════════════════════════════════════════════════════════════════════╗
 ║                                                                               ║
 ║    █████╗ ███████╗██████╗  ██████╗ ███████╗██████╗  █████╗  ██████╗███████╗  ║
 ║   ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝  ║
 ║   ███████║█████╗  ██████╔╝██║   ██║███████╗██████╔╝███████║██║     █████╗    ║
 ║   ██╔══██║██╔══╝  ██╔══██╗██║   ██║╚════██║██╔═══╝ ██╔══██║██║     ██╔══╝    ║
 ║   ██║  ██║███████╗██║  ██║╚██████╔╝███████║██║     ██║  ██║╚██████╗███████╗  ║
 ║   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝  ║
 ║                                                                               ║
 ║                            Keybinding Reference                               ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   NAVIGATION                            MOVE WINDOWS                          ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Alt + H/J/K/L        Focus (vim)      Alt + Shift + H/J/K/L   Move (vim)    ║
 ║   Alt + Arrows         Focus (arrows)   Alt + Shift + Arrows    Move (arrows) ║
 ║   Alt + 1-4            Workspace        Alt + Shift + 1-4       Send to WS    ║
 ║   Alt + Tab            Back and forth   Alt + Shift + Tab       Move to mon   ║
 ║                                                                               ║
 ║   LAYOUT                                RESIZE                                ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Alt + /              Toggle H/V       Alt + Shift + =         Grow          ║
 ║   Alt + ,              Toggle accordion Alt + Shift + -         Shrink        ║
 ║   Alt + Ctrl + F       Float/Tile       Alt + Ctrl + Shift + F  Fullscreen    ║
 ║                                                                               ║
 ║   JOIN WINDOWS                          MODES                                 ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Alt + Ctrl + H       Join left        Alt + Enter             Nav mode      ║
 ║   Alt + Ctrl + J       Join down        Alt + Shift + ;         Apps mode     ║
 ║   Alt + Ctrl + K       Join up          Alt + Shift + S         Service mode  ║
 ║   Alt + Ctrl + L       Join right                                             ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   NAV MODE  (Alt + Enter to activate, Esc/Enter to exit)                      ║
 ║   ────────────────────────────────────────────────────────────────────────    ║
 ║   Arrows / HJKL        Focus windows     Shift + Arrows/HJKL  Move windows    ║
 ║   1-4                  Go to workspace   F                    Float/Tile      ║
 ║   M                    Fullscreen        Q                    Close window    ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   LAUNCH APPS  (Direct shortcuts - no mode needed)                            ║
 ║   ────────────────────────────────────────────────────────────────────────    ║
 ║   Alt + Shift + T      Terminal          Alt + Shift + D        Discord       ║
 ║   Alt + Shift + B      Brave Browser     Alt + Shift + C        Claude        ║
 ║   Alt + Shift + Z      Zen Browser       Alt + Shift + V        VS Code       ║
 ║   Alt + Shift + F      Finder            Alt + Shift + M        Spotify       ║
 ║   Alt + Shift + O      Obsidian          Alt + Shift + N        Notes         ║
 ║   Alt + Shift + P      Preview                                                ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   SERVICE MODE  (Alt + Shift + S to activate, Esc to exit and reload)         ║
 ║   ────────────────────────────────────────────────────────────────────────    ║
 ║   R                    Reset layout      Backspace              Close others  ║
 ║   F                    Float/Tile                                             ║
 ║                                                                               ║
 ╚═══════════════════════════════════════════════════════════════════════════════╝

EOF

echo ""
read -n 1 -s -r -p "  Press any key to close..."
echo ""
