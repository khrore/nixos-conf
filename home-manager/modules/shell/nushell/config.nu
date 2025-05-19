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
alias la = ls -a
alias lla = ls -la

alias c = clear

alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log

alias nrs = nixos-rebuild switch
alias sw = nh os switch
alias upd = nh os switch --update
alias hms = nh home switch

alias v = nvim

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}
