{ pkgs-unstable, ... }:
{
  programs.eza = {
    enable = true;
    packages = pkgs-unstable.eza;
    enableNushellIntegration = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    git = true;
    colors = "auto";
    icons = "auto";
  };
}
