{ mylib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors/
      # automatic monitor, resolution and refresh rate
      monitor = ",preferred,auto,auto";

      # auto launch apps
      exec-once = [
        "waybar"
        "hypridle"
        "clipse -listen"
      ];

      # systemd = {
      #   enable = true;
      #   variables = ["--all"];
      # };

      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL,1"

        # XDG specific environment variables are often detected
        # through portals and applications that may set those for you,
        # however it is not a bad idea to set them explicitly.
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # GTK: Use wayland if available. If not: try x11, then any other GDK backend.
        "GDK_BACKEND,wayland,x11,*"
        # Qt: Use wayland if available, fall back to x11 if not.
        "QT_QPA_PLATFORM,wayland;xcb"
        # Run SDL2 applications on Wayland. Remove or set to x11
        # if games that provide older versions of SDL cause compatibility issues
        "SDL_VIDEODRIVER,wayland"
        # Clutter package already has wayland enabled,
        # this variable will force Clutter applications to try and use the Wayland backend
        "CLUTTER_BACKEND,wayland"

        # Enables automatic scaling, based on the monitor’s pixel density
        # https://doc.qt.io/qt-5/highdpi.html
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        # Disables window decorations on Qt applications
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        # Tells Qt based applications to pick your theme from qt5ct, use with Kvantum.
        "QT_QPA_PLATFORMTHEME,qt5ct"

        "XDG_SCREENSHORTS_DIR,$HOME/screens"
      ];

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
  };

  xdg.configFile."hypr/assets".source = "${../../../assets}";

  imports = mylib.scanPaths ./.;
}
