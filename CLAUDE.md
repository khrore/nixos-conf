# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a cross-platform Nix flake configuration managing NixOS systems (oldix, nixos) and macOS systems (macix) with shared home-manager configuration. The repository uses platform detection and auto-loading patterns via `mylib.scanPaths` to eliminate manual imports while supporting both Linux and macOS.

## Common Build and Development Commands

### NixOS (Linux)

```bash
# Build and switch to new configuration (requires sudo)
sudo nixos-rebuild switch --flake .#<hostname>

# Build and test without switching
nixos-rebuild build --flake .#<hostname>

# Show configuration differences before switching
nixos-rebuild build --flake .#<hostname> && nix store diff-closures /run/current-system ./result
```

Replace `<hostname>` with `oldix` or `nixos`.

### macOS (Darwin)

```bash
# Initial activation (first time only)
nix run nix-darwin -- switch --flake .#macix

# Subsequent rebuilds
darwin-rebuild switch --flake .#macix

# Build without switching
nix build .#darwinConfigurations.macix.system
```

### Universal Commands

```bash
# Update flake inputs to latest versions
nix flake update

# Check flake configuration for errors
nix flake check

# Evaluate darwin configuration
nix eval .#darwinConfigurations.macix.system --apply 'x: "success"'

# Evaluate NixOS configuration
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel
```

### Formatting and Linting

```bash
# Format all Nix files
nixfmt **/*.nix

# Check for Nix anti-patterns
statix check

# Fix Nix anti-patterns automatically
statix fix
```

## Architecture and Code Organization

### Directory Structure

```
├── flake.nix                 # Entry point - multi-platform configs
├── lib/default.nix           # Custom library (scanPaths, isDarwin, isLinux)
├── hosts/
│   ├── common/              # Shared cross-platform configuration
│   │   ├── default.nix      # Platform-aware common config
│   │   ├── nixpkgs-config.nix  # Cachix binary cache setup
│   │   └── modules/         # Platform-specific and shared modules
│   │       ├── nixos/       # Linux-only modules (boot, audio, hyprland, etc.)
│   │       ├── darwin/      # macOS-only modules (currently empty)
│   │       ├── shared/      # Cross-platform modules (nix, timezone)
│   │       └── default.nix  # Conditional platform loading
│   ├── oldix/               # Intel NixOS host (SATA storage)
│   ├── nixos/               # AMD/NVIDIA NixOS host (NVMe, CUDA)
│   └── macix/               # Apple Silicon macOS host (M1/M2/M3)
└── home/                    # User-level home-manager configuration
    ├── default.nix          # Platform-aware user setup
    ├── programs.nix         # System programs (NixOS only)
    └── pkgs/                # Categorized packages with platform filtering
```

### Cross-Platform Architecture

The configuration supports both NixOS and nix-darwin through:

1. **Platform Detection** (`lib/default.nix`):
   - `mylib.isDarwin system` - Checks if running on macOS
   - `mylib.isLinux system` - Checks if running on Linux

2. **Conditional Module Loading** (`hosts/common/modules/default.nix`):
   ```nix
   imports = [
     ./shared  # Always loaded
   ] ++ (if mylib.isLinux system then [ ./nixos ] else [])
     ++ (if mylib.isDarwin system then [ ./darwin ] else []);
   ```

3. **Home-Manager Integration**:
   - Shared user environment across all platforms
   - Packages filtered by platform using `lib.optionals`
   - Different home directories: `/home/${username}` (Linux) vs `/Users/${username}` (macOS)

### Auto-Loading Module Pattern

Uses `mylib.scanPaths` to automatically import all `.nix` files in a directory (except `default.nix`).

**When adding new functionality:**
- **Linux-only features**: Create in `hosts/common/modules/nixos/` - auto-loaded on Linux
- **macOS-only features**: Create in `hosts/common/modules/darwin/` - auto-loaded on macOS
- **Cross-platform features**: Create in `hosts/common/modules/shared/` - auto-loaded everywhere
- **User packages**: Add to appropriate category in `home/pkgs/` with platform filtering
- **Host-specific config**: Add directly to `hosts/{hostname}/`

### Package Organization with Platform Filtering

All package files in `home/pkgs/` use platform filtering:

- **gui.nix**: Desktop applications
  - Cross-platform: firefox, chromium, kitty, spotify, mpv, etc.
  - Linux-only: waybar, dunst, rofi, hyprland tools, zen-browser

- **lang.nix**: Development tools (cross-platform except hyprls)
  - LSPs, formatters, linters for Nix, Lua, Python, TypeScript, Bash, etc.
  - Linux-only: hyprls (Hyprland LSP)

- **shell.nix**: Shell utilities (fully cross-platform)
  - eza, fzf, bat, ripgrep, fd, starship, tmux, zoxide, etc.

- **tui.nix**: Terminal UI applications
  - Cross-platform: yazi, neovim, claude-code, spotify-player
  - Linux-only: btop-cuda, gpustat (NVIDIA tools)

- **utils.nix**: General utilities
  - Cross-platform: git tools, ffmpeg, network tools, archives
  - Linux-only: Wayland tools, brightnessctl, Qt/Wayland libs

### Special Arguments Flow

The flake passes these special arguments via `mkSpecialArgs`:
- `pkgs-unstable`: Unstable nixpkgs (used for most packages)
- `inputs`: Access to flake inputs (disko, hyprland, ghostty, zen-browser, yazi, home-manager, darwin)
- `hostname`: Current host identifier (oldix, nixos, or macix)
- `username`: User name (khrore)
- `shell`: Preferred shell (fish)
- `terminalEditor`: Editor choice (nvim)
- `mylib`: Custom library functions (scanPaths, isDarwin, isLinux)
- `system`: Target system (x86_64-linux or aarch64-darwin)
- `stateVersion`: Version (25.11)
- `configurationLimit`: Boot entry limit (10)

When creating new modules, destructure only the arguments you need:
```nix
{ lib, pkgs-unstable, mylib, system, ... }: {
  # Use lib.optionals for platform filtering
  home.packages = lib.optionals (mylib.isLinux system) [
    # Linux-specific packages
  ] ++ [
    # Cross-platform packages
  ];
}
```

### Platform-Specific Modules

**NixOS-only** (`hosts/common/modules/nixos/`):
- `audio.nix` - Pipewire audio stack
- `boot.nix` - Systemd-boot with UEFI
- `fonts.nix` - JetBrains Mono Nerd Font (macOS uses system fonts)
- `hyprland.nix` - Wayland compositor with UWSM
- `location.nix` - i18n locale settings
- `nix-ld.nix` - Linux dynamic linker
- `services.nix` - Docker, SSH, udisks2

**macOS-only** (`hosts/common/modules/darwin/`):
- Currently empty, ready for future macOS-specific modules (e.g., yabai, skhd)

**Cross-platform** (`hosts/common/modules/shared/`):
- `nix.nix` - Flakes and nix-command experimental features
- `timezone.nix` - Europe/Moscow timezone

### Dual Nixpkgs Strategy

- **Stable** (`nixpkgs`) - System-level components
- **Unstable** (`nixpkgs-unstable`) - User packages and development tools
- Both darwin and home-manager follow unstable for latest features
- Per-system pkgs instantiation via `mkPkgs` and `mkPkgsUnstable` functions

## Platform-Specific Notes

### macOS (Darwin) Configuration

- **Primary User**: Set via `system.primaryUser` (required for homebrew and system defaults)
- **Touch ID**: `security.pam.services.sudo_local.touchIdAuth = true`
- **Homebrew**: Configured in `hosts/macix/homebrew.nix` for macOS-native apps
- **System Defaults**: Dock, Finder, keyboard settings in `hosts/macix/default.nix`
- **Fonts**: Uses macOS system fonts (no custom font configuration)
- **State Version**: Uses `5` (nix-darwin versioning, different from NixOS)

### NixOS Configuration

- **User Creation**: Managed in `home/default.nix` with Linux conditional
- **Groups**: wheel (sudo), networkmanager, docker
- **Hardware Config**: Auto-generated, regenerate with `nixos-generate-config`
- **Disko**: Declarative disk layouts (SATA for oldix, NVMe for nixos)
- **NVIDIA** (nixos host): CUDA support with open-source driver

## Important Notes

### Adding Cross-Platform Packages

1. Add to appropriate `home/pkgs/*.nix` file
2. Use platform filtering if needed:
   ```nix
   let
     linuxPkgs = lib.optionals (mylib.isLinux system) [ ... ];
     darwinPkgs = lib.optionals (mylib.isDarwin system) [ ... ];
     sharedPkgs = [ ... ];
   in
   { home.packages = sharedPkgs ++ linuxPkgs ++ darwinPkgs; }
   ```

### Verifying Platform Compatibility

Check if a package supports your target platform:
```nix
# Use conditional loading for platform-specific inputs
lib.optionals (builtins.hasAttr system inputs.package.packages) [
  inputs.package.packages.${system}.default
]
```

### Home-Manager vs System Packages

- **Use home-manager** (`home.packages`) for user-level packages
- **Use system packages** (`environment.systemPackages`) sparingly for NixOS-only system tools
- Home-manager provides cross-platform compatibility

### Dotfiles Management

The configuration uses home-manager for packages but dotfiles are managed separately:
- GNU Stow is installed for manual dotfile symlinking
- Store dotfiles in a separate git repository
- Use stow to symlink dotfiles to home directory
- Future: Can use home-manager's file management if desired

### Binary Caches

Configured in `hosts/common/nixpkgs-config.nix`:
- hyprland.cachix.org
- nix-community.cachix.org

### Host Overview

| Host | Platform | CPU | GPU | Storage | Special Features |
|------|----------|-----|-----|---------|------------------|
| oldix | NixOS | Intel | - | SATA (sda) | - |
| nixos | NixOS | AMD | NVIDIA | NVMe | CUDA support |
| macix | Darwin | Apple Silicon | - | - | Touch ID, Homebrew |

### Common Pitfalls

1. **Forgetting platform conditionals**: Always check if a module/package is Linux-specific before adding
2. **Using wrong state version**: NixOS uses "25.11", nix-darwin uses `5`
3. **Not setting system.primaryUser**: Required on macOS for homebrew and system defaults
4. **Editing hardware-configuration.nix**: This file is auto-generated, don't manually edit
5. **Missing lib parameter**: When using `lib.optionals`, ensure `lib` is in function arguments
