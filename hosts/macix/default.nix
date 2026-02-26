{
  pkgs,
  stateVersion,
  hostname,
  username,
  inputs,
  ...
}:
let
  secretsMeta = import (inputs.secrets + "/secrets.nix");
in
{
  # Import common configuration
  imports = [
    ../common/default.nix
    ./homebrew.nix
  ];

  # Hostname
  networking = {
    hostName = hostname;
    computerName = hostname;
    localHostName = hostname;
  };

  system = {
    # Basic nix-darwin settings
    stateVersion = 5; # nix-darwin uses different versioning

    # Set primary user (required for homebrew and system defaults)
    primaryUser = username;

    # System defaults (macOS-specific settings)
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
    };
  };

  # Enable Touch ID for sudo (updated option name)
  security.pam.services.sudo_local.touchIdAuth = true;

  # User configuration
  users.users.${username} = {
    home = "/Users/${username}";
    # openssh.authorizedKeys.keys = secretsMeta."keys/macix_ssh_key.age".publicKeys;
  };

  # Allow SSH access to macix via public key auth.
  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      PermitRootLogin no
      PubkeyAuthentication yes
    '';
  };

  # Enable shells
  programs.fish.enable = true;
  programs.zsh.enable = true;
}
