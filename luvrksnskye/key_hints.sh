#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                            KEYBINDING HINTS                                ║
# ║                              Yabai + skhd                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝

clear
cat << 'EOF'

 ╔═══════════════════════════════════════════════════════════════════════════════╗
 ║                                                                               ║
 ║   ██╗   ██╗ █████╗ ██████╗  █████╗ ██╗                                       ║
 ║   ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║                                       ║
 ║    ╚████╔╝ ███████║██████╔╝███████║██║                                       ║
 ║     ╚██╔╝  ██╔══██║██╔══██╗██╔══██║██║                                       ║
 ║      ██║   ██║  ██║██████╔╝██║  ██║██║                                       ║
 ║      ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝                                       ║
 ║                                                                               ║
 ║                            Keybinding Reference                               ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   FOCUS WINDOWS                         MOVE/SWAP WINDOWS                     ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Alt + H/J/K/L        Focus (vim)      Alt + Shift + H/J/K/L   Swap (vim)    ║
 ║   Alt + Arrows         Focus (arrows)   Alt + Shift + Arrows    Swap (arrows) ║
 ║   Alt + Tab            Recent space     Ctrl + Alt + H/J/K/L    Warp/Insert   ║
 ║   Alt + P/N            Prev/Next space                                        ║
 ║                                                                               ║
 ║   INSERT WINDOWS                        LAYOUT                                ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Ctrl+Shift+Alt + K   Insert above     Alt + /                 Toggle split  ║
 ║   Ctrl+Shift+Alt + J   Insert below     Alt + F                 Float/Tile    ║
 ║   Ctrl+Shift+Alt + H   Insert left      Alt + Shift + F         Fullscreen    ║
 ║   Ctrl+Shift+Alt + L   Insert right     Alt + R                 Rotate 90°    ║
 ║                                                                               ║
 ║   RESIZE (animated)                     MINIMIZE (animated)                   ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Ctrl + Alt + Arrows  Resize window    Alt + W                 Minimize      ║
 ║   Alt + Shift + =/−    Grow/Shrink      Alt + Shift + W         Minimize all  ║
 ║   Ctrl+Shift+Alt+Arrow Fine resize      Ctrl + Alt + W          Restore last  ║
 ║   Alt + mouse drag     Free resize                                            ║
 ║                                                                               ║
 ║   WORKSPACES                            QUICK ACTIONS                         ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Alt + 1-4            Focus space      Esc                     Close window  ║
 ║   Alt + Shift + 1-4    Send to space    Alt + Q                 Close window  ║
 ║   Alt + 0              Balance windows  Alt + S                 Toggle sticky ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   LAUNCH APPS  (Alt + Shift + Letter)                                         ║
 ║   ────────────────────────────────────────────────────────────────────────    ║
 ║   Alt + Shift + T      Terminal          Alt + Shift + D        Discord       ║
 ║   Alt + Shift + B      Brave Browser     Alt + Shift + C        Claude        ║
 ║   Alt + Shift + Z      Zen Browser       Alt + Shift + V        VS Code       ║
 ║   Alt + Shift + E      Finder            Alt + Shift + M        Spotify       ║
 ║   Alt + Shift + O      Obsidian          Alt + Shift + A        Apple Music   ║
 ║   Alt + Shift + N      Notes                                                  ║
 ║                                                                               ║
 ╠═══════════════════════════════════════════════════════════════════════════════╣
 ║                                                                               ║
 ║   SERVICE                               UTILITIES                             ║
 ║   ────────────────────────────────────  ────────────────────────────────────  ║
 ║   Ctrl + Alt + R       Restart Yabai    Ctrl + Alt + G          Greeting      ║
 ║   Ctrl + Alt + S       Reload skhd      luvr greet              Greeting      ║
 ║                                                                               ║
 ║   MOUSE (hold Alt)                                                            ║
 ║   ────────────────────────────────────────────────────────────────────────    ║
 ║   Alt + Left Click     Move window                                            ║
 ║   Alt + Right Click    Resize window                                          ║
 ║                                                                               ║
 ╚═══════════════════════════════════════════════════════════════════════════════╝

EOF

echo ""
read -n 1 -s -r -p "  Press any key to close..."
echo ""
