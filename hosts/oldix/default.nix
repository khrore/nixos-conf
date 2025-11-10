# This is your system's configuration file.
# Use this to configure your system environment
# (it replaces /etc/nixos/configuration.nix)
{
  stateVersion,
  hostname,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    ./disko.nix

    # You can also split up your configuration and import pieces of it here:
    ./modules

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import important packages
    ./nixpkgs-config.nix

    ../../home
  ];

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  cudaSupport = true;
  };

  networking.hostName = hostname;

  system.stateVersion = stateVersion;

  ##########################################

  # # for situation, where Hyprland doesnt work, uncomment whis, and use GNOME
  #
  # # Default browser
  # programs.firefox.enable = true;
  #
  # # Enable the X11 windowing system.
  # services.xserver.enable = true;
  #
  # # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  #
  # # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };
  #
  # # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = false;
  # services.displayManager.autoLogin.user = "user";

  ##############################################
}
