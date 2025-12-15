# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                          NUSHELL ENVIRONMENT                               ║
# ║                            Skye Edition                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

# Path
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    $"($env.HOME)/.config/luvrksnskye"
    $"($env.HOME)/.local/bin"
    "/opt/homebrew/bin"
])

# Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# XDG
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"
