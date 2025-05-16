# A command-line fuzzy finder
{ pkgs-unstable, ... }:
{
  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
  };
}
