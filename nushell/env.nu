# =============================================================================
# Nushell Environment Configuration
# Platform: macOS Intel
# =============================================================================

# -----------------------------------------------------------------------------
# XDG Base Directories
# -----------------------------------------------------------------------------
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local" "state")

# -----------------------------------------------------------------------------
# Editor Configuration
# -----------------------------------------------------------------------------
$env.EDITOR = "code"
$env.VISUAL = "code"
$env.PAGER = "less -RF"

# -----------------------------------------------------------------------------
# Locale
# -----------------------------------------------------------------------------
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# -----------------------------------------------------------------------------
# Homebrew (macOS Intel)
# -----------------------------------------------------------------------------
$env.HOMEBREW_PREFIX = "/usr/local"
$env.HOMEBREW_CELLAR = "/usr/local/Cellar"
$env.HOMEBREW_REPOSITORY = "/usr/local/Homebrew"
$env.HOMEBREW_NO_ANALYTICS = "1"

# -----------------------------------------------------------------------------
# Node.js
# -----------------------------------------------------------------------------
$env.NODE_ENV = "development"
$env.NPM_CONFIG_PREFIX = ($env.HOME | path join ".npm-global")

# -----------------------------------------------------------------------------
# Python
# -----------------------------------------------------------------------------
$env.PYTHONDONTWRITEBYTECODE = "1"
$env.PYTHONUNBUFFERED = "1"
$env.VIRTUAL_ENV_DISABLE_PROMPT = "1"

# -----------------------------------------------------------------------------
# Java (SDKMAN)
# -----------------------------------------------------------------------------
$env.SDKMAN_DIR = ($env.HOME | path join ".sdkman")

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------
$env.DOCKER_BUILDKIT = "1"
$env.COMPOSE_DOCKER_CLI_BUILD = "1"

# -----------------------------------------------------------------------------
# Go
# -----------------------------------------------------------------------------
$env.GOPATH = ($env.HOME | path join "go")
$env.GOBIN = ($env.HOME | path join "go" "bin")
$env.GO111MODULE = "on"

# -----------------------------------------------------------------------------
# Rust
# -----------------------------------------------------------------------------
$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.RUSTUP_HOME = ($env.HOME | path join ".rustup")

# -----------------------------------------------------------------------------
# Starship
# -----------------------------------------------------------------------------
$env.STARSHIP_CONFIG = ($env.XDG_CONFIG_HOME | path join "starship.toml")
$env.STARSHIP_CACHE = ($env.XDG_CACHE_HOME | path join "starship")

# -----------------------------------------------------------------------------
# FZF (Catppuccin Mocha colors)
# -----------------------------------------------------------------------------
$env.FZF_DEFAULT_OPTS = "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --border rounded --height 40%"

# -----------------------------------------------------------------------------
# PATH Construction
# -----------------------------------------------------------------------------
def create-path-list [] {
    let base_paths = [
        "/usr/local/bin"
        "/usr/local/sbin"
        "/usr/bin"
        "/usr/sbin"
        "/bin"
        "/sbin"
    ]
    
    let user_paths = [
        ($env.HOME | path join ".local" "bin")
        ($env.HOME | path join "bin")
    ]
    
    let dev_paths = [
        ($env.HOME | path join ".npm-global" "bin")
        ($env.HOME | path join ".cargo" "bin")
        ($env.HOME | path join "go" "bin")
        ($env.HOME | path join ".pyenv" "shims")
        ($env.HOME | path join ".pyenv" "bin")
        ($env.HOME | path join ".sdkman" "candidates" "java" "current" "bin")
        ($env.HOME | path join ".sdkman" "candidates" "maven" "current" "bin")
        ($env.HOME | path join ".sdkman" "candidates" "gradle" "current" "bin")
    ]
    
    $user_paths | append $dev_paths | append $base_paths | where { path exists }
}

$env.PATH = (create-path-list | uniq)

# -----------------------------------------------------------------------------
# Prompt Converters
# -----------------------------------------------------------------------------
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}
