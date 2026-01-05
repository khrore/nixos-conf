{
  lib,
  mylib,
  username,
  pkgs-unstable,
  shell,
  system,
  inputs,
  stateVersion,
  ...
}:
lib.mkMerge [
  # NixOS user creation (Linux only)
  (lib.optionalAttrs (mylib.isLinux system) {
    users = {
      defaultUserShell = pkgs-unstable.${shell};
      users.${username} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
      };
    };
  })

  # Home-manager configuration (all platforms)
  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit
          pkgs-unstable
          inputs
          username
          shell
          mylib
          system
          ;
      };

      users.${username} = {
        home.stateVersion = stateVersion;
        home.username = username;
        home.homeDirectory = if mylib.isDarwin system then "/Users/${username}" else "/home/${username}";

        imports = mylib.scanPaths ./pkgs;

        programs.home-manager.enable = true;
      };
    };
  }
]
