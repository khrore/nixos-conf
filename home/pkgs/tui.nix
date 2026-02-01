{
  lib,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
let
  # NVIDIA-specific packages (only for Linux systems with NVIDIA GPU)
  nvidiaPackages = lib.optionals (mylib.isLinux system) [
    pkgs-unstable.btop-cuda
    pkgs-unstable.gpustat
  ];
  darwin = lib.optionals (mylib.isDarwin system) [
    pkgs-unstable.btop
    # pkgs-unstable.imv
  ];
in
{
  home.packages = [
    pkgs-unstable.yazi
    pkgs-unstable.neovim
    pkgs-unstable.zed-editor

    # AI
    pkgs-unstable.claude-code
    pkgs-unstable.opencode
    pkgs-unstable.qwen-code
    pkgs-unstable.gemini-cli

    # media
    pkgs-unstable.spotifyd
    pkgs-unstable.spotify-player

    # disk
    pkgs-unstable.ncdu
  ]
  ++ darwin
  ++ nvidiaPackages;
}
