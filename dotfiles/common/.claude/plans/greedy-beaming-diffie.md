# Plan: Migrate Dotfiles → NixOS Repo with Hot Reload + Platform Filtering

## Goal

Move `~/.dotfiles/` into `~/nixos/home/dotfiles/`. A single new `home/pkgs/dotfiles.nix`
replaces stow: it declares a `home.activation` script that symlinks configs directly to
the repo on disk. Edits take effect instantly. Platform-specific configs are filtered at
nix eval time — no runtime detection in the activation script.

---

## Architecture

```
BEFORE                                          AFTER
──────                                          ─────
~/.dotfiles/.config/nvim/                       ~/nixos/home/dotfiles/.config/nvim/
  └─ stow ──→ ~/.config/nvim  (symlink)           └─ activation ──→ ~/.config/nvim  (symlink)

~/nixos/  (packages only)                       ~/nixos/home/pkgs/dotfiles.nix  (declares symlinks)
                                                ~/nixos/.gitignore  (runtime files under home/dotfiles/)
```

**No existing `.nix` files change.** `dotfiles.nix` is auto-discovered by
`mylib.scanPaths ./pkgs` in `home/default.nix`.

---

## How Hot Reload Works

1. `nixos-rebuild switch` runs the activation script **once**
2. Script creates symlinks: `~/.config/nvim` → `$HOME/nixos/home/dotfiles/.config/nvim`
3. App reads/writes go directly into the repo — edits take effect **immediately**
4. Adding a **new** config directory needs one rebuild; editing **existing** files needs zero

This is identical to stow's behavior. The only difference is stow required a manual
`stow` command; here nix runs the equivalent automatically on every switch.

---

## Platform Filtering — Design

Two declarative lists in `dotfiles.nix`:

| List | Skipped on | Entries |
|---|---|---|
| `linuxOnly` | macOS | `hypr`, `waybar`, `dunst`, `rofi`, `wlogout`, `gtk-3.0`, `gtk-4.0`, `mimeapps.list` |
| `darwinOnly` | Linux | `aerospace` |

At **nix eval time**, the script baked into the derivation contains only the relevant
`case` filter. On Linux the output is:

```bash
case "$name" in aerospace) continue ;; esac
```

On macOS:

```bash
case "$name" in hypr|waybar|dunst|rofi|wlogout|gtk-3.0|gtk-4.0|mimeapps.list) continue ;; esac
```

Zero runtime conditionals. Each platform gets a statically correct script.

---

## Critical Files

| Path | Action | Purpose |
|---|---|---|
| `home/pkgs/dotfiles.nix` | **CREATE** | Activation script — the only new `.nix` file |
| `home/dotfiles/` | **CREATE** | Directory tree receiving all moved configs |
| `.gitignore` | **UPDATE** | Block runtime files that apps write into symlinked dirs |
| `.gitmodules` | **CREATE** | Re-register 5 submodules at new paths |

---

## `home/pkgs/dotfiles.nix` — Exact Code

```nix
{
  lib,
  mylib,
  system,
  ...
}:
let
  # .config/ entries that are Linux-only — skipped on macOS
  linuxOnly = [
    "hypr"
    "waybar"
    "dunst"
    "rofi"
    "wlogout"
    "gtk-3.0"
    "gtk-4.0"
    "mimeapps.list"
  ];

  # .config/ entries that are macOS-only — skipped on Linux
  darwinOnly = [
    "aerospace"
  ];

  # Entries to skip on this platform (resolved at eval time)
  skipEntries =
    if mylib.isLinux system then darwinOnly
    else if mylib.isDarwin system then linuxOnly
    else [ ];

  # Bash case filter line, baked into the script at eval time.
  # Empty string when nothing to skip (won't happen in practice).
  skipFilter =
    if skipEntries == [ ]
    then ""
    else "case \"$name\" in ${lib.concatStringsSep "|" skipEntries}) continue ;; esac";
in
{
  home.activation.dotfilesSymlinks = lib.hm.dag.entryAfter [ "writeBoundedFiles" ] ''
    dotfilesDir="$HOME/nixos/home/dotfiles"

    # --- .config/* entries (platform-filtered) ---
    if [ -d "$dotfilesDir/.config" ]; then
      mkdir -p "$HOME/.config"
      for item in "$dotfilesDir/.config"/*; do
        [ -e "$item" ] || continue
        name=$(basename "$item")
        ${skipFilter}
        # Don't overwrite a real directory — it may contain runtime state
        [ -d "$HOME/.config/$name" ] && [ ! -L "$HOME/.config/$name" ] && continue
        ln -sfn "$item" "$HOME/.config/$name"
      done
    fi

    # --- Root-level dotfiles (.bashrc, .zshrc, etc.) ---
    for item in "$dotfilesDir"/.*; do
      [ -e "$item" ] || continue
      name=$(basename "$item")
      case "$name" in .|..) continue ;; esac
      ln -sfn "$item" "$HOME/$name"
    done
  '';
}
```

**Key decisions explained:**

- **`$HOME` not `builtins.getEnv`** — `$HOME` (no braces) is not nix-interpolated in
  `'' ''` strings; it resolves at shell runtime. Works for all usernames across all hosts
  without baking a path at eval time.
- **Real-directory guard** — `[ -d ] && [ ! -L ] && continue` — if an app already created
  `~/.config/foo` as a real dir before activation ran, we skip it rather than clobber data.
- **`ln -sfn`** — `-n` prevents following an existing symlink-to-directory; `-f` replaces
  existing symlinks/files cleanly.
- **`skipFilter` interpolation** — `${skipFilter}` IS nix interpolation (intentional).
  All `$HOME`, `$name`, `$item` references are bare-dollar bash vars, invisible to nix.

---

## Migration Steps

### Step 1 — Create destination directory
```bash
mkdir -p ~/nixos/home/dotfiles
```

### Step 2 — Copy tracked files (respects `.gitignore`)
```bash
cd ~/.dotfiles
git archive HEAD -- .config/ | tar -x -C ~/nixos/home/dotfiles/
git archive HEAD -- .bashrc .zshrc | tar -x -C ~/nixos/home/dotfiles/
cd ~/nixos
```
`git archive` only exports tracked, non-ignored files. Submodule dirs come out as
empty placeholders — Step 4 replaces them.

### Step 3 — Create `home/pkgs/dotfiles.nix`
Write the file from the code block above.

### Step 4 — Re-register git submodules
```bash
cd ~/nixos

# Remove placeholders left by git archive (empty dirs or gitlink blobs)
rm -rf home/dotfiles/.config/zsh/autosuggestions
rm -rf home/dotfiles/.config/zsh/completions
rm -rf home/dotfiles/.config/zsh/syntax-highlighting
rm -rf home/dotfiles/.config/zsh/vi-mode
rm -rf home/dotfiles/.config/bash/ble.sh

# Clone at new paths and register in .gitmodules
git submodule add https://github.com/zsh-users/zsh-autosuggestions      home/dotfiles/.config/zsh/autosuggestions
git submodule add https://github.com/zsh-users/zsh-completions          home/dotfiles/.config/zsh/completions
git submodule add https://github.com/zsh-users/zsh-syntax-highlighting  home/dotfiles/.config/zsh/syntax-highlighting
git submodule add https://github.com/jeffreytse/zsh-vi-mode             home/dotfiles/.config/zsh/vi-mode
git submodule add https://github.com/akinomyoga/ble.sh.git              home/dotfiles/.config/bash/ble.sh
```

### Step 5 — Update `.gitignore`
Add these entries to `~/nixos/.gitignore` to block runtime files that apps will create
inside the symlinked directories:

```
# Runtime files written by apps into symlinked config dirs
home/dotfiles/.config/btop/btop.log
home/dotfiles/.config/atuin/atuin-receipt.json
home/dotfiles/.config/gh/hosts.yml
home/dotfiles/.config/fish/conf.d/
home/dotfiles/.config/fish/fish_variables
home/dotfiles/.config/nushell/history.txt
home/dotfiles/.config/clipse/clipboard_history.json
home/dotfiles/.config/clipse/clipse.log
home/dotfiles/.config/clipse/tmp_files/
home/dotfiles/.config/nvim/lua/plugins/mason.lua
home/dotfiles/.config/nvim/lazy-lock.json
home/dotfiles/.config/zed/prompts/
home/dotfiles/.config/opencode/node_modules/
```

### Step 6 — Remove old stow symlinks
```bash
# Stow folds ~/.config into a single symlink when it owns everything.
# Remove it and the root-level dotfile symlinks before rebuild.
rm -f ~/.bashrc ~/.zshrc
rm -f ~/.config       # symlink to ~/.dotfiles/.config
# Recreate .config as a real directory (activation script needs it)
mkdir -p ~/.config
```

### Step 7 — Rebuild
```bash
# Linux (nixos host):
sudo nixos-rebuild switch --flake .#nixos

# macOS:
darwin-rebuild switch --flake .#macix
```

### Step 8 — Verify (see section below), then decommission old repo
```bash
# Only after verification passes:
rm -rf ~/.dotfiles
```

### Step 9 — Compile ble.sh (if using bash)
```bash
# build.sh is no longer symlinked; run directly:
bash ~/nixos/home/dotfiles/.config/bash/ble.sh/Makefile  # or: make -C ~/.config/bash/ble.sh install
```
The symlink `~/.config/bash` → `home/dotfiles/.config/bash` is already active, so
`~/.config/bash/ble.sh` resolves correctly.

---

## Verification

```bash
# --- Symlinks point to nixos repo ---
readlink ~/.config/nvim
# → /home/khorer/nixos/home/dotfiles/.config/nvim

readlink ~/.bashrc
# → /home/khorer/nixos/home/dotfiles/.bashrc

# --- Platform filtering (on Linux) ---
test -e ~/.config/aerospace && echo "FAIL" || echo "OK: aerospace skipped on Linux"

# --- Hot-reload test ---
echo "# hot-reload-test" >> ~/.config/git/ignore
grep "hot-reload-test" ~/nixos/home/dotfiles/.config/git/ignore   # must match
sed -i '/hot-reload-test/d' ~/.config/git/ignore                  # clean up

# --- No symlinks point to old repo ---
find ~ -maxdepth 3 -type l 2>/dev/null | xargs readlink 2>/dev/null | grep -c "\.dotfiles"
# → 0

# --- Nix evaluates cleanly ---
cd ~/nixos && nix flake check
```

---

## Edge Cases & Pitfalls

| # | Issue | Mitigation |
|---|---|---|
| 1 | `mimeapps.list` is a file, not a directory | The glob `"$configSource"/*` matches files too — handled identically |
| 2 | `dconf/`, `environment.d/`, `systemd/`, `pulse/`, `fontconfig/` are fully gitignored | They won't exist in `home/dotfiles/` — no symlink created, no skip entry needed |
| 3 | `gh/hosts.yml` contains credentials | Already in `.gitignore` (Step 5). Never committed. |
| 4 | `opencode/` has `node_modules/` | Added to `.gitignore` in Step 5 |
| 5 | Step 6 must complete before Step 7 | If `~/.config` is still a stow symlink during activation, symlinks get created inside `.dotfiles/.config/` instead of `~/.config/` |
| 6 | Different usernames per host | `$HOME` resolves per-user at runtime — no hardcoded paths |
| 7 | `fish/conf.d/` is gitignored but fish writes there | Gitignored in Step 5. Files exist on disk via symlink but are never committed |
| 8 | ble.sh needs compilation after clone | `make -C ~/.config/bash/ble.sh install` — document or run in Step 9 |
