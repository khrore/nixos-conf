{
  pkgs-unstable,
  ...
}:
{
  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;

    settings = {
      manager = {
        sort_dir_first = true;
        show_hidden = true;
        linemode = "size_and_mtime";
      };
    };

    initLua = ./init.lua;
  };
}
