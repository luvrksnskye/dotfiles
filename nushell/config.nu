$env.config = { show_banner: false }
alias cls = clear
# Initialize Starship
starship init nu | save -p -r ~/.cache/starship/init.nu; source ~/.cache/starship/init.nu