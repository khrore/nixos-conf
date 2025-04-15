# Sets the default applications for given mimetypes
# Example:
# {
#   "application/pdf" = "firefox.desktop";
#   "image/png" = [
#     "sxiv.desktop"
#     "gimp.desktop"
#   ];
# }
{ terminalFileManager, ... }: {
  xdg.mime.defaultApplications = {
    "inode/directory" = terminalFileManager;
  };
}
