{
  description = "System configuration by khrore";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    yazi.url = "github:sxyazi/yazi";
    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
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
