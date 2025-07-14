{
  # Creating a user and giving it needed privileges
  inputs,
  username,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  users.users.${username}.packages = [
    inputs.yazi.packages.${pkgs.system}.default # file manager
    pkgs-unstable.neovim # the best text editor
    pkgs-unstable.rtorrent # tui torrent client

    # media
    pkgs-unstable.spotifyd # spotify deamon
    pkgs-unstable.spotify-player # tui spotify
    pkgs-unstable.imv # image viewer

    # monitors
    pkgs-unstable.btop # monitor of resources
    pkgs-unstable.gpustat # gpu monitor
  ];
}
