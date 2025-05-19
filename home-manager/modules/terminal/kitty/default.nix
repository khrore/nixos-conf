###########################################################
#
# Kitty Configuration
#
# Useful Hot Keys for Linux(replace `ctrl + shift` with `cmd` on macOS)):
#   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   3. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
###########################################################
{
  inputs,
  pkgs-unstable,
  browser,
  ...
}:
{
  programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;

    # consistent with other terminal emulators
    # keybindings = {
    #   "ctrl+shift+m" = "toggle_maximized";
    #   "ctrl+shift+f" = "show_scrollback"; # search in the current window
    # };
    #
    settings = {
      show_hyperlink_targets = true;
      open_url_with = browser;
      copy_on_select = true;
      background_opacity = "0.93";
      enable_audio_bell = false;
      tab_bar_edge = "top"; # tab bar on top
      clipboard_control = "write-primary write-clipboard no-append";
    };

    extraConfig = builtins.readFile ./kitty.conf;
  };
}
