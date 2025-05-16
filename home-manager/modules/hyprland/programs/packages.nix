{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    # Hyprland stuff
    hyprpicker # Wlroots-compatible Wayland color picker
    clipse # clipboard manager
    wl-clipboard # Command-line copy/paste utilities for Wayland
    hyprpolkitagent # polkit authentication daemon
  ];
}
