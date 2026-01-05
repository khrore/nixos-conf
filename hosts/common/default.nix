{
  lib,
  stateVersion,
  hostname,
  system,
  mylib,
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

  # NixOS-specific networking configuration
  networking = lib.mkIf (mylib.isLinux system) {
    hostName = hostname;
  };

  # System state version (different for NixOS vs darwin)
  system.stateVersion =
    if mylib.isDarwin system then
      5 # nix-darwin uses different versioning
    else
      stateVersion;
}
