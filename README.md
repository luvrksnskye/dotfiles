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

## Overview

This configuration provides a keyboard-driven workflow for macOS with tiling window management, a custom status bar, and a suite of utility scripts for wallpaper management and system control.

### Components

| Component | Description |
|-----------|-------------|
| Aerospace | Tiling window manager with vim-style navigation |
| SketchyBar | Custom status bar with workspace indicators, music player, weather |
| JankyBorders | Active window highlighting with rounded borders |
| luvrksnskye | Custom utility scripts for wallpaper and system management |
| Ghostty | Terminal emulator configuration |
| Neofetch | System information display |
| Cava | Audio visualizer |
| Starship | Cross-shell prompt |
| Powerlevel10k | ZSH theme |
| Nushell | Modern shell configuration |

---

## Installation

### Prerequisites

Install the required dependencies via Homebrew:

```bash
# Required
brew install --cask nikitabobko/tap/aerospace
brew install sketchybar
brew tap FelixKratz/formulae && brew install borders
brew install --cask font-jetbrains-mono-nerd-font

# Recommended
brew install fzf neofetch cava chafa nowplaying-cli
```

### Quick Install

```bash
git clone https://github.com/luvrksnskye//dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

### Post-Installation

1. Add the following line to your ~/.zshrc (if not already there):

```bash
source ~/.config/skye.zsh
```

2. Reload your shell:

```bash
source ~/.zshrc
```

3. Start the services:

```bash
aerospace reload-config
brew services restart sketchybar
brew services restart borders
```

---

## Keybindings

### Main Mode

#### Navigation

| Keybinding | Action |
|------------|--------|
| Alt + H/J/K/L | Focus window (vim-style) |
| Alt + Arrows | Focus window (arrow keys) |
| Alt + 1-4 | Switch to workspace |
| Alt + Tab | Toggle between last two workspaces |

#### Window Management

| Keybinding | Action |
|------------|--------|
| Alt + Shift + H/J/K/L | Move window (vim-style) |
| Alt + Shift + Arrows | Move window (arrow keys) |
| Alt + Shift + 1-4 | Send window to workspace |
| Alt + Shift + Tab | Move workspace to next monitor |

#### Layout

| Keybinding | Action |
|------------|--------|
| Alt + / | Toggle horizontal/vertical split |
| Alt + , | Toggle accordion layout |
| Alt + Ctrl + F | Toggle floating/tiling |
| Alt + Ctrl + Shift + F | Toggle fullscreen |

#### Window Joining

| Keybinding | Action |
|------------|--------|
| Alt + Ctrl + H/J/K/L | Join window in direction |

#### Resize

| Keybinding | Action |
|------------|--------|
| Alt + Shift + = | Grow window |
| Alt + Shift + - | Shrink window |

### Navigation Mode

Enter with Alt + Enter, exit with Esc or Enter.

| Keybinding | Action |
|------------|--------|
| Arrows or H/J/K/L | Focus windows |
| Shift + Arrows or Shift + H/J/K/L | Move windows |
| 1-4 | Go to workspace and exit |
| F | Toggle float/tile and exit |
| M | Toggle fullscreen and exit |
| Q | Close window and exit |

### App Launching

Direct shortcuts, no mode needed. Press multiple times to open multiple instances.

| Keybinding | Application |
|------------|-------------|
| Alt + Shift + T | Terminal (Ghostty) |
| Alt + Shift + B | Brave Browser |
| Alt + Shift + Z | Zen Browser |
| Alt + Shift + F | Finder |
| Alt + Shift + O | Obsidian |
| Alt + Shift + D | Discord |
| Alt + Shift + C | Claude |
| Alt + Shift + V | VS Code |
| Alt + Shift + M | Spotify |
| Alt + Shift + N | Notes |
| Alt + Shift + P | Preview |

### Service Mode

Enter with Alt + Shift + S, exit with Esc (also reloads config).

| Keybinding | Action |
|------------|--------|
| R | Reset/flatten workspace layout |
| F | Toggle float/tile |
| Backspace | Close all windows except current |

---

## Commands

The luvrksnskye utility provides several commands accessible via the luvr alias:

| Command | Alias | Description |
|---------|-------|-------------|
| luvr wall | wall | Interactive wallpaper selector with preview |
| luvr wall-random | wallr | Set a random wallpaper |
| luvr wall-set path | - | Set a specific wallpaper |
| luvr keys | keys | Show keybinding reference |
| luvr reload | - | Reload all configurations |
| luvr help | - | Show command reference |

---

## Shell Aliases

```bash
# System
cls          # Clear terminal
reload       # Reload zsh configuration
..           # cd ..
...          # cd ../..

# Editor
v / vi / vim # Open Neovim
v.           # Open Neovim in current directory

# Tools
nf           # Run neofetch
cv           # Run cava
f            # Open Finder in current directory

# Apps
brave        # Open Brave Browser
zen          # Open Zen Browser
g            # Open Ghostty

# Config
ar           # Reload Aerospace config
sbr          # Restart SketchyBar service
```

---

## Troubleshooting

### Commands not working (luvr, wall, keys, etc.)

Make sure the PATH includes luvrksnskye:

```bash
# Check if skye.zsh is sourced
grep "skye.zsh" ~/.zshrc

# If not, add it
echo 'source ~/.config/skye.zsh' >> ~/.zshrc
source ~/.zshrc
```

### Aerospace not responding

```bash
aerospace reload-config
```

### SketchyBar not visible

```bash
brew services restart sketchybar
```

### Borders not showing

```bash
brew services restart borders
```

### Wallpaper selector not showing previews

Install chafa for terminal image previews:

```bash
brew install chafa
```

## Acknowledgments

- Aerospace by Nikita Bobko
- SketchyBar by Felix Kratz
- JankyBorders by Felix Kratz
- Catppuccin color palette inspiration
