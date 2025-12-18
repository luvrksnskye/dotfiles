# Skye's Dotfiles

Haiii this is my macOS desktop setup with Yabai as the window manager, SketchyBar, and a few custom utilities lol. I used to be a Linux user, and after switching to macOS, I just tried to make the most of it with some simple tweaks to keep it comfy.

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

---

## Quick Reference

### Super Short Commands

These are the fastest way to access everything. Add `source ~/.config/skye.zsh` to your `.zshrc` to enable them.

| Command | Description |
|---------|-------------|
| `luvr` | Open interactive menu |
| `w` | Wallpaper selector |
| `wr` | Random wallpaper |
| `p` | Pomodoro timer |
| `t` | Todo list |
| `m` | Mood tracker |
| `me` | Who am I card |
| `k` | Keybindings |
| `hi` | Greeting |
| `r` | Reload services |

### All Commands

| Command | Description |
|---------|-------------|
| `luvr` | Open interactive menu |
| `luvr wall` | Interactive wallpaper selector |
| `luvr random` | Set random wallpaper |
| `luvr list` | List available wallpapers |
| `luvr set <image> [effect]` | Set wallpaper with effect |
| `luvr pomo` | Start pomodoro timer |
| `luvr todo` | Open todo list |
| `luvr mood` | Open mood tracker |
| `luvr me` | Show user info card |
| `luvr keys` | Animated keybinding reference |
| `luvr greet` | Animated greeting |
| `luvr reload` | Reload all services |

### Todo Quick Commands

```bash
ta "buy groceries"  # add task
tl                  # list tasks
td 1                # complete task #1
```

---

**Quick effect shortcuts:**
```bash
wf image.jpg   # fade
ww image.jpg   # wave
wg image.jpg   # grow
wl image.jpg   # liquid
wsp image.jpg  # spiral
wfo image.jpg  # fold
wsl image.jpg left  # slide
wb image.jpg   # bloom
wgl image.jpg  # glitch
```

### Pomodoro Timer

Focus timer with visual progress bar and notifications.

- 25 minute focus sessions
- 5 minute short breaks
- 15 minute long breaks (after 4 sessions)
- Sound notifications
- Session statistics

**Commands:**
```bash
p          # open pomodoro menu
luvr pomo  # same
luvr pomo 30  # custom 30 min timer
```

### Todo List

Cute task manager with priorities.

- High/Medium/Low priority levels
- Completion history
- Quick add/complete/delete

**Commands:**
```bash
t           # open todo menu
ta "task"   # quick add
tl          # quick list
td 1        # complete task #1
```

### Mood Tracker

Track how you're feeling with statistics.

- 5 mood levels (Amazing to Bad)
- Optional notes
- History view
- Statistics with averages

**Commands:**
```bash
m          # open mood tracker
luvr mood  # same
```

---

## Keybindings

For a full and animated keybinding reference, run `luvr keys` or just `k` in your terminal.

### Window Focus
| Key | Action |
|-----|--------|
| Alt + H/J/K/L | Focus (vim) |
| Alt + Arrows | Focus (arrows) |
| Alt + Tab | Recent space |
| Alt + P/N | Prev/Next space |

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
| Alt + 0 | Balance windows |

### Layout
| Key | Action |
|-----|--------|
| Alt + F | Float/tile |
| Alt + Shift + F | Fullscreen |
| Alt + / | Toggle split |
| Alt + R | Rotate 90 |

### Resize
| Key | Action |
|-----|--------|
| Ctrl + Alt + Arrows | Resize window |
| Alt + Shift + +/- | Grow/Shrink |
| fn + drag | Free resize |

### Apps
| Key | App |
|-----|-----|
| Alt + Shift + T | Terminal |
| Alt + Shift + B | Brave |
| Alt + Shift + Z | Zen Browser |
| Alt + Shift + E | Finder |
| Alt + Shift + D | Discord |
| Alt + Shift + C | Claude |
| Alt + Shift + V | VS Code |
| Alt + Shift + M | Spotify |
| Alt + Shift + A | Apple Music |
| Alt + Shift + O | Obsidian |

### Services
| Key | Action |
|-----|--------|
| Ctrl + Alt + R | Restart Yabai |
| Ctrl + Alt + S | Reload skhd |
| Ctrl + Alt + G | Greeting |

### Mouse (hold fn)
| Action | Effect |
|--------|--------|
| fn + Left Click | Move window |
| fn + Right Click | Resize window |

---

## Dependencies

**Required:**
- zsh
- fzf
- Nerd Fonts (JetBrains Mono recommended)

**Optional:**
- chafa (for image preview in wallpaper selector)

**Installed by script:**
- yabai
- skhd
- sketchybar
- borders
- starship
- bat, eza, ripgrep, fd, neofetch, tmux, lazygit

---

## File Structure

```
~/.config/
├── luvrksnskye/           # Main toolkit
│   ├── luvrksnskye        # Main script
│   ├── skye.zsh           # Zsh config with aliases
│   ├── greeting.sh
│   ├── whoiam.sh
│   ├── key_hints.sh
│   ├── reload.sh
│   ├── pomodoro.sh
│   ├── todo.sh
│   ├── mood.sh
│   └── wallpapers/
│       ├── wallpaper_select.sh
│       ├── wallpaper_set.sh
│       ├── wallpaper_list.sh
│       ├── wallpaper_random.sh
│       ├── wallpaper_animate.m
│       ├── wallpaper_animate    # compiled binary
│       └── Makefile
├── yabai/
├── skhd/
├── sketchybar/
├── borders/
├── ghostty/
└── starship/
```

---

## Music

SketchyBar supports both Spotify and Apple Music. Click the music widget to play/pause, right-click for next track.

---

## Troubleshooting

### Wallpaper animations not working
Make sure SIP is partially disabled and the animator is compiled:
```bash
cd ~/.config/luvrksnskye/wallpapers
make clean && make
```

### Image preview not showing
Install chafa:
```bash
brew install chafa
```

### Icons not displaying correctly
Install a Nerd Font:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

---

*made with love and insomnia*
