{
  config,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Nexus/";

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
    runtimeInputs = with pkgs; [
      gnugrep
      kdePackages.plasma-workspace
    ];
    text = builtins.readFile ./plasma-dark-mode.sh;
  };

in
lib.mkMerge [

  {
    programs.plasma = {

      fonts.fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
        styleName = "Medium";
        weight = "medium";
      };

      input.keyboard = {
        layouts = [
          {
            layout = "us";
            variant = "intl-unicode";
          }
          { layout = "de"; }
        ];
        options = [
          "altwin:swap_lalt_lwin"
          "ctrl:swapcaps"
          "eurosign:e"
          "grp:shifts_toggle"
          "grp_led:scroll" # Use scroll lock LED to indicate the layout
        ];
        repeatDelay = 400;
        repeatRate = 40;
      };

      input.mice = [
        {
          name = "SONiX Evoluent VerticalMouse D";
          vendorId = "1a7c";
          productId = "0197";
          acceleration = -1.0;
          accelerationProfile = "default";
          naturalScroll = false;
          scrollSpeed = 1.0;
        }
      ];

      # Rebind mouse buttons for Evoluent VerticalMouse
      configFile.kcminputrc."ButtonRebinds/Mouse" = {
        ExtraButton1 = "Key,Meta+Right";
        ExtraButton3 = "Key,Meta+Left";
      };

      krunner = {
        historyBehavior = "enableSuggestions";
        position = "center";
        shortcuts = {
          launch = [
            "Search"
            "Meta+Space"
          ];
          runCommandOnClipboard = "Meta+Ctrl+Space";
        };
      };

      kscreenlocker = {
        appearance = {
          inherit wallpaper;
          alwaysShowClock = true;
          showMediaControls = true;
        };
        autoLock = true;
        lockOnResume = true;
        # lockOnStartup = true; # TODO: enable together with autologin?
        passwordRequired = true;
        passwordRequiredDelay = 5;
        timeout = 5;
      };

      kwin = {
        effects.desktopSwitching.animation = "slide";
        nightLight = {
          enable = true;
          mode = "location"; # TODO: automatic location retrieval
          location.latitude = "51.8";
          location.longitude = "5.8";
          temperature.day = 5500;
          temperature.night = 3500;
        };
        tiling.padding = 0;
        titlebarButtons = {
          left = [
            "more-window-actions"
            "on-all-desktops"
          ];
          right = [
            "minimize"
            "maximize"
            "close"
          ];
        };
        virtualDesktops = {
          names = map toString [
            1
            2
            3
            4
          ];
          rows = 2;
        };
      };

      panels = [
        {
          alignment = "center";
          floating = false;
          height = 36;
          hiding = "normalpanel";
          lengthMode = "fill";
          location = "bottom";
          screen = 0;
          widgets = [
            {
              kickoff = {
                compactDisplayStyle = true;
                icon = "nix-snowflake-white";
                sortAlphabetically = true;
              };
            }
            {
              name = "org.kde.plasma.taskmanager";
              config.General = {
                groupedTaskVisualization = 2; # show window previews
                launchers = "";
                middleClickAction = "Close";
                showOnlyCurrentDesktop = false;
                showToolTips = false;
                sortingStrategy = 3; # by desktop
                wheelEnabled = false;
              };
            }
            "org.kde.plasma.marginsseparator"
            {
              systemTray = {
                icons.scaleToFit = true;
                items = rec {
                  extra =
                    shown
                    ++ hidden
                    ++ [
                      "org.kde.plasma.cameraindicator"
                      "org.kde.plasma.devicenotifier"
                      "org.kde.plasma.keyboardindicator"
                      "org.kde.plasma.keyboardlayout"
                      "org.kde.plasma.manage-inputmethod"
                      "org.kde.plasma.mediacontroller"
                      "org.kde.plasma.notifications"
                      "org.kde.plasma.printmanager"
                      "org.kde.plasma.volume"
                    ];
                  shown = [
                    "chrome_status_icon_1" # Signal
                    "KeePassXC"
                    "org.kde.plasma.battery"
                    "org.kde.plasma.bluetooth"
                    "org.kde.plasma.brightness"
                    "org.kde.plasma.networkmanagement"
                  ];
                  hidden = [
                    "Nextcloud"
                    "org.kde.merkuro.contact.applet"
                    "org.kde.plasma.clipboard"
                    "org.kde.plasma.weather"
                    "ownCloud"
                  ];
                  configs = {
                    "org.kde.plasma.weather".config.WeatherStation.source =
                      "bbcukmet|weather|Nijmegen, Netherlands, NL|2750053";
                  };
                };
              };
            }
            {
              digitalClock = {
                date.enable = false;
                time.showSeconds = "onlyInTooltip";
              };
            }
          ];
        }
      ];

      powerdevil =
        let
          baseProfile = {
            autoSuspend.action = "sleep";
            dimDisplay.enable = false;
            inhibitLidActionWhenExternalMonitorConnected = true;
            powerButtonAction = "showLogoutScreen";
            whenLaptopLidClosed = "sleep";
            whenSleepingEnter = "standby";
          };
        in
        {
          general.pausePlayersOnSuspend = true;
          batteryLevels = {
            criticalAction = "hibernate";
            criticalLevel = 10;
            lowLevel = 20;
          };
          AC = baseProfile // {
            autoSuspend.action = "nothing";
            turnOffDisplay.idleTimeout = "never";
          };
          battery = baseProfile // {
            autoSuspend.idleTimeout = 300; # 5 minutes
            turnOffDisplay.idleTimeout = 300; # 5 minutes
            turnOffDisplay.idleTimeoutWhenLocked = 60; # 1 minute
          };
          lowBattery = baseProfile // {
            autoSuspend.idleTimeout = 120; # 2 minutes
            inhibitLidActionWhenExternalMonitorConnected = false;
            turnOffDisplay.idleTimeoutWhenLocked = "immediately"; # 1 minute
          };
        };
      configFile."powerdevil.notifyrc"."Event/fullbattery".Action = "Popup";

      session.sessionRestore.restoreOpenApplicationsOnLogin = "onLastLogout";

      shortcuts = {
        kcm_touchpad."Toggle Touchpad" = "Meta+Shift+T";
        kmix = {
          "decrease_volume_small" = [
            "Shift+Volume Down"
            "Meta+Ctrl+Down"
          ];
          "increase_volume_small" = [
            "Shift+Volume Up"
            "Meta+Ctrl+Up"
          ];
          "decrease_volume" = [
            "Volume Down"
            "Meta+Down"
          ];
          "increase_volume" = [
            "Volume Up"
            "Meta+Up"
          ];
          "mute" = [
            "Volume Mute"
            "Meta+Pause"
          ];
          "decrease_microphone_volume" = [
            "Microphone Volume Down"
            "Meta+Volume Down"
            "Meta+Shift+Down"
          ];
          "increase_microphone_volume" = [
            "Microphone Volume Up"
            "Meta+Volume Up"
            "Meta+Shift+Up"
          ];
          "mic_mute" = [
            "Microphone Mute"
            "Meta+Volume Mute"
            "Meta+Shift+Pause"
          ];
        };
        ksmserver = {
          "Halt Without Confirmation" = "Meta+Ctrl+End";
          "Lock Session" = [
            "Alt+L"
            "Meta+Del"
          ];
          "Reboot Without Confirmation" = "Meta+Ctrl+Home";
        };
        kwin = {
          "Activate Window Demanding Attention" = "Meta+Ctrl+A";
          "Edit Tiles" = "Meta+T";
          "Expose" = "Meta+Ctrl+W";
          "ExposeAll" = "Meta+W";
          "Grid View" = "Meta+D";
          "Overview" = "Meta+Q";
          "Show Desktop" = "Meta+Ctrl+D";
          "Switch One Desktop Down" = "Meta+J";
          "Switch One Desktop Up" = "Meta+K";
          "Switch One Desktop to the Left" = "Meta+H";
          "Switch One Desktop to the Right" = "Meta+L";
          "Walk Through Windows" = "Meta+Tab";
          "Walk Through Windows (Reverse)" = "Meta+Shift+Tab";
          "Walk Through Windows of Current Application" = "Meta+`";
          "Walk Through Windows of Current Application (Reverse)" = "Meta+Ctrl+`";
          "Window Above Other Windows" = "Meta+A";
          "Window Close" = "Meta+Ctrl+Q";
          "Window Fullscreen" = "Meta+Ctrl+F";
          "Window Maximize" = "Meta+F";
          "Window Minimize" = "Meta+Shift+F";
          "Window Move" = "Meta+S";
          "Window On All Desktops" = "Meta+Shift+D";
          "Window One Desktop Down" = "Meta+Ctrl+J";
          "Window One Desktop Up" = "Meta+Ctrl+K";
          "Window One Desktop to the Left" = "Meta+Ctrl+H";
          "Window One Desktop to the Right" = "Meta+Ctrl+L";
          "Window Quick Tile Bottom" = "Meta+Shift+J";
          "Window Quick Tile Left" = "Meta+Shift+H";
          "Window Quick Tile Right" = "Meta+Shift+L";
          "Window Quick Tile Top" = "Meta+Shift+K";
          "Window to Next Screen" = "Meta+O";
          "Window to Previous Screen" = "Meta+I";
          "view_actual_size" = "Meta+0";
          "view_zoom_in" = [
            "Meta+="
            "Meta++"
          ];
          "view_zoom_out" = "Meta+-";
        };
        mediacontrol = {
          "nextmedia" = [
            "Media Next"
            "Meta+Right"
          ];
          "pausemedia" = "Media Pause";
          "playpausemedia" = [
            "Media Play"
            "Pause"
          ];
          "previousmedia" = [
            "Media Previous"
            "Meta+Left"
          ];
          "stopmedia" = "Media Stop";
        };
        org_kde_powerdevil = {
          "Decrease Screen Brightness" = [
            "Monitor Brightness Down"
            "Meta+PgDown"
          ];
          "Increase Screen Brightness" = [
            "Monitor Brightness Up"
            "Meta+PgUp"
          ];
          "PowerDown" = "Meta+End";
        };
        plasmashell = {
          "activate application launcher" = "Meta+F1";
          "activate task manager entry 1" = "Meta+1";
          "activate task manager entry 2" = "Meta+2";
          "activate task manager entry 3" = "Meta+3";
          "activate task manager entry 4" = "Meta+4";
          "activate task manager entry 5" = "Meta+5";
          "activate task manager entry 6" = "Meta+6";
          "activate task manager entry 7" = "Meta+7";
          "activate task manager entry 8" = "Meta+8";
          "activate task manager entry 9" = "Meta+9";
          "show-on-mouse-pos" = "Meta+V"; # clipboard
          "toggle do not disturb" = "Meta+Ctrl+N";
        };
        "services/firefox.desktop" = {
          _launch = "Launch (5)";
          new-private-window = "Shift+Launch (5)";
          profile-manager-window = "Ctrl+Launch (5)";
        };
        "services/signal.desktop"."_launch" = "Meta+M";
        "services/slack.desktop"."_launch" = "Meta+,";
        "services/org.kde.kmail2.desktop" = {
          _launch = "Launch Mail";
          Composer = "Shift+Launch Mail";
        };
        "services/org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
        "services/org.keepassxc.KeePassXC.desktop"."_launch" = "Meta+;";
        "services/spotify.desktop"."_launch" = "Launch (9)";
      };

      hotkeys.commands.toggle-dark-mode = {
        name = "Toggle dark mode";
        command = "plasma-dark-mode toggle";
        key = "Meta+Z";
      };

      spectacle.shortcuts = {
        captureActiveWindow = "Ctrl+Print";
        captureEntireDesktop = "Shift+Print";
        captureRectangularRegion = "Print";
        launch = "Meta+Print";
      };
      configFile.spectaclerc =
        let
          filenameTemplate = "<yyyy><MM><dd>_<HH><mm><ss>";
        in
        {
          General = {
            autoSaveImage = true;
            clipboardGroup = "PostScreenshotCopyImage";
            launchAction = "DoNotTakeScreenshot";
            rememberSelectionRect = 2; # remember selection until it is closed
          };
          Annotations.annotationToolType = 5;
          ImageSave.imageFilenameTemplate = filenameTemplate;
          VideoSave.videoFilenameTemplate = filenameTemplate;
        };

      webSearchKeywords = {
        default = "google";
        preferred = [
          "deepl"
          "google"
          "google_maps"
          "homemanager"
          "linguee"
          "nixpkgs"
          "nixosopts"
          "reddit"
        ];
        extra = {
          cloogle = {
            name = "Cloogle";
            keys = [ "cloogle" ];
            query = ''https://cloogle.org/#\{@}'';
          };
          ctan = {
            name = "CTAN";
            keys = [ "ctan" ];
            query = ''https://ctan.org/search?phrase=\{@}'';
          };
          deepl = {
            name = "DeepL";
            keys = [ "deepl" ];
            query = ''https://www.deepl.com/translator#\{from,"any"}/\{to,"de"}/\{@}'';
          };
          home-manager = {
            name = "Home Manager";
            keys = [
              "hm"
              "home-manager"
            ];
            query = ''https://home-manager-options.extranix.com/?release=\{release,"master"}&query=\{@}'';
          };
          hoogle = {
            name = "Hoogle";
            keys = [
              "h"
              "hoogle"
            ];
            query = ''https://hoogle.haskell.org/?hoogle=\{@}'';
          };
          nixpkgs = {
            name = "Nix Packages";
            keys = [
              "np"
              "nixpkgs"
            ];
            query = ''https://search.nixos.org/packages?channel=\{channel,"unstable"}&query=\{@}'';
          };
          nixosopts = {
            name = "NixOS Options";
            keys = [
              "no"
              "nixosopts"
            ];
            query = ''https://search.nixos.org/options?channel=\{channel,"unstable"}&query=\{@}'';
          };
          nixoswiki = {
            name = "NixOS Wiki";
            keys = [
              "nw"
              "nixoswiki"
            ];
            query = ''https://nixos.wiki/index.php?search=\{@}'';
          };
          noogle = {
            name = "Noogle";
            keys = [ "noogle" ];
            query = ''https://noogle.dev/q?term=\{@}'';
          };
          texdoc = {
            keys = [ "texdoc" ];
            query = ''https://texdoc.org/serve/\{@}/0'';
          };
        };
      };

      window-rules = [
        {
          description = "Pinentry";
          match.window-class = {
            type = "regex";
            value = "pinentry-.*";
          };
          apply = {
            placement.apply = "force";
            placement.value = 5;
            size.value = "460,220";
          };
        }
      ];

      windows.allowWindowsToRememberPositions = false;

      workspace = {
        inherit wallpaper;
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezetwilight.desktop";
      };

      configFile.baloofilerc = {
        "Basic Settings"."Indexing-Enabled" = false;
        "General"."exclude folders[$e]" = "$HOME/.cache/";
      };

      # Disable window outlines
      configFile.breezerc.Common.OutlineIntensity = "OutlineOff";

      configFile.plasmanotifyrc = {
        Notifications.LowPriorityHistory = true;
        Notifications.LowPriorityPopups = false;
        "Services/bluedevil".ShowInHistory = false;
        "Services/networkmanagement".ShowInHistory = false;
        "Services/phonon".ShowInHistory = false;
        "Services/powerdevil".ShowInHistory = false;
        "Services/powerdevil".ShowPopupsInDndMode = true;
      };

      configFile.plasmaparc.General = {
        AudioFeedback = false;
        VolumeStep = 4;
      };

      configFile.plasma-localerc.Formats =
        let
          english = "en_GB.UTF-8";
          german = "de_DE.UTF-8";
        in
        {
          LANG = english;
          LC_COLLATE = german;
          LC_MEASUREMENT = german;
          LC_MONETARY = german;
          LC_TELEPHONE = german;
          useDetailed = true;
        };

      configFile.kdeglobals.KDE.DndBehavior = "MoveIfSameDevice";

      configFile.kdeglobals."KFileDialog Settings" = {
        "Allow Expansion" = false;
        "Automatically select filename extension" = true;
        "Breadcrumb Navigation" = false;
        "Decoration position" = 2;
        "LocationCombo Completionmode" = 5;
        "PathCombo Completionmode" = 5;
        "Preview Width" = 269;
        "Show Bookmarks" = false;
        "Show Full Path" = false;
        "Show hidden files" = false;
        "Show Inline Previews" = false;
        "Show Preview" = false;
        "Show Speedbar" = false;
        "Sort by" = "Name";
        "Sort directories first" = true;
        "Sort hidden files last" = false;
        "Sort reversed" = false;
        "Speedbar Width" = 138;
        "View Style" = "DetailTree";
      };

      configFile.kdeglobals.Shortcuts = {
        Close = "Ctrl+W";
        KeyBindings = "Ctrl+>";
        OpenRecent = "Ctrl+Shift+O";
        RenameFile = "Ctrl+R";
        Replace = "Meta+Ctrl+R";
      };

      configFile.kwinrc = {
        Effect-overview.BorderActivate = 9; # no action for the top left corner
        MouseBindings.CommandActiveTitlebar2 = "Close";
        MouseBindings.CommandAllKey = "Meta";
        MouseBindings.CommandInactiveTitlebar2 = "Close";
        TabBox.HighlightWindows = false; # do not show the selected window
        Windows.Placement = "Smart";
        Windows.RollOverDesktops = true; # desktop navigation wrap around
      };

      configFile.PlasmaUserFeedback.Global.FeedbackLevel = 64;

    };
  }

  (lib.mkIf config.programs.plasma.enable {

    assertions = [
      (lib.hm.assertions.assertPlatform "programs.plasma" pkgs lib.platforms.linux)
    ];

    home.packages =
      with pkgs;
      with pkgs.kdePackages;
      [
        copy-forms
        kcalc
        kcolorchooser
        qt6.qtimageformats
        plasma-dark-mode
      ]
      ++ lib.optionals config.profiles.gui.extra.enable [
        akregator
        kgpg
        haruna
        skanpage
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
        extensions.packages = [ pkgs.nur.repos.rycee.firefox-addons.plasma-integration ];
      };
    };

    programs.dolphin.enable = true;
    programs.kmail.enable = true;
    programs.konsole.enable = true;
    programs.okular.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      configPackages = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };
  })

]
