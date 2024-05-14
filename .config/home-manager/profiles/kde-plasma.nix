{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.kde-plasma.enable = mkEnableOption "the KDE Plasma profile";

  config = mkIf config.profiles.kde-plasma.enable {

    programs.firefox = {
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
      profiles.default = {
        settings = {
          "browser.tabs.inTitlebar" = 0; # separate titlebar

          # Disable the media entry from Firefox to use the one from the Plasma
          # browser integration plugin.
          "media.hardwaremediakeys.enabled" = false;
        };
        extensions = [ pkgs.nur.repos.rycee.firefox-addons.plasma-integration ];
      };
    };

  };
}
