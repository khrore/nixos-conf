{
  lib,
  pkgs-unstable,
  mylib,
  system,
  ...
}:
{
  # System-level programs (NixOS only)
  programs = lib.mkIf (mylib.isLinux system) {
    zsh.enable = true;
    fish = {
      enable = true;
      package = pkgs-unstable.fish;
    };
    localsend = {
      enable = true;
      package = pkgs-unstable.localsend;
      openFirewall = true;
    };
  };
}
