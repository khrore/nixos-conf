# Creating a user and giving it needed privileges
{ username, pkgs-unstable, shell, ... }: {
  users = {
    defaultUserShell = pkgs-unstable.${shell};
    users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
}
