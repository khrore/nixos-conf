{ pkgs-unstable, ... }:
{
  programs.waybar = {
    enable = true;
    packages = pkgs-unstable.waybar;

    style = builtins.readFile ./style.css;
  };

  # settings parameter is very annoying, so im just put config in system
  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
}
