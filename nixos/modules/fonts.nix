{ pkgs-unstable, ... }: {
  fonts = {
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    # all fonts are linked to /nix/var/nix/profiles/system/sw/share/X11/fonts
    fontDir.enable = true;

    packages = with pkgs-unstable; [
      # icon fonts
      material-design-icons
      font-awesome

      source-sans
      source-serif
      source-han-sans
      source-han-serif

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only # symbols icon only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka

      julia-mono
      dejavu_fonts
    ];

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Source Han Serif SC" "Source Han Serif TC" "Noto Color Emoji"];
      sansSerif = ["Source Han Sans SC" "Source Han Sans TC" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}