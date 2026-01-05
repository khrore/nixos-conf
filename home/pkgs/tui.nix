{
  # Creating a user and giving it needed privileges
  inputs,
  username,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  environment.systemPackages = [
    pkgs-unstable.yazi # file manager
    pkgs-unstable.neovim # the best text editor

    # AI
    pkgs-unstable.claude-code # Anthopics AI assistant
    pkgs-unstable.opencode # Open source AI assistant

    # media
    pkgs-unstable.spotifyd # spotify deamon
    pkgs-unstable.spotify-player # tui spotify
    pkgs-unstable.imv # image viewer

    # monitors
    pkgs-unstable.btop-cuda # monitor of resources with NVidia GPU support
    pkgs-unstable.gpustat # gpu monitor

    # disk
    pkgs-unstable.ncdu # disk analyzer
  ];
}
