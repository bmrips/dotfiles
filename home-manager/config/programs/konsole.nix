{
  config,
  lib,
  pkgs,
  ...
}:

let
  smartly-sized-konsole =
    let
      grep = "${pkgs.gnugrep}/bin/grep";
      jq = "${pkgs.jq}/bin/jq";
      konsole = "${pkgs.kdePackages.konsole}/bin/konsole";
      kscreen-console = "${pkgs.kdePackages.kscreen}/bin/kscreen-console";
    in
    pkgs.writeShellApplication {
      name = "smartly-sized-konsole";
      text = ''
        background=''${1-Dark}
        kscreen_output="$(${kscreen-console} json | ${grep} '^[ {}]')"
        screen_width="$(${jq} .screen.currentSize.width <<<"$kscreen_output")"
        screen_name="$(${jq} --raw-output '.outputs.[] | select(.enabled) | .name' <<<"$kscreen_output")"

        if (( screen_width != 1920 )) ||
              [[ $screen_name = eDP-* ]] ||
              [[ $screen_name = Unknown-* ]]; then
            ${konsole} --profile "$background"
        else
            ${konsole} --profile "$background-10pt"
        fi
      '';
    };

  mkColorScheme =
    darkness:
    lib.base16.asRgbCodes (lib.gruvbox_material.scheme darkness) rec {
      background = "base00";
      foreground = "base05";
      black.normal = background;
      black.bright = "base03";
      white = foreground;
      red = "base08";
      yellow = "base0A";
      green = "base0B";
      cyan = "base0C";
      blue = "base0D";
      magenta = "base0E";
    }
    // {
      name = "Gruvbox ${darkness}";
    };

  mkProfile =
    darkness:
    { fontSize }:
    {
      extraConfig = {
        Appearance = {
          # Nerd symbols are messed up in the bold series of the medium weight
          # variant of JetBrains Mono, hence we avoid the bold series.
          BoldIntense = false;
          ColorScheme = "Gruvbox_${darkness}";
          EmojiFont = "Noto Color Emoji,${toString fontSize},-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          Font = "JetBrainsMono Nerd Font,${toString fontSize},-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Medium";
          WordMode = true;
          WordModeAttr = false;
        };
        General = {
          Environment = lib.concatStringsSep "," (
            lib.mapAttrsToList (name: value: "${name}=${value}") {
              BACKGROUND = darkness;
              COLORTERM = "truecolor";
              FONT_SIZE = toString fontSize;
              TERM = "konsole-256color";
            }
          );
          ShowTerminalSizeHint = false;
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
          TrimTrailingSpacesInSelectedText = true;
          UnderlineFilesEnabled = true;
        };
        Scrolling = {
          HighlightScrolledLines = false;
          HistorySize = 10000;
          ScrollBarPosition = 2;
        };
      };
    };

in
lib.mkMerge [
  {
    programs.konsole = {

      defaultProfile = "Dark";

      extraConfig = {
        KonsoleWindow = {
          RememberWindowSize = false;
          ShowMenuBarByDefault = false;
        };
        FileLocation = {
          scrollbackUseCacheLocation = true;
          scrollbackUseSystemLocation = false;
        };
        "Shortcut Schemes"."Current Scheme" = "Custom";
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

      shortcutSchemes.Custom = {
        close-session = "Ctrl+Shift+W";
        close-window = "Ctrl+Shift+Q";
        new-window = "Ctrl+Shift+N";
        new-tab = "Ctrl+Shift+T";
        clone-tab = "Ctrl+Shift+R";
        detach-tab = "Ctrl+Shift+D";
        next-tab = "Ctrl+Tab";
        previous-tab = "Ctrl+Shift+Tab";
        move-tab-to-right = "Ctrl+Shift+Right";
        move-tab-to-left = "Ctrl+Shift+Left";
        split-view-left-right = "Ctrl+(";
        split-view-top-bottom = "Ctrl+)";
        split-view-auto = "Ctrl+*";
        focus-view-above = "Ctrl+Shift+K";
        focus-view-below = "Ctrl+Shift+J";
        focus-view-left = "Ctrl+Shift+H";
        focus-view-right = "Ctrl+Shift+L";
        expand-active-view = "Ctrl+Shift+]";
        shrink-active-view = "Ctrl+Shift+[";
        toggle-maximize-current-view = "Ctrl+Shift+E";
        detach-view = "Alt+Shift+D";
        edit_copy = "Ctrl+Shift+C";
        edit_paste = [
          "Ctrl+Shift+V"
          "Shift+Ins"
        ];
        paste-selection = "Ctrl+Shift+Ins";
        file_save_as = "Ctrl+Shift+S";
        file_print = "Ctrl+Shift+P";
        edit_find = "Ctrl+Shift+F";
        edit_find_next = "F3";
        edit_find_prev = "Shift+F3";
        monitor-activity = "Ctrl+Shift+A";
        monitor-silence = "Ctrl+Shift+I";
        enlarge-font = [
          "Ctrl++"
          "Ctrl+="
        ];
        shrink-font = "Ctrl+-";
        reset-font-size = "Ctrl+0";
        open_kcommand_bar = "Ctrl+Alt+I";
        options_show_menubar = "Ctrl+Shift+M";
        options_configure = "Ctrl+Shift+,";
        options_configure_keybinding = "Ctrl+>";
      };

      profiles = {
        Dark-10pt = mkProfile "dark" { fontSize = 10; };
        Dark = mkProfile "dark" { fontSize = 11; };
        Light-10pt = mkProfile "light" { fontSize = 10; };
        Light = mkProfile "light" { fontSize = 11; };
      };

    };
  }

  (lib.mkIf config.programs.konsole.enable {
    home.packages = [ smartly-sized-konsole ];

    programs.plasma.hotkeys.commands = {
      smartly-sized-konsole-dark = {
        name = "Smartly sized Konsole (dark)";
        command = "smartly-sized-konsole Dark";
        key = "Meta+Return";
      };
      smartly-sized-konsole-light = {
        name = "Smartly sized Konsole (light)";
        command = "smartly-sized-konsole Light";
        key = "Meta+Ctrl+Return";
      };
    };
  })

]
