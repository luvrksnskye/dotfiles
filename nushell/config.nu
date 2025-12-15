# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           NUSHELL CONFIG                                   ║
# ║                            Skye Edition                                    ║
# ╚════════════════════════════════════════════════════════════════════════════╝

$env.config = {
    show_banner: false
    edit_mode: vi
    
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "sqlite"
    }
    
    filesize: {
        metric: true
        format: "auto"
    }
    
    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }
    
    table: {
        mode: rounded
        index_mode: auto
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
        header_on_separator: false
    }
    
    error_style: "fancy"
}

# Aliases
alias cls = clear
alias ll = ls -l
alias la = ls -a
alias v = nvim
alias vi = nvim
alias vim = nvim

# Custom prompt
$env.PROMPT_COMMAND = {||
    let dir = ($env.PWD | path basename)
    $"(ansi magenta)($dir)(ansi reset) > "
}

$env.PROMPT_COMMAND_RIGHT = {||
    let time = (date now | format date "%H:%M")
    $"(ansi dark_gray)($time)(ansi reset)"
}

$env.PROMPT_INDICATOR = {|| "" }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
