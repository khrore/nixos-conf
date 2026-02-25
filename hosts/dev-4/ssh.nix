{ username, inputs, ... }:
{
  # Ensure target dir exists before secret materialization.
  systemd.tmpfiles.rules = [ "d /home/${username}/.ssh 0700 ${username} users -" ];

  # Decrypt macix private key for dev-4 -> macix SSH access.
  age.secrets.macix_ssh_key = {
    file = inputs.secrets + "/keys/macix_ssh_key.age";
    owner = username;
    group = "users";
    mode = "0400";
    path = "/home/${username}/.ssh/id_ed25519_macix";
  };
}
