{
  # Creating a user and giving it needed privileges
  username,
  pkgs-unstable,
  ...
}:
{
  users.users.${username}.packages = [
    # git and hub
    pkgs-unstable.git
    pkgs-unstable.gh # GitHub CLI tool
    pkgs-unstable.git-credential-manager
    pkgs-unstable.git-lfs # used by huggingface models
    pkgs-unstable.git-graph # Command line tool to show clear git graphs

    # CLI utils
    pkgs-unstable.cliphist # Wayland clipboard manager
    pkgs-unstable.ffmpeg-full # solution to record, convert and stream audio and video
    pkgs-unstable.ffmpegthumbnailer # video thumbnailer that can be used by file managers to create thumbnails for video files
    pkgs-unstable.grimblast # Helper for screenshots within Hyprland, based on grimshot
    pkgs-unstable.mediainfo # Supplies technical and tag information about a video or audio file
    pkgs-unstable.silicon # render your source code into a beautiful image
    pkgs-unstable.ueberzugpp # draw images on terminals
    pkgs-unstable.wl-clipboard # command-line copy/paste utilities for Wayland
    pkgs-unstable.showmethekey # Show keys you typed on screen
    pkgs-unstable.stow # simlink manager
    pkgs-unstable.nh # nix cli helper
    pkgs-unstable.yt-dlp # download youtube video

    # networking tools
    pkgs-unstable.sing-box # connection to proxy server
    pkgs-unstable.wget # Tool for retrieving files using HTTP, HTTPS, and FTP
    pkgs-unstable.mtr # A network diagnostic tool
    pkgs-unstable.iperf3 # tool for network performance measurement and tuning
    pkgs-unstable.dnsutils # `dig` + `nslookup`
    pkgs-unstable.ldns # replacement of `dig`, it provide the command `drill`
    pkgs-unstable.aria2 # A lightweight multi-protocol & multi-source command-line download utility
    pkgs-unstable.socat # replacement of openbsd-netcat
    pkgs-unstable.nmap # A utility for network discovery and security auditing
    pkgs-unstable.ipcalc # it is a calculator for the IPv4/v6 addresses
    pkgs-unstable.openssl # Cryptographic library that implements the SSL and TLS protocols
    pkgs-unstable.ncdu # disk space usage analyzer
    pkgs-unstable.nftables # providing filtering and classification of network
    pkgs-unstable.spotdl # download spotify tracks
    pkgs-unstable.bruno-cli # CLI of the open-source IDE For exploring and testing APIs

    # utils for mounting flashdrive with ntfs file system
    pkgs-unstable.fuse # need only for ntfs3g
    pkgs-unstable.ntfs3g # ntfs file system mount tool
    pkgs-unstable.cifs-utils # managing Linux CIFS client filesystems
    pkgs-unstable.smbclient-ng # access to smb file system from console

    # nix stuff
    pkgs-unstable.nix-eval-jobs # tool for multithreaded nix package build
    pkgs-unstable.nix-fast-build # more pretty build tool
    pkgs-unstable.microfetch # microscopic fetch script in Rust, for NixOS systems

    # Tools for TUI
    pkgs-unstable.wtype # Fake keyboard/mouse input, window management, and more for wayland
    pkgs-unstable.file # Program that shows the type of files
    pkgs-unstable.jd-diff-patch # Commandline utility and Go library for diffing and patching JSON values
    pkgs-unstable.imagemagick # Software suite to create, edit, compose, or convert bitmap images
    pkgs-unstable.brightnessctl # allows you read and control device brightness
    pkgs-unstable.playerctl # Command-line utility and library for controlling media players that implement MPRIS
    pkgs-unstable.libnotify # Library that sends desktop notifications to a notification daemon

    # archives
    pkgs-unstable.zip # standart zip files
    pkgs-unstable.unzip # standart unzip files
    pkgs-unstable.xz # alternative to gzip
    pkgs-unstable.p7zip # 7z zip

    # WM stuff
    pkgs-unstable.libsForQt5.qt5ct # Qt5 Configuration Tool
    pkgs-unstable.libsForQt5.qt5.qtwayland
    pkgs-unstable.libxkbcommon

    # gibs
    pkgs-unstable.bemoji # emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/x11
    pkgs-unstable.nix-prefetch-scripts # collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
    pkgs-unstable.nwg-look # gtk3 settings editor
    pkgs-unstable.alsa-lib # advanced linux sound architecture

    # visual
    pkgs-unstable.catppuccin-cursors.mochaDark # cursor themes

    # docs
    pkgs-unstable.pandoc # document convernter
    pkgs-unstable.texliveSmall # small set of texlive software
  ];
}
