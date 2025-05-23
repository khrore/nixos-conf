# zoxide is a smarter cd command, inspired by z and autojump.
# It remembers which directories you use most frequently,
# so you can "jump" to them in just a few keystrokes.
# zoxide works on all major shells.
#
#   z foo              # cd into highest ranked directory matching foo
#   z foo bar          # cd into highest ranked directory matching foo and bar
#   z foo /            # cd into a subdirectory starting with foo
#
#   z ~/foo            # z also works like a regular cd command
#   z foo/             # cd into relative path
#   z ..               # cd one level up
#   z -                # cd into previous directory
#
#   zi foo             # cd with interactive selection (using fzf)
#
#   z foo<SPACE><TAB>  # show interactive completions (zoxide v0.8.0+, bash 4.4+/fish/zsh only)
{ pkgs-unstable, ... }:
{
  programs.zoxide = {
    enable = true;
    package = pkgs-unstable.zoxide;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
  };
}
