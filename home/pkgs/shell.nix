{
  pkgs-unstable,
  mylib,
  lib,
  system,
  ...
}:
let
  linuxTools =
    with pkgs-unstable;
    lib.optionals (mylib.isLinux system) [
      nushell
    ];
in
{
  home.packages =
    with pkgs-unstable;
    [
      # shells
      blesh

      # utils
      atuin
      zoxide
      starship
      tmux
      eza
      fzf
      bat
      ripgrep
      fd
      tldr
    ]
    ++ linuxTools;
}
