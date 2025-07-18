{ pkgs-unstable, ... }:
{
  fonts = {
    packages = with pkgs-unstable.nerd-fonts; [
      jetbrains-mono
      ubuntu
      liberation
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
