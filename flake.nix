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
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catppuccin-zen = {
      url = "github:catppuccin/zen-browser";
      flake = false;
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
      terminal = "ghostty";
      terminalFileManager = "yazi";
      terminalEditor = "nvim";
      browser = "zen";
      shell = "nushell";

      wallpaper = "~/.config/hypr/assets/nixos-bg-fhd.jpg"; # see assets

      # System configuration
      hostname = "nixos"; # CHOOSE A HOSTNAME HERE
      # locale = "en_US.UTF-8"; # CHOOSE YOUR LOCALE (for now do nothing)
      # timezone = "Europe/Moscow"; # CHOOSE YOUR TIMEZONE (for now do nothing)
      kbdLayout = "us, ru"; # CHOOSE YOUR KEYBOARD LAYOUT (for now do nothing)

      system = "x86_64-linux";
      # stateVersion = "24.11";
      stateVersion = "25.05";

      configurationLimit = 10;

      catppuccin = {
        flavor = "mocha";
        accent = "blue";
      };

      #################################################################
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            outputs
            username
            terminal
            terminalFileManager
            terminalEditor
            browser
            hostname
            stateVersion
            system
            configurationLimit
            shell
            pkgs-unstable
            wallpaper
            mylib
            ;
        };
        modules = [
          # > Our main nixos configuration file <
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = [
                inputs.catppuccin.homeModules.catppuccin
                ./home.nix
              ];

              extraSpecialArgs = {
                inherit
                  browser
                  kbdLayout
                  inputs
                  outputs
                  username
                  terminal
                  terminalFileManager
                  terminalEditor
                  hostname
                  stateVersion
                  system
                  shell
                  pkgs-unstable
                  wallpaper
                  mylib
                  catppuccin
                  ;
              };
            };
          }
        ];
      };
    };
}
