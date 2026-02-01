{
  pkgs-unstable,
  mylib,
  lib,
  system,
  ...
}:
let
  linuxTools = lib.optionals (mylib.isLinux system) [
    pkgs-unstable.nushell
  ];
in
{
  home.packages = [
    # shells

    # utils
    pkgs-unstable.atuin
    pkgs-unstable.zoxide
    pkgs-unstable.starship
    pkgs-unstable.tmux
    pkgs-unstable.eza
    pkgs-unstable.fzf
    pkgs-unstable.bat
    pkgs-unstable.ripgrep
    pkgs-unstable.fd
    pkgs-unstable.tldr
  ]
  ++ linuxTools;
}
