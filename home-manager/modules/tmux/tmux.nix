{
  pkgs-unstable,
  inputs,
  ...
}: {
  programs.tmux = {
    enable = true;
    package = pkgs-unstable.tmux;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";

    extraConfig = "./tmux.conf";
  };
  xdg.configFile."tmux/plugins/catppuccin/tmux".source = "${inputs.catppuccin-tmux}";
}
