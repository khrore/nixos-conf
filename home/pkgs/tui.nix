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
in
{
  home.packages = [
    pkgs-unstable.yazi
    pkgs-unstable.neovim

    # AI
    pkgs-unstable.claude-code
    pkgs-unstable.opencode

    # media
    pkgs-unstable.spotifyd
    pkgs-unstable.spotify-player
    pkgs-unstable.imv

    # disk
    pkgs-unstable.ncdu
  ] ++ nvidiaPackages;
}
