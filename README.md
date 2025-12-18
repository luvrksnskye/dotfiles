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

## Installation

This repository contains two installation methods. Follow the one for your operating system.

### macOS Installation (Full Desktop Experience)

This will install the complete macOS desktop environment, including window manager, status bar, and shell configurations.

#### 1. Prerequisites

Install [Homebrew](https://brew.sh/). The script will handle the rest of the dependencies. You may need to partially disable SIP for some of Yabai's features like animations.

#### 2. Run the Installer

Clone the repository and run the `install.sh` script. It will automatically install required fonts and applications via Homebrew, then back up any existing dotfiles and copy the new ones into place.

```bash
git clone https://github.com/luvrksnskye/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

#### 3. Post-Install

```bash
# Add to ~/.zshrc if you use Zsh
source ~/.config/skye.zsh

# Start services
yabai --start-service
skhd --start-service
brew services start sketchybar
brew services start borders
```

### Windows Installation (Nushell, Starship, etc)

This method installs a complete shell environment (Nushell, Starship) for a consistent experience on Windows 10/11 that I made for my bf!

#### 1. Run the Installer

Clone the repository. Then, right-click the `install.ps1` script and select "Run with PowerShell".

The script will ask for Administrator privileges to automatically install all required dependencies using `winget`, including:
- A Nerd Font (via the OhMyPosh package)
- Nushell
- Starship

It will then install the configurations for you.

```powershell
git clone https://github.com/luvrksnskye/dotfiles.git
cd dotfiles
./install.ps1
```

#### 2. Post-Install

After the script finishes, you just need to configure your terminal (like Windows Terminal or Fluent Terminal) to use your new Nerd Font (e.g., `JetBrainsMono NF`) and set Nushell as your default shell.

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
