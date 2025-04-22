{
  description = "System configuration by KOTOWARU";

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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    catppuccin.url = "github:catppuccin/nix";

    # Home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ########################## NONE FLAKE ##########################

    # Themes for yazi
    catppuccin-yazi = {
      url = "github:catppuccin/yazi";
      flake = false;
    };

    # Themes for bat
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    # Theme for btop
    catppuccin-btop = {
      url = "github:catppuccin/btop";
      flake = false;
    };

    catppuccin-kitty = {
      url = "github:catppuccin/kitty";
      flake = false;
    };

    catppuccin-hyprland = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };

    catppuccin-fish = {
      url = "github:catppuccin/fish";
      flake = false;
    };

    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };

    catppuccin-tmux = {
      url = "github:catppuccin/tmux";
      flake = false;
    };

    #################################################################
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "x86_64-linux"
      ];
      # Personaly dont tested for i686, aarch64 and for darwon

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };

      # importing library
      mylib = import ./lib/default.nix { inherit (pkgs-unstable) lib; };

      ######################### USER LEVEL ##########################

      # Configuration for user settings
      # TODO: make functionality of variables
      username = "user";
      terminal = "ghostty";
      terminalFileManager = "yazi";
      terminalEditor = "nvim";
      browser = "firefox";
      shell = "fish"; # fish, bash or zsh (nushell dont contained in base NixOS)

      wallpaper = "~/.config/hypr/assets/nixos-bg-fhd.jpg"; # see assets

      # System configuration
      hostname = "nixos"; # CHOOSE A HOSTNAME HERE
      # locale = "en_US.UTF-8"; # CHOOSE YOUR LOCALE (for now do nothing)
      # timezone = "Europe/Moscow"; # CHOOSE YOUR TIMEZONE (for now do nothing)
      kbdLayout = "us, ru"; # CHOOSE YOUR KEYBOARD LAYOUT (for now do nothing)

      system = "x86_64-linux";
      stateVersion = "24.11";
      # stateVersion = "25.05";

      configurationLimit = 10;

      #################################################################
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      # TODO: make no duplicate on special args for system and home-manager
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
          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituters` in `flake.nix`
            nix.settings.trusted-users = [ "user" ];

            # the system-level substituters & trusted-public-keys
            nix.settings = {
              substituters = [
                "https://cache.nixos.org"
              ];

              trusted-public-keys = [
                # the default public key of cache.nixos.org, it's built-in, no need to add it here
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.${username}.imports = [
                ./home.nix
                catppuccin.homeModules.catppuccin
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
                  ;
              };
            };
          }
        ];
      };
    };
}
