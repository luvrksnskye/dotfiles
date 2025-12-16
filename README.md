# Skye's Dotfiles

Haiii this is my macOS desktop setup with Aerospace as the window manager, SketchyBar, and a few custom utilities lol. I used to be a Linux user, and after switching to macOS, I just tried to make the most of it with some simple tweaks to keep it comfy.

```
    ███████╗██╗  ██╗██╗   ██╗███████╗
    ██╔════╝██║ ██╔╝╚██╗ ██╔╝██╔════╝
    ███████╗█████╔╝  ╚████╔╝ █████╗
    ╚════██║██╔═██╗   ╚██╔╝  ██╔══╝
    ███████║██║  ██╗   ██║   ███████╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝
```

---

## Features

- Yabai tiling window manager with fluid animations (configured via built-in `asmvik` fork features)
- skhd for keyboard shortcuts
- SketchyBar with Spotify + Apple Music support
- Animated wallpaper transitions (now with "slide" effect, "liquid" is default)
- Enhanced terminal interfaces for custom scripts
- Catppuccin Mocha theme

---

## Installation

### Prerequisites

Partially disable SIP for full Yabai features (animations, opacity, etc.).

```bash
# Required
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew install sketchybar
brew tap FelixKratz/formulae && brew install borders
brew install --cask font-jetbrains-mono-nerd-font

# Recommended
brew install fzf jq nowplaying-cli chafa neofetch cava
```

### Install

```bash
git clone https://github.com/luvrksnskye/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

### Post-Install

```bash
# Add to ~/.zshrc
source ~/.config/skye.zsh

# Start services
yabai --start-service
skhd --start-service
brew services start sketchybar
brew services start borders
```

---

## Keybindings

For a full and animated keybinding reference, run `luvr keys` in your terminal.

### Window Focus
| Key | Action |
|-----|--------|
| Alt + H/J/K/L | Focus (vim) |
| Alt + Arrows | Focus (arrows) |

### Window Move
| Key | Action |
|-----|--------|
| Alt + Shift + H/J/K/L | Swap window |
| Ctrl + Alt + H/J/K/L | Warp/insert |

### Workspaces
| Key | Action |
|-----|--------|
| Alt + 1-4 | Focus space |
| Alt + Shift + 1-4 | Send to space |

### Layout
| Key | Action |
|-----|--------|
| Alt + F | Float/tile |
| Alt + Shift + F | Fullscreen |
| Alt + / | Toggle split |
| Alt + R | Rotate 90 |
| Alt + 0 | Balance |

### Apps
| Key | App |
|-----|-----|
| Alt + Shift + T | Terminal |
| Alt + Shift + B | Brave |
| Alt + Shift + M | Spotify |
| Alt + Shift + C | Claude |

---

## Commands

| Command | Description |
|---------|-------------|
| luvr | Show help |
| luvr greet | Animated greeting |
| luvr whoami | Show user info card |
| luvr keys | Animated keybinding reference |
| luvr wall | Interactive wallpaper selector |
| luvr wall-random | Set random wallpaper |
| luvr wall-list | List wallpapers |
| luvr wall-set <path> [fx] | Set wallpaper with animation (fx: wave, fade, grow, liquid, spiral, fold, slide) |
| reload | Reload all configurations and services |

---

## Music

SketchyBar supports both Spotify and Apple Music. Click the music widget to play/pause, right-click for next track.

---
