# for more info type: config nu --doc | nu-highlight | bat

$env.config.use_ansi_coloring = true
$env.config.use_kitty_protocol = true
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.footer_mode = "auto"

$env.config.table.mode = "markdown"
$env.config.table.trim = {
  methodology: wrapping # wrapping or truncating
  wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
  truncating_suffix: "..." # A suffix used by the 'truncating' methodology
}

# aliases 
alias l = ls
alias ll = ls -l
alias lla = ls -la

alias c = clear

alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push

alias nrs = nixos-rebuild switch
alias sw = nh os switch
alias upd = nh os switch --update
alias hms = nh home switch

# launching tmux automaticaly
if ($env.DISPLAY | is-empty) and not ($env.TMUX | is-empty) {
    try {
        tmux attach-session -t default
    } catch {
        tmux new-session -s default
    }
}
