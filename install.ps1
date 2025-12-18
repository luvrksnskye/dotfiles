# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                         SKYE'S DOTFILES INSTALLER                          ║
# ║                            Windows Edition                                 ║
# ╚════════════════════════════════════════════════════════════════════════════╝

#Requires -Version 5.1

$ErrorActionPreference = "Stop"

# ────────────────────────────────────────────────────────────────────────────────
# Catppuccin Mocha Colors (ANSI Escape Sequences)
# ────────────────────────────────────────────────────────────────────────────────
$ESC = [char]27
$C_RESET = "$ESC[0m"
$C_PINK = "$ESC[38;2;245;194;231m"
$C_MAUVE = "$ESC[38;2;203;166;247m"
$C_RED = "$ESC[38;2;243;139;168m"
$C_PEACH = "$ESC[38;2;250;179;135m"
$C_YELLOW = "$ESC[38;2;249;226;175m"
$C_GREEN = "$ESC[38;2;166;227;161m"
$C_TEAL = "$ESC[38;2;148;226;213m"
$C_BLUE = "$ESC[38;2;137;180;250m"
$C_LAVENDER = "$ESC[38;2;180;190;254m"
$C_TEXT = "$ESC[38;2;205;214;244m"
$C_DIM = "$ESC[38;2;108;112;134m"

# ────────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ────────────────────────────────────────────────────────────────────────────────

function Write-Header {
    Clear-Host
    Write-Host "${C_LAVENDER}"
    Write-Host "    ╔════════════════════════════════════════════════════════════════════╗"
    Write-Host "    ║                                                                    ║"
    Write-Host "    ║   ███████╗██╗  ██╗██╗   ██╗███████╗                                ║"
    Write-Host "    ║   ██╔════╝██║ ██╔╝╚██╗ ██╔╝██╔════╝                                ║"
    Write-Host "    ║   ███████╗█████╔╝  ╚████╔╝ █████╗                                  ║"
    Write-Host "    ║   ╚════██║██╔═██╗   ╚██╔╝  ██╔══╝                                  ║"
    Write-Host "    ║   ███████║██║  ██╗   ██║   ███████╗                                ║"
    Write-Host "    ║   ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝                                ║"
    Write-Host "    ║                                                                    ║"
    Write-Host "    ║              ${C_PINK}Dotfiles Installer${C_LAVENDER}                              ║"
    Write-Host "    ║               ${C_TEAL}Windows Edition${C_LAVENDER}                                ║"
    Write-Host "    ║                                                                    ║"
    Write-Host "    ╚════════════════════════════════════════════════════════════════════╝"
    Write-Host "${C_RESET}"
    Write-Host ""
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "  ${C_PINK}$Title${C_RESET}"
    Write-Host "  ${C_DIM}────────────────────────────────────────${C_RESET}"
}

function Write-Status {
    param(
        [string]$Name,
        [string]$Status,
        [string]$Color = $C_GREEN
    )
    $padding = 28 - $Name.Length
    if ($padding -lt 1) { $padding = 1 }
    $spaces = " " * $padding
    Write-Host "  ${C_DIM}$Name${C_RESET}$spaces$Color$Status${C_RESET}"
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Test-WingetPackageInstalled {
    param([string]$PackageId)
    $result = winget list --id $PackageId 2>$null
    return $result -match $PackageId
}

function Install-WingetPackage {
    param(
        [string]$Name,
        [string]$PackageId
    )
    Write-Host "  ${C_DIM}Installing $Name...${C_RESET}" -NoNewline
    try {
        winget install --id $PackageId --accept-source-agreements --accept-package-agreements --silent 2>$null | Out-Null
        $padding = 28 - $Name.Length
        if ($padding -lt 1) { $padding = 1 }
        $spaces = " " * $padding
        Write-Host "`r  ${C_DIM}$Name${C_RESET}$spaces${C_GREEN}installed${C_RESET}"
    }
    catch {
        Write-Host "`r  ${C_DIM}$Name${C_RESET}$spaces${C_RED}failed${C_RESET}"
    }
}

function Backup-Item {
    param([string]$Path)
    if (Test-Path $Path) {
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $backupPath = "$Path.backup.$timestamp"
        Move-Item -Path $Path -Destination $backupPath -Force
    }
}

function Install-Config {
    param(
        [string]$Name,
        [string]$Source,
        [string]$Destination
    )
    $padding = 28 - $Name.Length
    if ($padding -lt 1) { $padding = 1 }
    $spaces = " " * $padding
    
    if (Test-Path $Source) {
        Backup-Item -Path $Destination
        Copy-Item -Path $Source -Destination $Destination -Recurse -Force
        Write-Host "  ${C_DIM}$Name${C_RESET}$spaces${C_GREEN}done${C_RESET}"
    }
    else {
        Write-Host "  ${C_DIM}$Name${C_RESET}$spaces${C_RED}not found${C_RESET}"
    }
}

# ────────────────────────────────────────────────────────────────────────────────
# Main Installation
# ────────────────────────────────────────────────────────────────────────────────

Write-Header

# Check for Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Section "Checking Permissions"
if ($isAdmin) {
    Write-Status -Name "Administrator" -Status "yes" -Color $C_GREEN
}
else {
    Write-Status -Name "Administrator" -Status "no (some features may fail)" -Color $C_YELLOW
}

# Check for winget
Write-Section "Checking Package Manager"
if (Test-CommandExists "winget") {
    Write-Status -Name "winget" -Status "found" -Color $C_GREEN
}
else {
    Write-Status -Name "winget" -Status "not found!" -Color $C_RED
    Write-Host ""
    Write-Host "  ${C_RED}winget is required. Please install App Installer from Microsoft Store.${C_RESET}"
    Write-Host ""
    exit 1
}

# Install Dependencies
Write-Section "Installing Dependencies"

# Nerd Font (via Oh My Posh which includes fonts)
if (-not (Test-WingetPackageInstalled "JanDeDobbeleer.OhMyPosh")) {
    Install-WingetPackage -Name "Oh My Posh (Nerd Fonts)" -PackageId "JanDeDobbeleer.OhMyPosh"
    # Install JetBrains Mono Nerd Font
    Write-Host "  ${C_DIM}Installing JetBrains Mono NF...${C_RESET}" -NoNewline
    oh-my-posh font install JetBrainsMono 2>$null | Out-Null
    Write-Host "`r  ${C_DIM}JetBrains Mono NF${C_RESET}          ${C_GREEN}installed${C_RESET}"
}
else {
    Write-Status -Name "Oh My Posh (Nerd Fonts)" -Status "installed" -Color $C_GREEN
}

# Nushell
if (-not (Test-CommandExists "nu")) {
    Install-WingetPackage -Name "Nushell" -PackageId "Nushell.Nushell"
}
else {
    Write-Status -Name "Nushell" -Status "installed" -Color $C_GREEN
}

# Starship
if (-not (Test-CommandExists "starship")) {
    Install-WingetPackage -Name "Starship" -PackageId "Starship.Starship"
}
else {
    Write-Status -Name "Starship" -Status "installed" -Color $C_GREEN
}

# Optional tools
Write-Section "Optional Tools"
$optionalTools = @(
    @{Name = "Git"; Id = "Git.Git"; Cmd = "git"},
    @{Name = "fzf"; Id = "junegunn.fzf"; Cmd = "fzf"},
    @{Name = "bat"; Id = "sharkdp.bat"; Cmd = "bat"},
    @{Name = "ripgrep"; Id = "BurntSushi.ripgrep.MSVC"; Cmd = "rg"},
    @{Name = "fd"; Id = "sharkdp.fd"; Cmd = "fd"},
    @{Name = "lazygit"; Id = "JesseDuffield.lazygit"; Cmd = "lazygit"}
)

foreach ($tool in $optionalTools) {
    if (-not (Test-CommandExists $tool.Cmd)) {
        Install-WingetPackage -Name $tool.Name -PackageId $tool.Id
    }
    else {
        Write-Status -Name $tool.Name -Status "installed" -Color $C_GREEN
    }
}

# Create directories
Write-Section "Creating Directories"
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$NushellConfigDir = "$env:APPDATA\nushell"
$StarshipConfigDir = "$env:USERPROFILE\.config"
$StarshipCacheDir = "$env:USERPROFILE\.cache\starship"

$directories = @(
    $NushellConfigDir,
    $StarshipConfigDir,
    $StarshipCacheDir
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}
Write-Status -Name "All directories" -Status "ready" -Color $C_GREEN

# Install configurations
Write-Section "Installing Configurations"

# Nushell config
Install-Config -Name "Nushell config.nu" -Source "$ScriptPath\nushell\config.nu" -Destination "$NushellConfigDir\config.nu"
Install-Config -Name "Nushell env.nu" -Source "$ScriptPath\nushell\env.nu" -Destination "$NushellConfigDir\env.nu"

# Starship config
Install-Config -Name "Starship" -Source "$ScriptPath\starship\starship.toml" -Destination "$StarshipConfigDir\starship.toml"

# Initialize shell tools
Write-Section "Initializing Shell Tools"

# Starship init for Nushell
if (Test-CommandExists "starship") {
    $starshipInit = & starship init nu 2>$null
    if ($starshipInit) {
        $starshipInit | Out-File -FilePath "$StarshipCacheDir\init.nu" -Encoding utf8 -Force
        Write-Status -Name "Starship for Nushell" -Status "done" -Color $C_GREEN
    }
}

# Refresh PATH
Write-Section "Refreshing Environment"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Status -Name "PATH" -Status "refreshed" -Color $C_GREEN

# Complete
Write-Host ""
Write-Host "${C_LAVENDER}"
Write-Host "    ╔════════════════════════════════════════════════════════════════════╗"
Write-Host "    ║                                                                    ║"
Write-Host "    ║                    Installation Complete!                          ║"
Write-Host "    ║                                                                    ║"
Write-Host "    ╚════════════════════════════════════════════════════════════════════╝"
Write-Host "${C_RESET}"

Write-Section "Post-Installation Steps"
Write-Host ""
Write-Host "  ${C_TEAL}1.${C_RESET} ${C_TEXT}Configure Windows Terminal:${C_RESET}"
Write-Host "     ${C_DIM}Settings > Profiles > Defaults > Font face > JetBrainsMono NF${C_RESET}"
Write-Host ""
Write-Host "  ${C_TEAL}2.${C_RESET} ${C_TEXT}Set Nushell as default shell in Windows Terminal:${C_RESET}"
Write-Host "     ${C_DIM}Settings > Startup > Default profile > Nushell${C_RESET}"
Write-Host ""
Write-Host "  ${C_TEAL}3.${C_RESET} ${C_TEXT}Or add Nushell profile manually:${C_RESET}"
Write-Host "     ${C_DIM}Command line: nu.exe${C_RESET}"
Write-Host ""
Write-Host "  ${C_TEAL}4.${C_RESET} ${C_TEXT}Start Nushell:${C_RESET}"
Write-Host "     ${C_DIM}nu${C_RESET}"
Write-Host ""

Write-Section "Config Locations"
Write-Host "  ${C_MAUVE}Nushell${C_RESET}    ${C_DIM}$NushellConfigDir${C_RESET}"
Write-Host "  ${C_MAUVE}Starship${C_RESET}   ${C_DIM}$StarshipConfigDir\starship.toml${C_RESET}"
Write-Host ""

Write-Host "  ${C_PINK}Enjoy your new shell!${C_RESET}"
Write-Host ""

# Pause at end
Write-Host "  ${C_DIM}Press any key to exit...${C_RESET}"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
