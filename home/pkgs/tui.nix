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
    pkgs-unstable.zed-editor # moved to brew
  ];
  darwin = lib.optionals (mylib.isDarwin system) [
    pkgs-unstable.btop
  ];
in
{
  home.packages = [
    pkgs-unstable.yazi
    pkgs-unstable.neovim

    # AI
    pkgs-unstable.claude-code
    pkgs-unstable.opencode
    pkgs-unstable.qwen-code
    pkgs-unstable.gemini-cli
    pkgs-unstable.github-copilot-cli
    pkgs-unstable.codex
    pkgs-unstable.codex-acp

    # media
    pkgs-unstable.spotifyd
    pkgs-unstable.spotify-player

    # disk
    pkgs-unstable.ncdu
  ]
  ++ darwin
  ++ nvidiaPackages;
}
