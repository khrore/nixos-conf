{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
  };

  # settings parameter is very annoying, so im just put config in system
  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
}
