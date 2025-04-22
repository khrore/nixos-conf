{ pkgs-unstable, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs-unstable.ghostty;
    enableFishIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      font-family = "JetBrains Mono";
      font-size = 11;

      background-opacity = 0.95;
      background-blur-radius = 20;

      mouse-hide-while-typing = true;

      keybind = [
        "super+shift+r=reload_config"
      ];
    };
  };

}
