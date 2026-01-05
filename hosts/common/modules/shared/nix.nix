{ username, ... }:
{
  nix.settings = {
    # Enables flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "${username}" ];
  };
}
