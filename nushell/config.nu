# Nushell Config File - Catppuccin Mocha Theme
let catppuccin_mocha = {
    separator: "#585b70"
    leading_trailing_space_bg: { attr: n }
    header: { fg: "#89b4fa" attr: b }
    empty: "#6c7086"
    bool: { if $in { '#94e2d5' } else { '#6c7086' } }
    int: "#fab387"
    filesize: {|e|
      if $e == 0b {
        '#6c7086'
      } else if $e < 1mb {
        '#94e2d5'
      } else { '#89b4fa' }
    }
    duration: "#f9e2af"
    date: { (date now) - $in |
      if $in < 1hr {
        '#f38ba8'
      } else if $in < 6hr {
        '#fab387'
      } else if $in < 1day {
        '#f9e2af'
      } else if $in < 3day {
        '#a6e3a1'
      } else if $in < 1wk {
        '#94e2d5'
      } else if $in < 6wk {
        '#89dceb'
      } else if $in < 52wk {
        '#89b4fa'
      } else { '#6c7086' }
    }
    range: "#f9e2af"
    float: "#fab387"
    string: "#a6e3a1"
    nothing: "#6c7086"
    binary: "#cba6f7"
    cellpath: "#89b4fa"
    row_index: { fg: "#7f849c" attr: b }
    record: "#89b4fa"
    list: "#89b4fa"
    block: "#74c7ec"
    hints: "#6c7086"

    shape_and: { fg: "#cba6f7" attr: b }
    shape_binary: { fg: "#cba6f7" attr: b }
    shape_block: { fg: "#89b4fa" attr: b }
    shape_bool: "#94e2d5"
    shape_custom: "#a6e3a1"
    shape_datetime: { fg: "#94e2d5" attr: b }
    shape_directory: "#94e2d5"
    shape_external: "#94e2d5"
    shape_externalarg: { fg: "#a6e3a1" attr: b }
    shape_filepath: "#94e2d5"
    shape_flag: { fg: "#89b4fa" attr: b }
    shape_float: { fg: "#cba6f7" attr: b }
    shape_garbage: { fg: "#cdd6f4" bg: "#f38ba8" attr: b }
    shape_globpattern: { fg: "#94e2d5" attr: b }
    shape_int: { fg: "#cba6f7" attr: b }
    shape_internalcall: { fg: "#94e2d5" attr: b }
    shape_list: { fg: "#94e2d5" attr: b }
    shape_literal: "#89b4fa"
    shape_matching_brackets: { attr: u }
    shape_nothing: "#94e2d5"
    shape_operator: "#f9e2af"
    shape_or: { fg: "#cba6f7" attr: b }
    shape_pipe: { fg: "#cba6f7" attr: b }
    shape_range: { fg: "#f9e2af" attr: b }
    shape_record: { fg: "#94e2d5" attr: b }
    shape_redirection: { fg: "#cba6f7" attr: b }
    shape_signature: { fg: "#a6e3a1" attr: b }
    shape_string: "#a6e3a1"
    shape_string_interpolation: { fg: "#94e2d5" attr: b }
    shape_table: { fg: "#89b4fa" attr: b }
    shape_variable: "#f5c2e7"
}

$env.config = {
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: false
  }
  table: {
    mode: rounded
    index_mode: always
    trim: {
      methodology: wrapping
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }

  explore: {
    help_banner: true
    exit_esc: true
    command_bar_text: '#cdd6f4'
    status_bar_background: { fg: '#1e1e2e' bg: '#cdd6f4' }
    highlight: { bg: '#f9e2af' fg: '#1e1e2e' }
    status: {}
    try: {}
    table: {
      split_line: '#45475a'
      cursor: true
      line_index: true
      line_shift: true
      line_head_top: true
      line_head_bottom: true
      show_head: true
      show_index: true
    }
    config: {
      cursor_color: { bg: '#f9e2af' fg: '#1e1e2e' }
    }
  }

  history: {
    max_size: 100000
    sync_on_enter: true
    file_format: "sqlite"
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  color_config: $catppuccin_mocha
  float_precision: 2
  buffer_editor: "code"
  use_ansi_coloring: true
  edit_mode: emacs
  shell_integration: {
    osc2: true
    osc7: true
    osc8: true
    osc9_9: false
    osc133: true
    osc633: true
    reset_application_mode: true
  }
  show_banner: false
  render_right_prompt_on_last_line: false

  hooks: {
    pre_prompt: [{ null }]
    pre_execution: [{ null }]
    env_change: {
      PWD: [{|before, after| null }]
    }
    display_output: {
      if (term size).columns >= 100 { table -e } else { table }
    }
  }

  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: "#a6e3a1"
        selected_text: { fg: "#1e1e2e" bg: "#a6e3a1" }
        description_text: "#f9e2af"
      }
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: "#a6e3a1"
        selected_text: { fg: "#1e1e2e" bg: "#a6e3a1" }
        description_text: "#f9e2af"
      }
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: description
        columns: 4
        col_width: 20
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: {
        text: "#a6e3a1"
        selected_text: { fg: "#1e1e2e" bg: "#a6e3a1" }
        description_text: "#f9e2af"
      }
    }
  ]

  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
      }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          { edit: pastecutbufferafter }
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { edit: cutfromlinestart }
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          { edit: cuttolineend }
        ]
      }
    }
  ]
}

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# Navigation
alias c = clear
alias l = ls --all
alias ll = ls -l
alias la = ls -la

# Git
alias g = git
alias gs = git status
alias ga = git add
alias gaa = git add -A
alias gap = git add -p
alias gc = git commit -m
alias gca = git commit -a -m
alias gp = git push origin HEAD
alias gpu = git pull origin
alias gf = git fetch --all --prune
alias gb = git branch
alias gba = git branch -a
alias gco = git checkout
alias gd = git diff
alias gdiff = git diff
alias glog = git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit
alias gl = git log --oneline --graph -20
alias grb = git rebase
alias gst = git stash
alias gstp = git stash pop
alias gr = git remote
alias gre = git reset
alias gcoall = git checkout -- .

# Docker
alias d = docker
alias dc = docker compose
alias dcu = docker compose up -d
alias dcd = docker compose down
alias dcl = docker compose logs -f
alias di = docker images
alias dex = docker exec -it
alias dlogs = docker logs -f
alias dprune = docker system prune -af

# Kubernetes
alias k = kubectl
alias ka = kubectl apply -f
alias kg = kubectl get
alias kd = kubectl describe
alias kdel = kubectl delete
alias kl = kubectl logs -f
alias kgp = kubectl get pods
alias kgpo = kubectl get pod
alias kgd = kubectl get deployments
alias ke = kubectl exec -it
alias kns = kubens

# Node.js
alias ni = npm install
alias nid = npm install --save-dev
alias nr = npm run
alias nrs = npm run start
alias nrd = npm run dev
alias nrb = npm run build
alias nrt = npm run test
alias pn = pnpm
alias pni = pnpm install
alias pnr = pnpm run
alias y = yarn
alias yi = yarn install
alias ya = yarn add
alias yr = yarn run

# Python
alias py = python3
alias pip = pip3
alias pipi = pip install
alias pipr = pip install -r requirements.txt
alias dj = python manage.py
alias djr = python manage.py runserver
alias djm = python manage.py migrate
alias pt = pytest

# Java
alias mvnc = mvn clean
alias mvni = mvn install
alias mvnci = mvn clean install
alias mvns = mvn spring-boot:run
alias gw = ./gradlew
alias gwb = ./gradlew build
alias gwr = ./gradlew bootRun

# Rust
alias cb = cargo build
alias cr = cargo run
alias ct = cargo test

# Go
alias gob = go build
alias gor = go run
alias got = go test
alias gom = go mod tidy

# Tmux
alias t = tmux
alias ta = tmux attach -t
alias tn = tmux new -s
alias tl = tmux list-sessions
alias tk = tmux kill-session -t

# Starship
source ~/.cache/starship/init.nu
