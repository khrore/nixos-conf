{ pkgs-unstable, ... }:
{
  programs.obs-studio = {
    enable = true;
    package = pkgs-unstable.obs-studio;
  };
}
