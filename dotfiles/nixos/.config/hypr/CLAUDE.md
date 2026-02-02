# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hyprland configuration directory, part of a dotfiles repository. Hyprland is a dynamic tiling Wayland compositor. This configuration uses a modular approach with split configuration files for better organization.

## Configuration Architecture

The configuration follows a modular structure where `hyprland.conf` acts as the main entry point that sources all other configuration modules:

1. **Main Entry Point**: `hyprland.conf`
   - Sources theme file first (currently `themes/mocha.conf`)
   - Then sources all modular configuration files from `hyprland/` directory

2. **Modular Configuration Files** (`hyprland/` directory):
   - `general.conf` - General settings, border colors, gaps, and misc options
   - `input.conf` - Input device settings (keyboard layouts, mouse acceleration, cursor behavior)
   - `bind.conf` - All keybindings and application variables ($terminal, $browser, etc.)
   - `visual.conf` - Animations, decorations, blur, rounding, and layout settings
   - `env.conf` - Environment variables, autostart programs (exec-once)
   - `rules.conf` - Monitor configuration and window rules

3. **Related Configuration Files**:
   - `hypridle.conf` - Idle management (locks screen after 900 seconds)
   - `hyprlock.conf` - Lock screen appearance and configuration
   - `hyprpaper.conf` - Wallpaper settings

4. **Theme System**:
   - Centralized theme directory: `~/.config/themes/gruvbox/`
   - Currently active theme: Gruvbox Dark
   - Theme sourced from: `~/.config/themes/gruvbox/hyprland.conf`
   - Theme colors are referenced using `$` variables (e.g., `$orange`, `$bg1`, `$blue`, `$red`)
   - Gruvbox color palette includes: background shades ($bg0-$bg4), foreground shades ($fg0-$fg4),
     bright colors ($red, $green, $yellow, $blue, $purple, $aqua, $orange), and neutral variants

## Key Configuration Details

### Application Variables
Defined in `hyprland/bind.conf`:
- `$terminal` - ghostty
- `$browser` - zen
- `$editor` - terminal + nvim
- `$fileManager` - terminal + yazi
- `$mainMod` - SUPER key

### Keyboard Layouts
US and Russian layouts with `grp:caps_toggle` (Caps Lock switches layouts)

### Important Keybindings
- SUPER+Q - Kill active window
- SUPER+Delete - Exit Hyprland
- SUPER+T/E/B - Open terminal/file manager/browser
- SUPER+F - Launch rofi
- SUPER+V - Clipboard manager (clipse)
- SUPER+ALT+L - Lock screen
- SUPER+CTRL+L - Logout menu (wlogout)
- SUPER+H/J/K/L - Vim-style navigation
- SUPER+SHIFT+H/J/K/L - Swap windows
- SUPER+CTRL+H/J/K/L - Resize windows
- ALT+Return - Fullscreen toggle

### Autostart Programs
Defined in `env.conf` with `exec-once`:
- waybar (status bar)
- hypridle (idle management)
- clipse (clipboard manager)
- hyprpolkitagent (authentication agent)
- dunst (notifications)
- sing-box (VPN)

## Testing and Reload

To reload the configuration:
```bash
hyprctl reload
```

To test keybindings without reloading:
```bash
# List all keybindings
hyprctl binds

# Test a specific dispatcher
hyprctl dispatch <dispatcher> <args>
```

## Common Modifications

When modifying this configuration:
- **Changing theme**: Edit the first line in `hyprland.conf` to source `~/.config/themes/<theme-name>/hyprland.conf`
- **Adding keybindings**: Edit `hyprland/bind.conf`
- **Modifying appearance**: Edit `hyprland/visual.conf` (animations, blur, rounding)
- **Changing gaps/borders**: Edit `hyprland/general.conf`
- **Adding startup programs**: Add `exec-once` lines to `hyprland/env.conf`
- **Adjusting keyboard/mouse**: Edit `hyprland/input.conf`
- **Monitor configuration**: Edit `hyprland/rules.conf`

## Color Variable System

The Gruvbox theme file defines color variables in both `rgb()` and alpha formats. When using colors in configuration:
- For border colors, use: `$colorname` (e.g., `$orange`, `$blue`)
- For alpha values in labels/text, use: `##$colornameAlpha` (e.g., `##$blueAlpha`, `##$orangeAlpha`)
- Main accent color: `$orange` (#fe8019)
- Background shades: `$bg0` (darkest) through `$bg4` (lightest)
- Foreground shades: `$fg0` (brightest) through `$fg4` (dimmest)
