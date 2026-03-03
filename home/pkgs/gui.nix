{
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
let
  # Linux-specific GUI packages
  linuxGuiPkgs = lib.optionals (mylib.isLinux system) [
    # Wayland/Hyprland tools (Linux only)
    pkgs-unstable.waybar
    pkgs-unstable.dunst
    pkgs-unstable.rofi
    pkgs-unstable.wlogout
    pkgs-unstable.hyprlock
    pkgs-unstable.hyprpaper
    pkgs-unstable.hypridle
    pkgs-unstable.hyprpicker
    pkgs-unstable.hyprshot
    pkgs-unstable.clipse
    pkgs-unstable.nautilus

    # Other
    inputs.zen-browser.packages."${system}".twilight
    pkgs-unstable.ghostty
    pkgs-unstable.zed-editor
    pkgs-unstable.obs-studio
    pkgs-unstable.mpv
    pkgs-unstable.anydesk

    # Browser
    pkgs-unstable.ungoogled-chromium
    pkgs-unstable.tor
  ];

  # Cross-platform GUI packages
  sharedGuiPkgs = with pkgs-unstable; [
    # Terminals
    kitty

    # Applications
    obsidian
    telegram-desktop
    spotify
    qbittorrent
    affine
  ];
in
{
  home.packages = sharedGuiPkgs ++ linuxGuiPkgs;
}
