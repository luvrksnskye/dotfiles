#!/bin/bash

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                      SET WALLPAPER WITH ANIMATION                          ║
# ║                    Smooth ripple/wave transition effect                     ║
# ╚════════════════════════════════════════════════════════════════════════════╝

WALLPAPER="$1"
CACHE_DIR="$HOME/.cache/luvrksnskye/wallpaper"
CACHE_FILE="$HOME/.cache/luvrksnskye/current_wallpaper"
TRANSITION_TYPE="${2:-wave}"

C_RESET='\033[0m'
C_LAVENDER='\033[38;5;183m'
C_PINK='\033[38;5;218m'
C_GREEN='\033[38;5;114m'

mkdir -p "$CACHE_DIR"
mkdir -p "$(dirname "$CACHE_FILE")"

if [ -z "$WALLPAPER" ]; then
  echo -e "  ${C_PINK}Usage:${C_RESET} luvr wall-set /path/to/image [wave|fade|grow]"
  exit 1
fi

if [ ! -f "$WALLPAPER" ]; then
  echo -e "  ${C_PINK}File not found:${C_RESET} $WALLPAPER"
  exit 1
fi

# Prefer realpath if available; otherwise fall back
if command -v realpath >/dev/null 2>&1; then
  WALLPAPER="$(realpath "$WALLPAPER")"
else
  WALLPAPER="$(cd "$(dirname "$WALLPAPER")" && pwd)/$(basename "$WALLPAPER")"
fi

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                    ANIMATED TRANSITION WITH SWIFT                          │
# └────────────────────────────────────────────────────────────────────────────┘

animate_wallpaper() {
  local new_wallpaper="$1"
  local transition="$2"

  /usr/bin/swift - <<SWIFT
import Cocoa
import Foundation

_ = NSApplication.shared
NSApp.setActivationPolicy(.accessory)

let wallpaperPath = "$new_wallpaper"
let transitionType = "$transition"

final class WallpaperAnimator {
    let duration: Double = 0.6
    let steps: Int = 12

    func setWallpaper(_ path: String) {
        let url = URL(fileURLWithPath: path)
        let workspace = NSWorkspace.shared

        for screen in NSScreen.screens {
            let overlay = createOverlayWindow(for: screen)

            animateOverlay(overlay, type: transitionType) {
                do {
                    try workspace.setDesktopImageURL(url, for: screen, options: [:])
                } catch {
                    print("Error: \\(error)")
                }
                self.fadeOutOverlay(overlay)
            }
        }

        // Keep AppKit alive long enough to render the animation
        RunLoop.main.run(until: Date(timeIntervalSinceNow: duration + 0.9))
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

    func animateOverlay(_ window: NSWindow, type: String, completion: @escaping () -> Void) {
        let stepDuration = duration / Double(steps)

        DispatchQueue.global().async {
            for i in 0...self.steps {
                let progress = Double(i) / Double(self.steps)

                DispatchQueue.main.sync {
                    switch type {
                    case "wave":
                        window.alphaValue = CGFloat(1.0 - self.easeOutBack(progress))
                    case "grow":
                        window.alphaValue = CGFloat(1.0 - self.easeOutBounce(progress))
                    case "fade":
                        window.alphaValue = CGFloat(1.0 - self.easeInOutQuad(progress))
                    default:
                        window.alphaValue = CGFloat(1.0 - progress)
                    }
                }

                Thread.sleep(forTimeInterval: stepDuration)
            }

            DispatchQueue.main.async { completion() }
        }
    }

    func fadeOutOverlay(_ window: NSWindow) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
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

    func easeOutBounce(_ t: Double) -> Double {
        let n1 = 7.5625
        let d1 = 2.75
        var t = t

        if t < 1 / d1 { return n1 * t * t }
        else if t < 2 / d1 { t -= 1.5 / d1; return n1 * t * t + 0.75 }
        else if t < 2.5 / d1 { t -= 2.25 / d1; return n1 * t * t + 0.9375 }
        else { t -= 2.625 / d1; return n1 * t * t + 0.984375 }
    }

    func easeInOutQuad(_ t: Double) -> Double {
        return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
}

WallpaperAnimator().setWallpaper(wallpaperPath)
SWIFT
}

# Try Swift animation, fallback to simple AppleScript
if command -v swift &>/dev/null; then
  animate_wallpaper "$WALLPAPER" "$TRANSITION_TYPE" 2>/dev/null
  if [ $? -ne 0 ]; then
    osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
  fi
else
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\""
fi

echo "$WALLPAPER" > "$CACHE_FILE"

echo ""
echo -e "  ${C_GREEN}✓${C_RESET} $(basename "$WALLPAPER")"
echo ""
