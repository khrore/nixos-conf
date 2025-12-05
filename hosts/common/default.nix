{
  stateVersion,
  hostname,
  hostConfig,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # You can also split up your configuration and import pieces of it here:
    ./modules

    # Import important packages
    ./nixpkgs-config.nix

    ../../home
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;

  system.stateVersion = stateVersion;
}
