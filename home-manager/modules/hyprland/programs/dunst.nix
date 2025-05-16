{ pkgs-unstable, ... }:
{
  services.dunst = {
    enable = true;
    package = pkgs-unstable.dunst;
  };
}
