{
  systemd.extraConfig = ''
    DefaultEnvironment="HTTP_PROXY=http://130.100.7.222:1082"
    DefaultEnvironment="HTTPS_PROXY=http://130.100.7.222:1082"
  '';
}
