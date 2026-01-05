# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based system configuration managing multiple hosts (oldix, nixos) with shared modules and user-level home configuration. The repository uses a custom auto-loading pattern via `mylib.scanPaths` to eliminate manual imports.

## Common Build and Development Commands

### Building and Switching Configurations

```bash
# Build and switch to new configuration (requires sudo)
sudo nixos-rebuild switch --flake .#<hostname>

# Build and test without switching (no sudo needed)
nixos-rebuild build --flake .#<hostname>

# Update flake inputs to latest versions
nix flake update

# Check flake configuration for errors
nix flake check

# Show configuration differences before switching
nixos-rebuild build --flake .#<hostname> && nix store diff-closures /run/current-system ./result
```

Replace `<hostname>` with either `oldix` or `nixos` depending on the target system.

### Formatting and Linting

```bash
# Format all Nix files
nixfmt **/*.nix

# Check for Nix anti-patterns
statix check

# Fix Nix anti-patterns automatically
statix fix
```

### Development Workflow

```bash
# Enter development shell with all dependencies
nix develop

# Evaluate specific configuration options
nix eval .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Show what packages would be installed
nix eval .#nixosConfigurations.<hostname>.config.environment.systemPackages --apply builtins.length
```

## Architecture and Code Organization

### Directory Structure

```
├── flake.nix                 # Entry point - defines hosts and special arguments
├── lib/default.nix           # Custom library with scanPaths auto-loader
├── hosts/
│   ├── common/              # Shared system configuration
│   │   ├── default.nix      # Imports all common modules
│   │   ├── nixpkgs-config.nix  # Cachix binary cache setup
│   │   └── modules/         # Individual system feature modules
│   ├── oldix/               # Intel-based host (SATA storage)
│   └── nixos/               # AMD/NVIDIA host (NVMe storage, CUDA)
└── home/                    # User-level configuration
    ├── default.nix          # User setup and group membership
    ├── programs.nix         # System programs (shells, etc.)
    └── pkgs/                # Categorized package lists
```

### Auto-Loading Module Pattern

This configuration uses a custom `mylib.scanPaths` function that automatically imports all `.nix` files in a directory (except `default.nix`). Any directory with `imports = mylib.scanPaths ./.;` will auto-discover and load all modules.

**When adding new functionality:**
- System features: Create a new `.nix` file in `hosts/common/modules/` - it will be auto-loaded
- User packages: Add to the appropriate category in `home/pkgs/` (gui.nix, lang.nix, shell.nix, tui.nix, utils.nix)
- Host-specific config: Add directly to `hosts/{hostname}/`

### Package Organization Categories

- **gui.nix**: Desktop applications (browsers, terminals, media players)
- **lang.nix**: Development tools (LSPs, formatters, linters, build tools)
- **shell.nix**: Shell utilities (modern CLI replacements, enhancements)
- **tui.nix**: Terminal UI applications (editors, file managers, monitoring)
- **utils.nix**: General utilities (git, network tools, archives, media tools)

### Special Arguments Flow

The flake passes these special arguments to all modules:
- `pkgs`: Stable nixpkgs (nixos-25.11)
- `pkgs-unstable`: Unstable channel for latest packages
- `inputs`: Access to flake inputs (disko, hyprland, ghostty, zen-browser, yazi)
- `hostname`: Current host identifier
- `username`: User name (khrore)
- `shell`: Preferred shell (fish)
- `terminalEditor`: Editor choice (nvim)
- `mylib`: Custom library functions (scanPaths)
- `stateVersion`: NixOS state version (25.11)
- `configurationLimit`: Boot entry limit (10)

When creating new modules, destructure only the arguments you need:
```nix
{ pkgs, pkgs-unstable, ... }: {
  # your configuration
}
```

### Host Configuration Pattern

Both hosts share ~90% configuration through `hosts/common/`. Host-specific differences are isolated to:
1. **hardware-configuration.nix** - Auto-generated, do not manually edit
2. **disko.nix** - Disk layout (SATA for oldix, NVMe for nixos)
3. **Host-specific configs** - Optional files like `nixpkgs-config.nix` for CUDA support on nixos

### Dual Nixpkgs Strategy

- Use `pkgs` (stable) for critical system components
- Use `pkgs-unstable` for user packages and development tools
- Most packages prefer unstable for latest features
- Reduces rebuild frequency while staying current

## Key Modules

### System Modules (hosts/common/modules/)
- **audio.nix**: Pipewire audio (no PulseAudio)
- **boot.nix**: Systemd-boot with UEFI
- **fonts.nix**: JetBrains Mono Nerd Font as default monospace
- **hyprland.nix**: Wayland compositor with UWSM and portal support
- **location.nix**: Locale settings (en_US with ru_RU numeric/telephone)
- **nix.nix**: Enables flakes and nix-command experimental features
- **services.nix**: Core system services (Docker, SSH, udisks2)
- **timezone.nix**: Europe/Moscow timezone

### Home Configuration (home/)
User "khrore" is configured with:
- Groups: wheel (sudo), networkmanager, docker
- Shell: fish
- Editor: nvim
- Complete polyglot development environment (10+ languages with LSPs)

## Important Notes

### Hardware Configuration
- Never manually edit `hardware-configuration.nix` - it's auto-generated by nixos-generate-config
- Regenerate with: `sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix`

### Disk Management
- Uses disko for declarative disk layouts
- Each host has its own `disko.nix` with disk-specific paths
- Be cautious when modifying - can affect data integrity

### Adding New Packages
1. Identify the correct category in `home/pkgs/`
2. Add to the appropriate list (preferring `pkgs-unstable` for latest versions)
3. Rebuild to apply changes

### Adding New System Modules
1. Create `hosts/common/modules/feature-name.nix`
2. Define configuration using special arguments as needed
3. Module is auto-loaded via scanPaths - no manual import needed

### Binary Caches
Cachix binary caches are configured in `hosts/common/nixpkgs-config.nix` to speed up builds:
- hyprland.cachix.org
- nix-community.cachix.org

### NVIDIA Configuration (nixos host only)
The nixos host includes CUDA support with:
- Open source NVIDIA driver
- Power management enabled
- Latest kernel packages
- Modesetting enabled

Configuration in `hosts/nixos/nixpkgs-config.nix`
