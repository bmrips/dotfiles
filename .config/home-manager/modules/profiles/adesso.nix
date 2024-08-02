{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.adesso.enable = mkEnableOption "the adesso profile";

  config = mkIf config.profiles.adesso.enable {

    home.username = mkForce "benedikt.rips";

    home.packages = with pkgs; [ azure-cli ];

    home.shellAliases.sudo = concatStringsSep "; " [
      "[[ -s /etc/sudo.conf ]] && sudo bash -c '>/etc/sudo.conf'"
      "unalias sudo"
      "sudo"
    ];

    programs.firefox.profiles.default.settings = {
      # always show the bookmarks toolbar
      "browser.toolbars.bookmarks.visibility" = mkForce "always";
    };

    programs.git.userEmail = mkForce "${config.home.username}@adesso.de";

    programs.kubectl.enable = true;

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
  };
}
