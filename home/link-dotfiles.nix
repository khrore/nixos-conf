{ pkgs, lib, mylib, system, ... }:

let
  platform = if mylib.isDarwin system then "darwin"
             else if mylib.isLinux system then "nixos"
             else "common";

  runtimeLinkingLogic = ''
    link_dotfiles_runtime() {
      local dotfiles_root="$HOME/nixos/dotfiles"
      local common_dir="$dotfiles_root/common"
      local platform_dir="$dotfiles_root/${platform}"
      local rel subdir source target prefix
      declare -A sources=()

      if [ -d "$common_dir" ]; then
        while IFS= read -r -d "" file; do
          prefix="$common_dir/"
          rel="''${file#"$prefix"}"
          sources["$rel"]="common"
        done < <(find "$common_dir" -type f ! -name ".gitkeep" -print0)
      fi

      if [ -d "$platform_dir" ]; then
        while IFS= read -r -d "" file; do
          prefix="$platform_dir/"
          rel="''${file#"$prefix"}"
          sources["$rel"]="${platform}"
        done < <(find "$platform_dir" -type f ! -name ".gitkeep" -print0)
      fi

      if [ "''${#sources[@]}" -eq 0 ]; then
        echo "No dotfiles found to link."
        return 0
      fi

      echo "Processing ''${#sources[@]} dotfile entries..."

      while IFS= read -r rel; do
        subdir="''${sources["$rel"]}"
        source="$dotfiles_root/$subdir/$rel"
        target="$HOME/$rel"

        mkdir -p "$(dirname "$target")"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
          echo "Warning: $target exists and is not a symlink, skipping..."
        else
          ln -snf "$source" "$target"
          echo "✓ Linked $rel"
        fi
      done < <(printf '%s\n' "''${!sources[@]}" | LC_ALL=C sort)
    }
  '';

  linkScript = pkgs.writeShellScriptBin "link-dotfiles" ''
    set -e

    echo "Linking dotfiles for platform: ${platform}"
    ${runtimeLinkingLogic}
    link_dotfiles_runtime

    echo "Done! Dotfiles linked successfully."
  '';
in
{
  home.packages = [ linkScript ];

  home.activation.linkDotfiles = {
    after = [ "linkGeneration" ];
    before = [ ];
    data = ''
      ${runtimeLinkingLogic}
      link_dotfiles_runtime
    '';
  };
}
