{ username, inputs, ... }:
let
  secretsMeta = import (inputs.secrets + "/secrets.nix");
in
{
  # Decrypt macix private key for dev-4 -> macix SSH access.
  age.secrets.macix_ssh_key = {
    owner = username;
    group = "users";
    mode = "0400";
    # path = "/home/${username}/.ssh/id_ed25519_macix";
  };

  # Allow SSH access from macix -> dev-4 via dedicated key.
  users.users.${username}.openssh.authorizedKeys.keys =
    secretsMeta."keys/dev-4_ssh_key.age".publicKeys;
}
