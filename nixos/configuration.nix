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
    # You can also split up your configuration and import pieces of it here:
    ./modules

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import important packages
    ./nixpkgs-config.nix
  ];

  networking.hostName = hostname;

  system.stateVersion = stateVersion;
}
