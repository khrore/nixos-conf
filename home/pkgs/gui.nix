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
  linuxGuiPkgs =
    lib.optionals (mylib.isLinux system) [
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
    ]
    ++ lib.optionals (mylib.isLinux system && builtins.hasAttr system inputs.zen-browser.packages) [
      inputs.zen-browser.packages."${system}".twilight
    ];

  # Cross-platform GUI packages
  sharedGuiPkgs = [
    # Browsers
    pkgs-unstable.firefox
    pkgs.chromium

    # Terminals
    pkgs-unstable.kitty
    pkgs-unstable.ghostty

    # Applications
    pkgs-unstable.obs-studio
    pkgs-unstable.obsidian
    pkgs-unstable.telegram-desktop
    pkgs-unstable.spotify
    pkgs-unstable.mpv
    pkgs-unstable.qbittorrent
    pkgs-unstable.affine
    pkgs-unstable.zed-editor
  ];
in
{
  home.packages = sharedGuiPkgs ++ linuxGuiPkgs;
}
