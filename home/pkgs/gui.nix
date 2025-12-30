{
  # Creating a user and giving it needed privileges
  inputs,
  username,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  users.users.${username}.packages = [
    # browser
    inputs.zen-browser.packages."${pkgs.system}".twilight # zen browser
    pkgs-unstable.firefox
    pkgs.chromium
    pkgs-unstable.brave # modified chromium

    # terminals
    inputs.ghostty.packages.${pkgs.system}.default # most featurefull terminal
    pkgs-unstable.kitty # stable terminal

    # apps
    pkgs-unstable.bruno
    pkgs-unstable.obs-studio # screencasting app
    pkgs-unstable.obsidian # note manager
    pkgs-unstable.telegram-desktop # messenger
    pkgs-unstable.spotify # offical client
    pkgs-unstable.mpv # media player
    pkgs-unstable.nautilus # gnome file manager
    pkgs-unstable.vesktop # custom Discord client
    pkgs-unstable.qbittorrent # QT torrent client

    # Time management
    pkgs-unstable.affine # Workspace with fully merged docs, whiteboards and databases

    # IDE
    pkgs-unstable.zed-editor

    # utils
    pkgs-unstable.waybar # bar
    pkgs-unstable.dunst # notification daemon
    pkgs-unstable.rofi # window switcher
    pkgs-unstable.wlogout # logout menu
    pkgs-unstable.hyprlock # screen lock
    pkgs-unstable.hyprpaper # wallpaper
    pkgs-unstable.hypridle # idle daemon
    pkgs-unstable.hyprpicker # Wlroots-compatible Wayland color picker
    pkgs-unstable.hyprshot # screenshots
    pkgs-unstable.clipse # clipboard manager

    # docs
    pkgs-unstable.libreoffice
    pkgs-unstable.gimp
  ];
}
