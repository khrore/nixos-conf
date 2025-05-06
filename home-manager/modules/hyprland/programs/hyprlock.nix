{ pkgs-unstable, wallpaper, ... }:
{
  programs.hyprlock = {
    enable = true;
    package = pkgs-unstable.hyprlock;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = wallpaper;
          blur_passes = 3;
          blur_size = 8;
        }
      ];
    };
  };
}
