{ config, lib, pkgs, ... }:

let
  inherit (lib) colorschemes concatStringsSep mapAttrsToList mkIf mkMerge;

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

  mkColorScheme = darkness:
    colorschemes.gruvbox.mkScheme darkness {
      background = "medium";
      bright = true;
    } // {
      name = "Gruvbox ${darkness}";
    };

  mkProfile = darkness:
    { fontSize }: {
      extraConfig = {
        Appearance = {
          ColorScheme = "Gruvbox_${darkness}";
          EmojiFont = "Noto Color Emoji,${
              toString fontSize
            },-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          Font = "JetBrainsMono Nerd Font Mono,${
              toString fontSize
            },-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
          UseFontLineChararacters = true;
        };
        General = {
          Environment = concatStringsSep ","
            (mapAttrsToList (name: value: "${name}=${value}") {
              BACKGROUND = darkness;
              COLORTERM = "truecolor";
              FONT_SIZE = toString fontSize;
              TERM = "konsole-256color";
            });
          ShowTerminalSizeHint = false;
          TerminalCenter = true;
          TerminalColumns = 90;
          TerminalMargin = 0;
          TerminalRows = 25;
        };
        "Interaction Options" = {
          AutoCopySelectedText = true;
          ColorFilterEnabled = false;
          DropUrlsAsText = false;
          MiddleClickPasteMode = 1;
          MouseWheelZoomEnabled = false;
          OpenLinksByDirectClickEnabled = false;
          TextEditorCmd = 6;
          TextEditorCmdCustom = "nvim PATH '+call cursor(LINE, COLUMN)'";
          TrimTrailingSpacesInSelectedText = true;
          UnderlineFilesEnabled = true;
        };
        Scrolling = {
          HighlightScrolledLines = false;
          HistorySize = 10000;
          ScrollBarPosition = 2;
        };
        "Terminal Features".FlowControlEnabled = false;
      };
    };

in mkMerge [
  {
    programs.konsole = {

      defaultProfile = "Dark";

      extraConfig = {
        KonsoleWindow.RememberWindowSize = false;
        FileLocation = {
          scrollbackUseCacheLocation = true;
          scrollbackUseSystemLocation = false;
        };
        "Shortcut Schemes"."Current Scheme" = "Custom.xml";
        TabBar = {
          CloseTabOnMiddleMouseButton = true;
          ExpandTabWidth = true;
          NewTabBehavior = "PutNewTabAfterCurrentTab";
        };
        ThumbnailsSettings.ThumbnailAlt = true;
      };

      colorSchemes = {
        Gruvbox_dark = mkColorScheme "dark";
        Gruvbox_light = mkColorScheme "light";
      };

      profiles = {
        Dark = mkProfile "dark" { fontSize = 10; };
        Dark-11pt = mkProfile "dark" { fontSize = 11; };
        Light = mkProfile "light" { fontSize = 10; };
        Light-11pt = mkProfile "light" { fontSize = 11; };
      };

    };
  }

  (mkIf config.programs.konsole.enable {
    home.packages = [ smartly-sized-konsole ];
  })

]
