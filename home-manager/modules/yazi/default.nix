{
  pkgs-unstable,
  ...
}:
{
  programs.yazi = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;

    package = pkgs-unstable.yazi;

    settings = {
      manager = {
        sort_dir_first = true;
        show_hidden = true;
        linemode = "size_and_mtime";
      };
    };
  };

  # script to show custom size_and_mtime info
  xdg.configFile."yazi/init.lua".source = ./init.lua;
}
