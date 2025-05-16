{ pkgs-unstable, ... }:
{
  programs.dunst = {
    enable = true;
    package = pkgs-unstable.dunst;
  };
}
