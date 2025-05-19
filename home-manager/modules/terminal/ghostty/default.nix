{ pkgs-unstable, ... }:
let
  main-bind = "ctrl+a";
  divider = "20";
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
      auto-update = "off";

      clipboard-read = "allow";
      clipboard-write = "allow";

      gtk-custom-css = "tab-style.css";
      gtk-tabs-location = "top";

      keybind = [
        "${main-bind}>r=reload_config"

        # "${main-bind}>+=increase_font_size"
        # "${main-bind}>-=decrease_font_size"
        # "${main-bind}>'=reset_font_size"

        "${main-bind}>g>g=scroll_to_top"
        "${main-bind}>shift+g=scroll_to_bottom"

        "${main-bind}>u=scroll_page_up"
        "${main-bind}>d=scroll_page_down"

        "${main-bind}>]=next_tab"
        "${main-bind}>[=previous_tab"

        "${main-bind}>c=new_tab"
        "${main-bind}>x=close_tab"

        "${main-bind}>1=goto_tab:1"
        "${main-bind}>2=goto_tab:2"
        "${main-bind}>3=goto_tab:3"
        "${main-bind}>4=goto_tab:4"
        "${main-bind}>5=goto_tab:5"
        "${main-bind}>6=goto_tab:6"
        "${main-bind}>7=goto_tab:7"
        "${main-bind}>8=goto_tab:8"
        "${main-bind}>9=goto_tab:9"

        "${main-bind}>k=goto_split:up"
        "${main-bind}>j=goto_split:down"
        "${main-bind}>h=goto_split:left"
        "${main-bind}>l=goto_split:right"

        "${main-bind}>ctrl+k=new_split:up"
        "${main-bind}>ctrl+j=new_split:down"
        "${main-bind}>ctrl+h=new_split:left"
        "${main-bind}>ctrl+l=new_split:right"

        "${main-bind}>shift+k=resize_split:up,${divider}"
        "${main-bind}>shift+j=resize_split:down,${divider}"
        "${main-bind}>shift+h=resize_split:left,${divider}"
        "${main-bind}>shift+l=resize_split:right,${divider}"

        "${main-bind}>e=equalize_splits"
        "${main-bind}>q=close_surface"

        "${main-bind}>n=toggle_quick_terminal" # works only on macOS

        "${main-bind}>i=inspector:toggle"
        "${main-bind}>t=toggle_tab_overview"
      ];
    };
  };

  xdg.configFile."ghostty/tab-style.css".source = ./tab-style.css;
}
