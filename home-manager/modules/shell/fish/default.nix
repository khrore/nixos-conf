{ pkgs-unstable, ... }:
{
  programs.fish = {
    enable = true;
    package = pkgs-unstable.fish;

    shellInit = builtins.readFile ./conf.fish;
  };
}
