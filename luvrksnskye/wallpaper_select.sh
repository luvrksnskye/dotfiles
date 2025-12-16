#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                        WALLPAPER SELECTOR                                  ║
# ║                  Animated Desktop Transition (Swift)                       ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"

mkdir -p "$HOME/.cache/luvrksnskye"
mkdir -p "$WALLPAPER_DIR"

# ─────────────────────────────────────────────────────────────────────────────
# Colors — CATPPUCCIN MOCHA (NO TOCAR)
# ─────────────────────────────────────────────────────────────────────────────
C_RESET='\033[0m'
C_DIM='\033[2m'
C_PURPLE='\033[38;5;141m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'
C_GRAY='\033[38;5;245m'

# ─────────────────────────────────────────────────────────────────────────────
# Header / Footer
# ─────────────────────────────────────────────────────────────────────────────
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

# ─────────────────────────────────────────────────────────────────────────────
# Animated Wallpaper (Swift / AppKit)
# ─────────────────────────────────────────────────────────────────────────────
apply_wallpaper() {
  local path="$1"
  local transition="wave"

  if command -v swift >/dev/null 2>&1; then
    /usr/bin/swift - <<SWIFT
import Cocoa
import Foundation

_ = NSApplication.shared
NSApp.setActivationPolicy(.accessory)

let wallpaperPath = "$path"

final class WallpaperAnimator {
    let duration: Double = 0.6
    let steps: Int = 12

    func setWallpaper(_ path: String) {
        let url = URL(fileURLWithPath: path)
        let workspace = NSWorkspace.shared

        for screen in NSScreen.screens {
            let overlay = createOverlayWindow(for: screen)
            animateOverlay(overlay) {
                try? workspace.setDesktopImageURL(url, for: screen, options: [:])
                self.fadeOutOverlay(overlay)
            }
        }

        RunLoop.main.run(until: Date(timeIntervalSinceNow: duration + 0.8))
    }

    func createOverlayWindow(for screen: NSScreen) -> NSWindow {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.backgroundColor = NSColor(calibratedRed: 0.12, green: 0.12, blue: 0.18, alpha: 0.9)
        window.isOpaque = false
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.orderFront(nil)
        return window
    }

    func animateOverlay(_ window: NSWindow, completion: @escaping () -> Void) {
        let stepDuration = duration / Double(steps)

        DispatchQueue.global().async {
            for i in 0...self.steps {
                let t = Double(i) / Double(self.steps)
                let eased = self.easeOutBack(t)

                DispatchQueue.main.sync {
                    window.alphaValue = CGFloat(1.0 - eased)
                }

                Thread.sleep(forTimeInterval: stepDuration)
            }
            DispatchQueue.main.async { completion() }
        }
    }

    func fadeOutOverlay(_ window: NSWindow) {
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.25
            window.animator().alphaValue = 0
        }, completionHandler: {
            window.orderOut(nil)
        })
    }

    func easeOutBack(_ t: Double) -> Double {
        let c1 = 1.70158
        let c3 = c1 + 1
        return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2)
    }
}

WallpaperAnimator().setWallpaper(wallpaperPath)
SWIFT
    return $?
  fi

  return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# Checks
# ─────────────────────────────────────────────────────────────────────────────
if ! command -v fzf &>/dev/null; then
  print_header
  echo ""
  echo -e "  ${C_PINK}fzf is required${C_RESET}"
  echo -e "  ${C_LAVENDER}brew install fzf${C_RESET}"
  echo ""
  exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Find wallpapers
# ─────────────────────────────────────────────────────────────────────────────
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( \
  -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \
\) 2>/dev/null | sort)

[ -z "$WALLPAPERS" ] && exit 1

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

# ─────────────────────────────────────────────────────────────────────────────
# UI
# ─────────────────────────────────────────────────────────────────────────────
print_header
print_footer

SELECTED=$(display_list | fzf \
  --ansi --no-bold --cycle --reverse \
  --border=rounded \
  --border-label=" Select Wallpaper " \
  --border-label-pos=3 \
  --margin=1,2 --padding=1 \
  --prompt="  " --pointer=" >" \
  --color='bg+:#313244,bg:#1e1e2e,hl:#f38ba8,fg:#cdd6f4,pointer:#f5e0dc' \
  --preview-window=right:50%:wrap \
  --preview="chafa --size=40x20 \"$WALLPAPER_DIR/{2}\" 2>/dev/null"
)

# ─────────────────────────────────────────────────────────────────────────────
# Apply
# ─────────────────────────────────────────────────────────────────────────────
if [ -n "$SELECTED" ]; then
  FILE="${SELECTED#\* }"
  FILE="${FILE#  }"
  FULL_PATH="$WALLPAPER_DIR/$FILE"

  if apply_wallpaper "$FULL_PATH" 2>/dev/null; then
    echo "$FULL_PATH" > "$CACHE_FILE"
  else
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$FULL_PATH\""
    echo "$FULL_PATH" > "$CACHE_FILE"
  fi

  clear
  echo ""
  echo -e "${C_LAVENDER}Wallpaper Applied${C_RESET}"
  echo -e "  ${C_GREEN}$(basename "$FULL_PATH")${C_RESET}"
  echo ""
fi
