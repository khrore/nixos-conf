{ pkgs, lib, mylib, system, ... }:

let
  platform = if mylib.isDarwin system then "darwin"
             else if mylib.isLinux system then "nixos"
             else "common";

  entries = mylib.linkDotfiles {
    baseDir = ../dotfiles;
    inherit platform;
  };

  linkScript = pkgs.writeShellScriptBin "link-dotfiles" ''
    set -e

    echo "Linking dotfiles for platform: ${platform}"
    echo "Processing ${toString (builtins.length entries)} dotfile entries..."

    ${lib.concatMapStrings (entry: ''
      mkdir -p "$HOME/$(dirname '${entry.target}')"
      if [ -e "$HOME/${entry.target}" ] && [ ! -L "$HOME/${entry.target}" ]; then
        echo "Warning: $HOME/${entry.target} exists and is not a symlink, skipping..."
      else
        ln -sf "$HOME/nixos/dotfiles/${entry.subdir}/${entry.target}" "$HOME/${entry.target}"
        echo "✓ Linked ${entry.target}"
      fi
    '') entries}

    echo "Done! Dotfiles linked successfully."
  '';
in
{
  home.packages = [ linkScript ];

  home.activation.linkDotfiles = {
    after = [ "linkGeneration" ];
    before = [ ];
    data = lib.concatMapStrings (entry: ''
      mkdir -p "$HOME/$(dirname '${entry.target}')"
      ln -sf "$HOME/nixos/dotfiles/${entry.subdir}/${entry.target}" "$HOME/${entry.target}"
    '') entries;
  };
}
