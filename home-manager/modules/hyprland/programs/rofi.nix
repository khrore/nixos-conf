{ pkgs-unstable, terminal, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs-unstable.rofi-wayland;
    terminal = terminal;
  };
}
