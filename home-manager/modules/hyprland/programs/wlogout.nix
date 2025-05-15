{ pkgs-unstable, ... }:
{
  programs.wlogout = {
    enable = true;
    package = pkgs-unstable.wlogout;
  };
}
