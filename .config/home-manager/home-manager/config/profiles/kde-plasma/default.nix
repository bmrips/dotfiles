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

  smartly-sized-konsole = let
    grep = "${pkgs.gnugrep}/bin/grep";
    jq = "${pkgs.jq}/bin/jq";
    konsole = "${pkgs.kdePackages.konsole}/bin/konsole";
    kscreen-console = "${pkgs.kdePackages.kscreen}/bin/kscreen-console";
  in pkgs.writeShellApplication {
    name = "smartly-sized-konsole";
    text = ''
      background=''${1-Dark}
      kscreen_output="$(${kscreen-console} json | ${grep} '^[ {}]')"
      screen_width="$(${jq} .screen.currentSize.width <<<"$kscreen_output")"
      screen_name="$(${jq} --raw-output '.outputs.[] | select(.enabled) | .name' <<<"$kscreen_output")"

      if (( screen_width == 1920 )) && [[ ! $screen_name = eDP-* ]]; then
          ${konsole} --profile "$background"
      else
          ${konsole} --profile "$background-11pt"
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
      with pkgs.kdePackages;
      [ copy-forms kcalc kcolorchooser plasma-dark-mode qt6.qtimageformats ]
      ++ optionals config.profiles.gui.extra.enable [
        akonadi
        akonadi-calendar
        akonadi-contacts
        akonadi-import-wizard
        akonadi-mime
        akonadi-notes
        akonadi-search
        akregator
        kdepim-runtime
        kgpg
        kleopatra # for KMail
        kmail
        kmail-account-wizard
        kmailtransport
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

    # Git ignores Dolphin's directory preferences.
    programs.git.ignores = [ ".directory" ];

  };
}
