{
  # Homebrew for macOS-native apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstall unlisted packages
      upgrade = true;
    };

    # CLI tools not available or better via Homebrew
    brews = [
      # Add any Mac-specific brews here if needed
    ];

    # GUI applications
    casks = [
      # Optional: macOS-native apps that aren't in nixpkgs
      # or are better installed via Homebrew
      # Examples:
      "localsend"
      "zen@twilight"
      # "raycast"
      # "karabiner-elements"
      # "rectangle"
    ];

    # Mac App Store apps (requires mas-cli)
    masApps = {
      # "Xcode" = 497799835;
    };
  };
}
