{
  lib,
  stateVersion,
  hostname,
  username,
  system,
  mylib,
  ...
}:
let
  userHome = if mylib.isDarwin system then "/Users/${username}" else "/home/${username}";
in
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

  networking = lib.mkIf (mylib.isLinux system) {
    hostName = hostname;
  };

  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  age.identityPaths = [
    # Generate manually via `sudo ssh-keygen -A`
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets.atuin_key = {
    owner = username;
    path = "${userHome}/.local/share/atuin/shared_key";
  };

  services.openssh = {
    enable = true;
  };

  system.stateVersion =
    if mylib.isDarwin system then
      5 # nix-darwin uses different versioning
    else
      stateVersion;
}
