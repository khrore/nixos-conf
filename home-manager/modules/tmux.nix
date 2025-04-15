{
  terminal,
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

    extraConfig = ''
      set -g @catppuccin_flavor 'mocha'
      run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
    '';
  };
  xdg.configFile."tmux/plugins/catppuccin/tmux".source = "${inputs.catppuccin-tmux}";
}
