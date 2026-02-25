# AGENTS.md - Project Memory Map (nixos)

This file captures repository-specific structure and definition intent so coding agents can orient quickly before making changes.

## Purpose

- Repository type: multi-host Nix flake (`nixos` + `nix-darwin`) with shared Home Manager layer.
- Main goal: keep host definitions composable while reusing common modules and user package bundles.
- Priority: preserve evaluation stability and minimize cross-host regressions.

## Top-Level Layout

- `flake.nix`: canonical entrypoint (inputs, outputs, host wiring, shared `specialArgs`).
- `flake.lock`: pinned input revisions.
- `hosts/`: host-level and common system modules.
- `home/`: Home Manager config and package bundles shared across platforms.
- `lib/`: helper library (`scanPaths`, platform predicates, dotfile helpers).
- `dotfiles/`: source files symlinked into `$HOME` by Home Manager activation logic.

## Flake Definitions

- NixOS hosts:
- `dev-4` -> `./hosts/dev-4`
- `nixos` -> `./hosts/nixos`
- Darwin host:
- `macix` -> `./hosts/macix`

Shared `specialArgs` passed to modules include:

- `hostname`, `username`, `system`
- `inputs`, `outputs`
- `stateVersion`, `shell`, `terminalEditor`, `configurationLimit`
- `mylib` (from `lib/default.nix`)
- `pkgs-unstable` (imported per-system from `inputs.nixpkgs-unstable`)

## System Module Composition

- `hosts/<host>/default.nix` is the host entrypoint.
- Each host imports `../common/default.nix`.
- `hosts/common/default.nix` imports:
- `./modules`
- `./nixpkgs-config.nix`
- `../../home`
- `hosts/common/modules/default.nix` conditionally imports:
- `./shared` on all platforms
- `./nixos` only on Linux
- `./darwin` only on macOS

Platform guard helpers come from `mylib`:

- `mylib.isLinux system`
- `mylib.isDarwin system`

## Home Manager Structure

- Entry: `home/default.nix`
- Linux-only user account/default shell setup is defined here via `lib.optionalAttrs`.
- Home Manager user config imports:
- `home/pkgs/*` (auto-scanned via `mylib.scanPaths`)
- `home/link-dotfiles.nix`

Package bundles in `home/pkgs/` are grouped by concern:

- `ai.nix`, `gui.nix`, `lang.nix`, `shell.nix`, `tui.nix`, `utils.nix`

## Dotfiles Definition

- `home/link-dotfiles.nix` defines:
- `link-dotfiles` helper script package
- activation hook `home.activation.linkDotfiles`
- Current runtime source root is hardcoded as `$HOME/nixos/dotfiles`.
- Precedence behavior: platform-specific files override `common` by relative path.

## Library Helpers

`lib/default.nix` provides:

- `scanPaths <dir>`: collect `.nix` files and directories except `default.nix`.
- `scanFiles <dir>`: recursive file map, skipping `.gitkeep`.
- `linkDotfiles { baseDir, platform }`: compute merged dotfile targets.
- `isLinux` / `isDarwin`: system string predicates.

## Known Structural Risks

- Username values differ by host in `flake.nix`; verify intentionality before changes.
- Some inputs appear partially wired (example: imported-but-unused metadata in host modules).
- README is minimal; rely on this file + `flake.nix` for operational context.
- Dotfiles linking assumes checkout path in `$HOME/nixos`; portability is limited.

## Validation Baseline

Run the smallest relevant checks after edits:

1. `nix flake check` (if available in environment)
2. Targeted eval/build for touched host:
3. `nixos-rebuild build --flake .#dev-4` (Linux host changes)
4. `darwin-rebuild build --flake .#macix` (Darwin host changes)

If a command is unavailable, report it and state resulting risk.

## Editing Guardrails

- Keep changes scoped; avoid unrelated host/module churn.
- Preserve platform guards around Linux/Darwin-only options.
- Prefer updating shared modules only when behavior is truly cross-host.
- Do not introduce secrets into tracked files or logs.
