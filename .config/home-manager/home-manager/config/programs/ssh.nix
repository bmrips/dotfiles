{ pkgs, ... }:

{
  config.programs.ssh = {
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = {
      "private/aur" = {
        host = "aur.archlinux.org";
        user = "aur";
        identityFile = "~/.ssh/private/aur";
      };
      "private/github" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/private/github";
      };
    };
  };
}
