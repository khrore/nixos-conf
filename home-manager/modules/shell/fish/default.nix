{pkgs-unstable, ...}: {
  programs.fish = {
    enable = true;
    package = pkgs-unstable.fish;
    # TODO: replace this theme to different file
    # https://github.com/catppuccin/fish/blob/main/themes/Catppuccin%20Mocha.theme
    shellInit = ''
      set -U fish_color_normal cdd6f4
      set -U fish_color_command 89b4fa
      set -U fish_color_param f2cdcd
      set -U fish_color_keyword f38ba8
      set -U fish_color_quote a6e3a1
      set -U fish_color_redirection f5c2e7
      set -U fish_color_end fab387
      set -U fish_color_comment 7f849c
      set -U fish_color_error f38ba8
      set -U fish_color_gray 6c7086
      set -U fish_color_selection --background=313244
      set -U fish_color_search_match --background=313244
      set -U fish_color_option a6e3a1
      set -U fish_color_operator f5c2e7
      set -U fish_color_escape eba0ac
      set -U fish_color_autosuggestion 6c7086
      set -U fish_color_cancel f38ba8
      set -U fish_color_cwd f9e2af
      set -U fish_color_user 94e2d5
      set -U fish_color_host 89b4fa
      set -U fish_color_host_remote a6e3a1
      set -U fish_color_status f38ba8
      set -U fish_pager_color_progress 6c7086
      set -U fish_pager_color_prefix f5c2e7
      set -U fish_pager_color_completion cdd6f4
      set -U fish_pager_color_description 6c7086

      # disable fish hello
      set -g fish_greeting ""

      # Start Tmux automatically if not already running. No Tmux in TTY
      if test -z "$TMUX"; and test -n "$DISPLAY"
        tmux attach-session -t default; or tmux new-session -s default
      end
    '';
  };
}
