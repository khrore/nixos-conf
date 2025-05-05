{
  terminal,
  terminalFileManager,
  browser,
  terminalEditor,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hyprland.org/Configuring/Keywords/
    # setuping default apps
    "$terminal" = terminal;
    "$browser" = browser;
    "$fileManager" = "$terminal '${terminalFileManager}'";
    "$editor" = "$terminal '${terminalEditor}'";
    "$menu" = "rofi";
    "$mainMod" = "SUPER";

    bind = [
      # Opening apps
      "$mainMod, Q, killactive" # closes (not kills) the active window
      "$mainMod, delete, exit" # kill hyperland session
      "$mainMod, W, togglefloating" # toggle the window on focus to float
      "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to float
      "ALT, return, fullscreen" # toggle the window on focus to fullscreen
      "$mainMod, SPACE, exec, hyprctl switchxkblayout current next" # change language input

      # Some Hyprland utilities
      "$mainMod, P, exec, hyprpicker" # pick a color
      "$mainMod ALT, L, exec, hyprlock" # lock screen

      # TODO: make if termainal == "ghostty" { this } else { standart }
      # "$mainMod, V, exec, ${terminal} --class clipse -e clipse" # clipboard manager
      "$mainMod, V, exec, ${terminal} --class=com.example.clipse -e clipse" # clipboard manager

      # Command to open main apps
      "$mainMod, T, exec, $terminal"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, B, exec, proxychain4 $browser"
      "$mainMod, M, exec, telegram-desktop"
      "$mainMod, D, exec, vesktop"

      # Moving focus
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, K, movefocus, u"
      "$mainMod, J, movefocus, d"

      # Moving windows
      "$mainMod SHIFT, H, swapwindow, l"
      "$mainMod SHIFT, L, swapwindow, r"
      "$mainMod SHIFT, K, swapwindow, u"
      "$mainMod SHIFT, J, swapwindow, d"

      # Resizeing windows                X  Y
      "$mainMod  CTRL, H, resizeactive, -60 0"
      "$mainMod  CTRL, L, resizeactive,  60 0"
      "$mainMod  CTRL, K, resizeactive,  0  60"
      "$mainMod  CTRL, J, resizeactive,  0 -60"

      # Switching workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Moving windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

      # Keys for volume
      "$mainMod SHIFT, up, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      "$mainMod SHIFT, down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      "$mainMod SHIFT, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

      # binding clipboard manager
      # "$mainMod, V, exec, kitty --class clipse -e clipse"
    ];

    # aditional settings for clipboard manager
    windowrulev2 = [
      "float, class:(clipse)"
      "size 622 652, class:(clipse)"
    ];
  };
}
