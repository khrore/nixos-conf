{ username, ... }:
{
  nix.settings = {
    # Enables flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "${username}" ];

    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
