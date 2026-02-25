{ username, ... }:
{
  # Decrypt macix private key for dev-4 -> macix SSH access.
  age.secrets.macix_ssh_key = {
    owner = username;
    group = "users";
    mode = "0400";
    # path = "/home/${username}/.ssh/id_ed25519_macix";
  };
}
