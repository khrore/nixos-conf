# Plan: linkDotfiles — declarative symlink management via home.file

## Goal

Add a `linkDotfiles` function to `mylib` that scans a `dotfiles/` directory tree
(mirroring the existing `hosts/` pattern of `common/` + per-hostname dirs),
merges files with host overrides winning, and returns an attrset for `home.file`.

## Files to modify

- `lib/default.nix` — add `scanFiles` + `linkDotfiles`
- `home/default.nix` — destructure `hostname`, add it to `extraSpecialArgs`, wire `home.file`

## Files to create

- `dotfiles/common/.gitkeep`
- `dotfiles/oldix/.gitkeep`
- `dotfiles/nixos/.gitkeep`
- `dotfiles/macix/.gitkeep`

---

## 1. lib/default.nix — add two functions

Add after `isLinux`:

```nix
  # Recursively walk a directory tree, returning { "rel/path" = /abs/nix/path; ... }
  # Skips .gitkeep. Returns {} if dir does not exist.
  scanFiles =
    let
      go =
        prefix: dir:
        let
          entries = builtins.readDir dir;
          names = builtins.attrNames entries;
        in
        builtins.foldl' (
          acc: name:
          let
            type = entries.${name};
            full = dir + "/${name}";
            rel = if prefix == "" then name else "${prefix}/${name}";
          in
          if name == ".gitkeep" then acc
          else if type == "directory" then acc // (go rel full)
          else if type == "regular" then acc // { "${rel}" = full; }
          else acc
        ) { } names;
    in
    dir:
    if builtins.pathExists dir then go "" dir else { };

  # Merge common/ and <hostname>/ under baseDir. Host files override common.
  # Returns attrset ready for direct assignment to home.file.
  linkDotfiles =
    { baseDir, hostname }:
    let
      common = scanFiles (baseDir + "/common");
      host = scanFiles (baseDir + "/${hostname}");
      merged = common // host;
    in
    lib.mapAttrs (_: src: { source = src; }) merged;
```

Key notes:
- `lib.mapAttrs` not `builtins.mapAttrs` — the latter doesn't exist. `lib` here is `nixpkgs.lib`, available in scope.
- `builtins.foldl'` is strict (avoids thunk buildup).
- `//` is right-biased: host entries override common on key collision.
- `builtins.pathExists` guards against missing common/ or missing hostname/ dir.

## 2. home/default.nix — wire it up

Two changes:
1. Add `hostname` to the function's destructured args
2. Add `hostname` to `extraSpecialArgs`
3. Add `home.file = mylib.linkDotfiles { ... }` in the user block

```nix
# Add hostname to destructuring:
{
  lib,
  mylib,
  username,
  hostname,        # ← ADD
  pkgs-unstable,
  ...
}:

# Add hostname to extraSpecialArgs inherit block:
      extraSpecialArgs = {
        inherit
          pkgs-unstable
          inputs
          username
          hostname       # ← ADD
          shell
          mylib
          system
          ;
      };

# Add home.file in users.${username}:
        home.file = mylib.linkDotfiles {
          baseDir = ../dotfiles;
          inherit hostname;
        };
```

Path `../dotfiles` is relative to `home/default.nix` → resolves to repo root `dotfiles/`.

## 3. Directory structure

```
dotfiles/
├── common/       # shared across all hosts
│   └── .gitkeep
├── oldix/        # oldix overrides (created on demand)
│   └── .gitkeep
├── nixos/        # nixos overrides
│   └── .gitkeep
└── macix/        # macix overrides
    └── .gitkeep
```

Usage example after populating:
```
dotfiles/common/.config/starship.toml     → linked on ALL hosts
dotfiles/nixos/.config/starship.toml      → overrides common version on nixos only
```

## Verification

```bash
# 1. Eval check (no build) — dumps the resolved home.file attrset:
nix eval .#nixosConfigurations.nixos.config.home-manager.users.khorer.home.file --json

# 2. Full flake check:
nix flake check

# 3. Build without switching:
nixos-rebuild build --flake .#nixos
```
