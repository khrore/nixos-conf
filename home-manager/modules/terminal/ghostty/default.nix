{ pkgs-unstable, ... }:
let
  main-bind = "ctrl+b";
in
{
  programs.ghostty = {
    enable = true;
    package = pkgs-unstable.ghostty;
    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 13;

      background-opacity = 0.95;

      mouse-hide-while-typing = true;
      copy-on-select = true;
      maximize = true;
      confirm-close-surface = false;
      gtk-tabs-location = "hidden";
      auto-update = "off";

      keybind = [
        "${main-bind}>r=reload_config"

        "${main-bind}>==increase_font_size"
        "${main-bind}>-=decrease_font_size"
        # "${main-bind}>'=reset_font_size"

        "${main-bind}>g>g=scroll_to_top"
        "${main-bind}>shift+g=scroll_to_bottom"

        "${main-bind}>k=scroll_page_up"
        "${main-bind}>j=scroll_page_down"

        "${main-bind}>l=next_tab"
        "${main-bind}>h=previous_tab"

        "${main-bind}>t=new_tab"
        "${main-bind}>x=close_tab"
      ];
    };
  };
}
