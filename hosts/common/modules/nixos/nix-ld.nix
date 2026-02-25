{ pkgs-unstable, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = [
      pkgs-unstable.neovim
      pkgs-unstable.zed-editor
      pkgs-unstable.nodejs_24
    ];
  };
}
