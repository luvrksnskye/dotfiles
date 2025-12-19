# 🌙 Skye's Dreamy SketchyBar

> A beautiful, animated, and functional macOS menu bar replacement with Catppuccin Mocha theme.

![Catppuccin Mocha](https://img.shields.io/badge/theme-Catppuccin%20Mocha-cba6f7?style=for-the-badge)
![macOS](https://img.shields.io/badge/macOS-Compatible-green?style=for-the-badge)

## ✨ Features

- 🎵 **Universal Media Support** - Spotify, Apple Music, YouTube (from any browser), and more
- 🌙 **Moon Phase Workspaces** - Beautiful moon phase icons for each workspace
- 🎥 **Screen Recording Compatible** - Won't appear in OBS/screen recordings by default
- 💜 **Catppuccin Mocha Theme** - Dreamy, cozy colors
- ✨ **Smooth Animations** - Native macOS animations that feel natural
- 🚀 **Aerospace/Yabai Support** - Works with tiling window managers

## 📦 Installation

### Quick Install

```bash
chmod +x install.sh
./install.sh
```

### Manual Install

1. **Backup your existing config:**
   ```bash
   mv ~/.config/sketchybar ~/.config/sketchybar.backup
   ```

2. **Copy the new config:**
   ```bash
   cp -r . ~/.config/sketchybar
   ```

3. **Install dependencies:**
   ```bash
   # For YouTube support
   brew install nowplaying-cli
   
   # For Nerd Font icons
   brew tap homebrew/cask-fonts
   brew install --cask font-jetbrains-mono-nerd-font
   ```

4. **Restart SketchyBar:**
   ```bash
   brew services restart sketchybar
   ```

## 🎵 Music Widget

The music widget supports multiple sources:

| Source | Icon | How it Works |
|--------|------|--------------|
| Spotify | 󰓇 | Native events + nowplaying-cli |
| Apple Music | 󰎆 | Native events + nowplaying-cli |
| YouTube |  | Browser media via nowplaying-cli |
| Other Browser | 󰖟 | Any playing media via nowplaying-cli |

### Controls
- **Left Click**: Toggle popup with controls
- **Right Click**: Next track
- **Middle Click/Scroll**: Previous track
- **Double Click**: Open source app

## 🎥 Screen Recording

By default, the bar uses `topmost=window` which prevents it from appearing in screen recordings with most capture software (OBS, etc.).

If you **want** the bar to appear in recordings, change this in `sketchybarrc`:
```bash
topmost=on  # Bar will appear in recordings
```

## 🌙 Workspaces

The workspaces use moon phase icons that change based on which workspace you're on:

```
󰽤 󰽥 󰽦 󰽧 󰽨 󰽩 󰽪 󰽫 󰽬
1  2  3  4  5  6  7  8  9
```

## 🔧 Configuration

### Colors (`colors.sh`)

All colors follow the Catppuccin Mocha palette. Key colors:

```bash
$MAUVE      # Primary accent (purple)
$PINK       # Secondary accent
$GREEN      # Success/Spotify
$RED        # Error/YouTube
$SKY        # Info/Browser
```

### Icons (`icons.sh`)

All icons use JetBrainsMono Nerd Font. Common icons:

```bash
$ICON_SPOTIFY="󰓇"
$ICON_YOUTUBE=""
$ICON_APPLE_MUSIC="󰎆"
```

## 🛠 Native Animation Helper (Optional)

For even smoother animations, you can compile the native helper:

```bash
cd helpers
make
make install
```

This provides:
- 120fps color transitions
- Spring/bounce animations
- Custom "dreamy" animation curve

## 📁 File Structure

```
~/.config/sketchybar/
├── sketchybarrc           # Main configuration
├── colors.sh              # Color definitions
├── icons.sh               # Icon definitions
├── plugins/
│   ├── music.sh           # Music detection
│   ├── music_click.sh     # Music controls
│   ├── aerospace.sh       # Workspace handling
│   ├── battery.sh
│   ├── bluetooth.sh
│   ├── clock.sh
│   ├── volume.sh
│   ├── weather.sh
│   └── wifi.sh
└── helpers/
    ├── SkyeAnimator.m     # Native Obj-C helper
    ├── SkyeAnimator.swift # Swift alternative
    └── Makefile
```

## 🐛 Troubleshooting

### YouTube not showing?
Make sure `nowplaying-cli` is installed:
```bash
brew install nowplaying-cli
```

### Icons not displaying?
Install the Nerd Font:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Bar appearing in recordings?
Change `topmost=window` to `topmost=off` in `sketchybarrc`

### Music not updating?
Try triggering a manual update:
```bash
sketchybar --trigger media_change
```

## 💜 Credits

- Theme: [Catppuccin Mocha](https://github.com/catppuccin)
- Bar: [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- Icons: [Nerd Fonts](https://www.nerdfonts.com/)

---

Made with 💜 for Skye ✨
