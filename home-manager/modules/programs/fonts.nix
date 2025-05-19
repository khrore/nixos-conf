{ pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
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
    nerd-fonts.roboto-mono
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-sans
    nerd-fonts.ubuntu-mono

    julia-mono
    dejavu_fonts
  ];

  fonts = {
    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [
        "Ubuntu Nerd Font"
      ];
      sansSerif = [
        "UbuntuSans Nerd Font"
      ];
      monospace = [
        "UbuntuMono Nerd Font"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
