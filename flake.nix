{
  description = "System configuration by khrore";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    # will be appended to the system-level substituters
    extra-substituters = [
      # nix community's cache server
      "https://nix-community.cachix.org"
    ];

    # will be appended to the system-level trusted-public-keys
    extra-trusted-public-keys = [
      # nix community's cache server public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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

      # importing library
      mylib = import ./lib/default.nix { inherit (pkgs-unstable) lib; };

      ######################### USER LEVEL ##########################

      # Configuration for user settings
      username = "user";
      terminalEditor = "nvim";
      shell = "nushell";

      # System configuration
      hostname = "nixos"; # CHOOSE A HOSTNAME HERE
      # locale = "en_US.UTF-8"; # CHOOSE YOUR LOCALE (for now do nothing)
      # timezone = "Europe/Moscow"; # CHOOSE YOUR TIMEZONE (for now do nothing)

      configurationLimit = 10;

      #################################################################
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./nixos/configuration.nix
        ];

        specialArgs = {
          inherit
            inputs
            outputs
            username
            terminalEditor
            hostname
            stateVersion
            system
            configurationLimit
            shell
            pkgs-unstable
            mylib
            ;
        };
      };
    };
}
