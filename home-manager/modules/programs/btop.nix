# A monitor of resources
# replacement of htop/nmon
{ pkgs-unstable, ... }:
{
  programs.btop = {
    enable = true;
    package = pkgs-unstable.btop;
  };
}
