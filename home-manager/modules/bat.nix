{ pkgs-unstable, ... }:
{
  programs.bat = {
    enable = true;
    package = pkgs-unstable.bat;
  };
}
