{ pkgs-unstable, ... }:
{
  wayland.windowManager.hyprland.settings = {
    # Refer to https://wiki.hyprland.org/Configuring/Variables/

    # Colors from catppuccin
    # https://github.com/catppuccin/hyprland/blob/main/themes/mocha.conf
    "$rosewater" = "rgb(f5e0dc)";
    "$rosewaterAlpha" = "f5e0dc";

    "$flamingo" = "rgb(f2cdcd)";
    "$flamingoAlpha" = "f2cdcd";

    "$pink" = "rgb(f5c2e7)";
    "$pinkAlpha" = "f5c2e7";

    "$mauve" = "rgb(cba6f7)";
    "$mauveAlpha" = "cba6f7";

    "$red" = "rgb(f38ba8)";
    "$redAlpha" = "f38ba8";

    "$maroon" = "rgb(eba0ac)";
    "$maroonAlpha" = "eba0ac";

    "$peach" = "rgb(fab387)";
    "$peachAlpha" = "fab387";

    "$yellow" = "rgb(f9e2af)";
    "$yellowAlpha" = "f9e2af";

    "$green" = "rgb(a6e3a1)";
    "$greenAlpha" = "a6e3a1";

    "$teal" = "rgb(94e2d5)";
    "$tealAlpha" = "94e2d5";

    "$sky" = "rgb(89dceb)";
    "$skyAlpha" = "89dceb";

    "$sapphire" = "rgb(74c7ec)";
    "$sapphireAlpha" = "74c7ec";

    "$blue" = "rgb(89b4fa)";
    "$blueAlpha" = "89b4fa";

    "$lavender" = "rgb(b4befe)";
    "$lavenderAlpha" = "b4befe";

    "$text" = "rgb(cdd6f4)";
    "$textAlpha" = "cdd6f4";

    "$subtext1" = "rgb(bac2de)";
    "$subtext1Alpha" = "bac2de";

    "$subtext0" = "rgb(a6adc8)";
    "$subtext0Alpha" = "a6adc8";

    "$overlay2" = "rgb(9399b2)";
    "$overlay2Alpha" = "9399b2";

    "$overlay1" = "rgb(7f849c)";
    "$overlay1Alpha" = "7f849c";

    "$overlay0" = "rgb(6c7086)";
    "$overlay0Alpha" = "6c7086";

    "$surface2" = "rgb(585b70)";
    "$surface2Alpha" = "585b70";

    "$surface1" = "rgb(45475a)";
    "$surface1Alpha" = "45475a";

    "$surface0" = "rgb(313244)";
    "$surface0Alpha" = "313244";

    "$base" = "rgb(1e1e2e)";
    "$baseAlpha" = "1e1e2e";

    "$mantle" = "rgb(181825)";
    "$mantleAlpha" = "181825";

    "$crust" = "rgb(11111b)";
    "$crustAlpha" = "11111b";

    # https://wiki.hyprland.org/Configuring/Variables/#general
    general = {
      gaps_in = 10;
      gaps_out = 5;
      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "$sapphire";
      "col.inactive_border" = "$surface0";

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;
    };

    # https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
      rounding = 5;

      # https://wiki.hyprland.org/Configuring/Variables/#shadow
      shadow = {
        color = "$surface0";
        color_inactive = "$surface0";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        size = 2;
        passes = 1;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#group
    group = {
      "col.border_active" = "$blue";
      "col.border_inactive" = "$surface0";
    };

    # https://wiki.hyprland.org/Configuring/Window-Rules/#layer-rules
    layerrule = [
      "blur, rofi"
      "ignorezero, rofi"
      "ignorealpha 0.7, rofi"

      "blur, swaync-control-center"
      "blur, swaync-notification-window"
      "ignorezero, swaync-control-center"
      "ignorezero, swaync-notification-window"
      "ignorealpha 0.7, swaync-control-center"
      # "ignorealpha 0.8, swaync-notification-window"
      # "dimaround, swaync-control-center"
    ];

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = true;

      # https://wiki.hyprland.org/Configuring/Animations/#curves
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "fluent_decel, 0.1, 1, 0, 1"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"

        # Old config
        # "easeOutQuint,0.23,1,0.32,1"
        # "easeInOutCubic,0.65,0.05,0.36,1"
        # "linear,0,0,1,1"
        # "almostLinear,0.5,0.5,0.75,1.0"
        # "quick,0.15,0,0.1,1"
      ];

      # https://wiki.hyprland.org/Configuring/Animations/#general
      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 2.5, md3_decel"
        # "workspaces, 1, 3.5, md3_decel, slide"
        "workspaces, 1, 3.5, easeOutExpo, slide"
        # "workspaces, 1, 7, fluent_decel, slidefade 15%"
        # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
        "specialWorkspace, 1, 3, md3_decel, slidevert"

        # Old config
        # "global, 1, 10, default"
        # "border, 1, 5.39, easeOutQuint"
        # "windows, 1, 4.79, easeOutQuint"
        # "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        # "windowsOut, 1, 1.49, linear, popin 87%"
        # "fadeIn, 1, 1.73, almostLinear"
        # "fadeOut, 1, 1.46, almostLinear"
        # "fade, 1, 3.03, quick"
        # "layers, 1, 3.81, easeOutQuint"
        # "layersIn, 1, 4, easeOutQuint, fade"
        # "layersOut, 1, 1.5, linear, fade"
        # "fadeLayersIn, 1, 1.79, almostLinear"
        # "fadeLayersOut, 1, 1.39, almostLinear"
        # "workspaces, 1, 1.94, almostLinear, fade"
        # "workspacesIn, 1, 1.21, almostLinear, fade"
        # "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.

    # workspace = w[tv1], gapsout:0, gapsin:0
    # workspace = f[1], gapsout:0, gapsin:0
    # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
    # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

    cursor = {
      min_refresh_rate = 60;
    };

    env = [
      # Size of cursor
      "HYPRCURSOR_SIZE,24"
      "XCURSOR_SIZE,24"

      # Theme of cursor
      "HYPRCURSOR_THEME,catppuccin-mocha-dark-cursors"
      "XCURSOR_THEME,catppuccin-mocha-dark-cursors"
    ];

    exec-once = [
      "hyprctl setcursor catppuccin-mocha-dark-cursors 24"
    ];
  };

  home.packages = with pkgs-unstable; [
    catppuccin-cursors.mochaDark
  ];
}
