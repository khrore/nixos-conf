{
  # Creating a user and giving it needed privileges
  username,
  pkgs-unstable,
  ...
}:
{
  users.users.${username}.packages = [
    # shells
    pkgs-unstable.fish
    pkgs-unstable.zsh
    pkgs-unstable.nushell

    # utils
    pkgs-unstable.zoxide # smart cd command
    pkgs-unstable.starship # prompt for shell
    pkgs-unstable.atuin # powerfull shell history
    pkgs-unstable.tmux # terminal multiplexer
    pkgs-unstable.eza # modern ls util
    pkgs-unstable.fzf # cl fuzzy finder
    pkgs-unstable.bat # cat utile with colors
    pkgs-unstable.ripgrep # combines the usability of The Silver Searcher with the raw speed of grep
    pkgs-unstable.fd # simple, fast and user-friendly alternative to find
    pkgs-unstable.tldr # colored man pages
  ];
}
