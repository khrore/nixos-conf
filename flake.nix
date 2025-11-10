{
  description = "System configuration by khrore";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      stateVersion = "25.05";

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };

      pkgs = import inputs.nixpkgs {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        };
      };

      # importing library
      mylib = import ./lib/default.nix { inherit (pkgs-unstable) lib; };

      ######################### USER LEVEL ##########################

      # Configuration for user settings
      username = "khrore";
      terminalEditor = "nvim";
      shell = "fish";

      configurationLimit = 10;

      #################################################################
    in
    {
      nixpkgs.pkgs = pkgs;
      nixosConfigurations = {
    "oldix" = let hostname = "oldix";
          in nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/oldix
          inputs.disko.nixosModules.disko
        ];

        specialArgs = {
          inherit
      hostname
            pkgs-unstable
            inputs
            outputs
            username
            terminalEditor
            stateVersion
            system
            configurationLimit
            shell
            mylib
            ;
        };
      };
      "nixos" = let hostname = "nixos";
        in nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/nixos
          inputs.disko.nixosModules.disko
        ];

        specialArgs = {
          inherit
      hostname
            pkgs-unstable
            inputs
            outputs
            username
            terminalEditor
            stateVersion
            system
            configurationLimit
            shell
            mylib
            ;
        };
      };
    };
    };
}
