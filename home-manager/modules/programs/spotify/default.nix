{ pkgs-unstable, ... }:
{
  services.spotifyd = {
    enable = true;
    package = pkgs-unstable.spotifyd;
  };

  xdg.configFile."spotifyd/spotifyd.conf".source = ./spotifyd.conf;
}
