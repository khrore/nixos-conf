{kbdLayout, ...}: {
  wayland.windowManager.hyprland.settings = {
    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = kbdLayout;
      kb_options = "grp:caps_toggle";
      sensitivity = 1.0;
      accel_profile = "custom 0 3.0"; # flat acceleration with x3 sensitivity
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_invert = false;
      workspace_swipe_forever = true;
    };
  };
}
