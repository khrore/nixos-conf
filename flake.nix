{
  description = "System configuration by khrore";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # nix-darwin for macOS
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # home-manager for user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
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
      darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # System architectures
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      stateVersion = "25.11";

      # Helper to create pkgs for a system
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            nvidia.acceptLicense = true;
          };
        };

      mkPkgsUnstable =
        system:
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      # importing library
      mylib = import ./lib/default.nix { inherit (nixpkgs) lib; };

      ######################### USER LEVEL ##########################

      # Configuration for user settings
      username = "khorer";
      terminalEditor = "nvim";
      shell = "fish";

      configurationLimit = 10;

      #################################################################

      # Common special args factory
      mkSpecialArgs =
        { hostname, system }:
        {
          inherit
            hostname
            system
            inputs
            outputs
            username
            terminalEditor
            stateVersion
            configurationLimit
            shell
            mylib
            ;
          pkgs-unstable = mkPkgsUnstable system;
        };
    in
    {
      nixpkgs.pkgs = mkPkgs linuxSystem;

      # NixOS configurations
      nixosConfigurations = {
        "oldix" = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./hosts/oldix
            inputs.disko.nixosModules.disko
            home-manager.nixosModules.home-manager
          ];
          specialArgs = mkSpecialArgs {
            hostname = "oldix";
            system = linuxSystem;
          };
        };

        "nixos" = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./hosts/nixos
            inputs.disko.nixosModules.disko
            home-manager.nixosModules.home-manager
          ];
          specialArgs = mkSpecialArgs {
            hostname = "nixos";
            system = linuxSystem;
          };
        };
      };

      # Darwin configurations
      darwinConfigurations = {
        "macix" = darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [
            ./hosts/macix
            home-manager.darwinModules.home-manager
          ];
          specialArgs = mkSpecialArgs {
            hostname = "macix";
            system = darwinSystem;
          };
        };
      };
    };
}
