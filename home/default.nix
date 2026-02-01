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
        };

        home.activation.linkDotfiles =
          let
            entries = mylib.linkDotfiles {
              baseDir = ../dotfiles;
              inherit hostname;
            };
          in
          {
            after = [ "writeBoundary" ];
            before = [ ];
            data = lib.concatMapStrings (entry: ''
              mkdir -p "$HOME/$(dirname '${entry.target}')"
              ln -sf "$HOME/nixos/dotfiles/${entry.subdir}/${entry.target}" "$HOME/${entry.target}"
            '') entries;
          };

        imports = mylib.scanPaths ./pkgs;

        programs.home-manager.enable = true;
      };
    };
  }
]
