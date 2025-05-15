# Enables Nix CLI helper.
{ pkgs-unstable, ... }:
{
  programs.nh = {
    enable = true;
    package = pkgs-unstable.nh;
    flake = "~/current-conf";
  };
}
