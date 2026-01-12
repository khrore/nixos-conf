{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  home.packages = [
    # shells
    pkgs-unstable.nushell

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
  ];
}
