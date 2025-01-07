{ pkgs, ... }:

{
  programs.ssh = {
    package = pkgs.openssh;
    addKeysToAgent = "yes";
    matchBlocks = {
      aur.host = "aur.archlinux.org";
      aur.user = "aur";
      github.host = "github.com";
      github.user = "git";
      gitlab.host = "gitlab.com";
      gitlab.user = "git";
    };
  };
}
