# Enables Nix CLI helper.
{ pkgs-unstable, username, ... }:
{
  programs.nh = {
    enable = true;
    package = pkgs-unstable.nh;
  };
}
