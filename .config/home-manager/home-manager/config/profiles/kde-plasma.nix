{ config, lib, pkgs, ... }:

with lib;

let
  plasma-dark-mode = pkgs.writeShellApplication {
    name = "plasma-dark-mode";
    runtimeInputs = with pkgs; [ kdePackages.plasma-workspace ];
    text = ''
      is_enabled() {
          [[ $(plasma-apply-colorscheme --list-schemes | grep current) = *[dD]ark* ]]
      }

      disable() {
          plasma-apply-lookandfeel --apply org.kde.breezetwilight.desktop
      }

      enable() {
          plasma-apply-lookandfeel --apply org.kde.breezedark.desktop
      }

      toggle() {
          if is_enabled; then
              disable
          else
              enable
          fi
      }

      case $1 in
          isEnabled) is_enabled ;;
          disable) disable ;;
          enable) enable ;;
          toggle) toggle ;;
          *) echo "Error: unknown command" >&2 ;;
      esac
    '';
  };

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

    home.packages = with pkgs;
      with pkgs.kdePackages; [
        akonadi
        akonadi-calendar
        akonadi-contacts
        akonadi-import-wizard
        akonadi-mime
        akonadi-notes
        akonadi-search
        akregator
        kcalc
        kcolorchooser
        kdepim-runtime
        kgpg
        kleopatra
        kmail
        kmail-account-wizard
        kmailtransport
        plasma-dark-mode
        qt6.qtimageformats
        skanpage
        smartly-sized-konsole
      ];

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
