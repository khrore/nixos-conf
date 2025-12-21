{ pkgs-unstable, ... }:
{
  programs = {
    zsh.enable = true;
    fish = {
      enable = true;
      package = pkgs-unstable.fish;
    };
  };
}
