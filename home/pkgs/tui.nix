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
    pkgs-unstable.imv
    # Moved to brew
    pkgs-unstable.zed-editor
  ];
  darwin = lib.optionals (mylib.isDarwin system) [
    pkgs-unstable.btop
  ];
in
{
  home.packages = [
    pkgs-unstable.yazi
    pkgs-unstable.neovim

    # media
    pkgs-unstable.spotifyd
    pkgs-unstable.spotify-player

    # disk
    pkgs-unstable.ncdu
  ]
  ++ darwin
  ++ nvidiaPackages;
}
