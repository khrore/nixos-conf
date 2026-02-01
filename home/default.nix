{
  lib,
  mylib,
  username,
  hostname,
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
          hostname
          shell
          mylib
          system
          ;
      };

      users.${username} = {
        home = {
          inherit stateVersion;
          inherit username;
          homeDirectory = if mylib.isDarwin system then "/Users/${username}" else "/home/${username}";
          file = mylib.linkDotfiles {
            baseDir = ../dotfiles;
            inherit hostname;
          };
        };
        imports = mylib.scanPaths ./pkgs;

        programs.home-manager.enable = true;
      };
    };
  }
]
