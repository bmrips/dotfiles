{ config, lib, pkgs, ... }:

with lib;

{

  imports = [ ../../home-manager ];

  development.container.enable = true;
  development.kubernetes.enable = true;

  home.username = "benedikt.rips";

  home.packages = with pkgs; [ azure-cli ];

  home.shellAliases.sudo = concatStringsSep "; " [
    "[[ -s /etc/sudo.conf ]] && sudo bash -c '>/etc/sudo.conf'"
    "unalias sudo"
    "sudo"
  ];

  profiles = {
    macos.enable = true;
    standalone.enable = true;
    uni-muenster.enable = true;
  };

  programs.firefox.profiles.default.settings = {
    # always show the bookmarks toolbar
    "browser.toolbars.bookmarks.visibility" = mkForce "always";
  };

  programs.git.userEmail = mkForce "${config.home.username}@adesso.de";

  programs.ssh.matchBlocks = {
    "adesso/azure" = {
      host = "ssh.dev.azure.com";
      user = "git";
      identityFile = "~/.ssh/adesso/azure";
    };
    "adesso/bitbucket" = {
      host = "bitbucket.adesso-group.com";
      user = "git";
      identityFile = "~/.ssh/adesso/bitbucket";
    };
    "adesso/github" = {
      host = "adesso.github.com";
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/adesso/github";
    };
  };

}
