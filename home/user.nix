# Creating a user and giving it needed privileges
{
  username,
  pkgs-unstable,
  shell,
  ...
}:
{
  users = {
    defaultUserShell = pkgs-unstable.${shell};
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      packages = with pkgs-unstable; [
        # Packages that don't require configuration. If you're looking to configure a program see the /modules dir

        # Desktop apps
        obsidian # note manager
        telegram-desktop # messenger
        spotify # offical client
        libreoffice-qt6-still

        # ML and DataScience
        micromamba

        # Git and Hub
        gh # GitHub CLI tool
        git-credential-manager
        git-lfs # used by huggingface models
        git-graph # Command line tool to show clear git graphs

        # CLI utils
        innoextract # extract files from inno installer
        cliphist # Wayland clipboard manager
        ffmpeg-full # solution to record, convert and stream audio and video
        ffmpegthumbnailer # video thumbnailer that can be used by file managers to create thumbnails for video files
        grimblast # Helper for screenshots within Hyprland, based on grimshot
        mediainfo # Supplies technical and tag information about a video or audio file
        microfetch # Microscopic fetch script in Rust, for NixOS systems
        ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
        silicon # render your source code into a beautiful image
        ueberzugpp # draw images on terminals
        fd # Simple, fast and user-friendly alternative to find
        showmethekey # Show keys you typed on screen
        tldr # colored man pages

        # archives
        zip
        xz
        unzip
        p7zip

        # Tools for TUI
        wtype # Fake keyboard/mouse input, window management, and more for wayland
        file # Program that shows the type of files
        jd-diff-patch # Commandline utility and Go library for diffing and patching JSON values
        imagemagick # Software suite to create, edit, compose, or convert bitmap images

        brightnessctl # allows you read and control device brightness
        playerctl # Command-line utility and library for controlling media players that implement MPRIS

        # networking tools
        proxychains-ng # tool to set multiple proxis to target app
        wget # Tool for retrieving files using HTTP, HTTPS, and FTP
        mtr # A network diagnostic tool
        iperf3 # tool for network performance measurement and tuning
        dnsutils # `dig` + `nslookup`
        ldns # replacement of `dig`, it provide the command `drill`
        aria2 # A lightweight multi-protocol & multi-source command-line download utility
        socat # replacement of openbsd-netcat
        nmap # A utility for network discovery and security auditing
        ipcalc # it is a calculator for the IPv4/v6 addresses
        openssl # Cryptographic library that implements the SSL and TLS protocols
        qbittorrent # open source bittorrent client
        ncdu # disk space usage analyzer

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

        # nix stuff
        nix-eval-jobs # tool for multithreaded nix package build
        nix-fast-build # more pretty build tool

        # Other
        bemoji # emoji picker with support for bemenu/wofi/rofi/dmenu and wayland/x11
        nix-prefetch-scripts # collection of all the nix-prefetch-* scripts which may be used to obtain source hashes
        kdePackages.qt6ct # qt6 configuration tool
        nwg-look # gtk3 settings editor
        alsa-lib # advanced linux sound architecture
        widevine-cdm
        nautilus

        # games (need original bin)
        retroarch-full # frontend for system emulators
        arx-libertatis # Arx Fatalis
        openmw # TES 3: Morrowind
        SDL2 # Simple DirectMedia Layer

        rtorrent

        zoxide
        stow
        starship
        neovim
        btop
        bat
        atuin
        spotifyd
        spotify-player
        tmux
        eza
        fzf
        git
        imv
        mpv
        nh
        yt-dlp

        kitty

        fish
        zsh
        nushell

        waybar
        dunst

        obs-studio
        rofi

        # Rust/C/C++
        lldb

        # Nix
        nil # lsp with features
        nixfmt-rfc-style # formatter

        # Lua
        lua-language-server # lsp
        luajit # just-in-time compiler
        stylua # formatter
        luajitPackages.luacheck # linter

        # Python
        python314 # python exec
        # pyright # language server
        ruff # formatter
        basedpyright # lsp + type checker
        # ruff-lsp # lsp
        python313Packages.debugpy

        # TypeScript and JavaScript
        vtsls # lsp
        vscode-js-debug # debugger
        prettierd # formatter daemon

        # Bash
        bash-language-server # lsp
        shellcheck # Shell script analysis tool
        shfmt # Shell parser and formatter

        # Nushell
        nufmt # formater

        # Fish
        fish-lsp # lsp

        # Markdown
        marksman # lsp
        mdformat # formatter
        glow # previewer
        markdownlint-cli2 # command-line interface for linting

        # Yaml
        yaml-language-server # lsp

        # HTML/CSS/JSON/ESLint language servers extracted from vscode
        vscode-langservers-extracted

        # Hyprland
        hyprls # lsp

        # CMake system generator
        cmake # app
        neocmakelsp # lsp
        cmake-format # formater
        cmake-lint # linter

        # Make build system
        gnumake # app
        checkmake # linter

        wlogout
        hyprlock
        hyprpaper
        hypridle
        hyprpicker # Wlroots-compatible Wayland color picker
        hyprshot
        clipse # clipboard manager
        wl-clipboard # Command-line copy/paste utilities for Wayland
      ];
    };
  };
}
