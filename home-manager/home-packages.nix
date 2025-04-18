{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
    # TODO: move configurable apps to specific files

    # Desktop apps
    imv # image viewer
    mpv # media player
    obs-studio # screencasting and streaming app
    obsidian # writing app CONFIG
    telegram-desktop # messenger
    vesktop # custom Discord app
    gimp # image Manipulation Program
    retroarch-full # frontend for system emulators
    wine64 # is not emulator for windows apps
    flatpak
    # wireguard
    # wireguard-tools

    # games (need original bin)
    arx-libertatis # Arx Fatalis
    openmw # TES 3: Morrowind

    # ML and DataScience
    micromamba

    # Git and Hub
    gh # GitHub CLI tool
    git-credential-manager
    git-lfs # used by huggingface models
    git-graph # Command line tool to show clear git graphs
    # TODO: configure gh through home-manager

    # CLI utils
    innoextract # extract files from windows installer
    cliphist # Wayland clipboard manager
    ffmpeg # solution to record, convert and stream audio and video
    ffmpegthumbnailer # video thumbnailer that can be used by file managers to create thumbnails for video files
    grimblast # Helper for screenshots within Hyprland, based on grimshot
    mediainfo # Supplies technical and tag information about a video or audio file
    microfetch # Microscopic fetch script in Rust, for NixOS systems
    ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    silicon # render your source code into a beautiful image
    udisks # Daemon, tools and libraries to access and manipulate disks, storage devices and technologies
    ueberzugpp # draw images on terminals
    fd # Simple, fast and user-friendly alternative to find

    showmethekey # Show keys you typed on screen
    bottom # graphical process/system monitor
    htop # Interactive process viewer
    w3m # text-mode web browser

    # archives
    zip
    xz
    unzip
    p7zip

    wtype # Fake keyboard/mouse input, window management, and more for wayland
    file # Program that shows the type of files
    jd-diff-patch # Commandline utility and Go library for diffing and patching JSON values
    # popper
    imagemagick # Software suite to create, edit, compose, or convert bitmap images

    brightnessctl # allows you read and control device brightness
    playerctl # Command-line utility and library for controlling media players that implement MPRIS
    yt-dlp # Command-line tool to download videos from YouTube.com and other sites

    # networking tools
    openvpn # vpn app
    proxychains-ng # tool to set multiple proxis to target app
    wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # Coding stuff
    vscode # IDE for if others dont work CONFIG

    # WM stuff
    libsForQt5.xwaylandvideobridge # Utility to allow streaming Wayland windows to X applications
    libsForQt5.qt5ct # Qt5 Configuration Tool
    libsForQt5.qt5.qtwayland
    libxkbcommon

    libnotify # Library that sends desktop notifications to a notification daemon

    # utils for mounting flashdrive with ntfs file system
    fuse # need only for ntfs3g
    ntfs3g # ntfs file system mount tool
    cifs-utils # managing Linux CIFS client filesystems
    smbclient-ng # access to smb file system from console

    # Other
    bemoji # Emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/X11
    nix-prefetch-scripts # Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
    libreoffice-qt6-fresh # office productivity software suite
    kdePackages.qt6ct # Qt6 Configuration Tool
    nwg-look # GTK3 settings editor

    rofi-wayland # window switcher
    hyprpicker # Wlroots-compatible Wayland color picker
    # bibata-cursors
    # flat-remix-gtk
    # gnome.adwaita-icon-theme

    # TODO: move themes in specific dir
    # Catppuccin themes for different apps
    catppuccin
    catppuccin-sddm
    catppuccin-gtk
    catppuccin-grub
    catppuccin-kde
    catppuccin-fcitx5
    catppuccin-kvantum
    catppuccin-qt5ct
    # vscode-extensions.catppuccin.catppuccin-vsc
    # vscode-extensions.catppuccin.catppuccin-vsc-icons
  ];
}
