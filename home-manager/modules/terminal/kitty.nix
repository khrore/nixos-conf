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
  ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    # consistent with other terminal emulators
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback"; # search in the current window
    };

    settings = {
      background_opacity = "0.93";
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      enable_audio_bell = false;
      tab_bar_edge = "top"; # tab bar on top
      shell = "${pkgs-unstable.bash}/bin/bash --login -c 'fish'";
    };

    # Set catppuccin mocha theme
    extraConfig = builtins.readFile "${inputs.catppuccin-kitty}/themes/mocha.conf";
  };
}
