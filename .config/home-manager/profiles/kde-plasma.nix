{ config, lib, pkgs, ... }:

with lib;

let
  smartly-sized-konsole = pkgs.writeShellApplication {
    name = "smartly-sized-konsole";
    runtimeInputs = with pkgs; [ jq kdePackages.konsole kdePackages.kscreen ];
    text = ''
      background=''${1-Dark}
      screen_width="$(kscreen-console json | jq .screen.currentSize.width)"

      if (( screen_width == 1920 )); then
          konsole --profile "$background"
      else
          konsole --profile "$background-11pt"
      fi
    '';
  };

in {
  options.profiles.kde-plasma.enable = mkEnableOption "the KDE Plasma profile";

  config = mkIf config.profiles.kde-plasma.enable {

    home.packages = [ smartly-sized-konsole ];

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
