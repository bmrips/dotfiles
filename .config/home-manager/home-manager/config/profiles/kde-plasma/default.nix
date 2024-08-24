{ config, lib, pkgs, ... }:

with lib;

let
  # Rewrite the specified PDF with ghostscript to remedy a bug in Okular's forms
  # editor.
  copy-forms = pkgs.writeShellApplication {
    name = "copy-forms";
    runtimeInputs = with pkgs; [ ghostscript_headless ];
    text = ''
      if [[ -z $1 ]]; then
          echo "Error: no argument given!" >&2
          exit 1
      fi

      base="''${1%.pdf}"
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$base.copy.pdf" "$base.pdf"
    '';
  };

  plasma-dark-mode = pkgs.writeShellApplication {
    name = "plasma-dark-mode";
    runtimeInputs = with pkgs; [ gnugrep kdePackages.plasma-workspace ];
    text = builtins.readFile ./plasma-dark-mode.sh;
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

    assertions = [{
      assertion = pkgs.stdenv.isLinux;
      message = "This profile is only available on Linux.";
    }];

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
        copy-forms
        kcalc
        kcolorchooser
        kdepim-runtime
        kgpg
        kleopatra # for KMail
        kmail
        kmail-account-wizard
        kmailtransport
        plasma-dark-mode
        qt6.qtimageformats
        skanpage
        smartly-sized-konsole
      ];

    profiles.gui.enable = true;

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
