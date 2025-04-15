# Enables Nix CLI helper.
{ username, ... }: {
  programs.nh = {
    enable = true;
    flake = "/home/${username}/flake";
  };
}
