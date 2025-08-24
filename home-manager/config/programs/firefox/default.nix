{
  config,
  host,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.sops) secrets;
  inherit (pkgs.nur.repos.rycee) firefox-addons;

  toAction =
    addon:
    let
      normalizedAddonId = lib.toLower (
        lib.replaceStrings [ "." "@" "{" "}" ] [ "_" "_" "_" "_" ] addon.addonId
      );
    in
    "${normalizedAddonId}-browser-action";

  addonActions = lib.mapAttrs (_: toAction) firefox-addons;

in
lib.mkIf config.programs.firefox.enable {

  programs.firefox = {

    policies.SearchBar = "unified";

    profiles.default = {

      settings = {
        # Do not warn when visiting about:config.
        "browser.aboutConfig.showWarning" = false;

        # Restore the last session.
        "browser.startup.page" = 3;

        # Disable the builtin password manager.
        "signon.rememberSignons" = false;

        # Disable accessibility.
        "accessibility.force_disabled" = true;

        # Enable automatic scrolling.
        "general.autoScroll" = true;

        # Do not check whether Firefox is the default browser.
        "browser.shell.checkDefaultBrowser" = true;

        # Configure synchronisation.
        "services.sync.username" = "benedikt.rips@gmail.com";
        "identity.fxaccounts.account.device.name" = host;

        # Website appearance matches the system theme.
        "browser.display.use_system_colors" = true;

        # Do not create default bookmarks.
        "browser.bookmarks.restore_default_bookmarks" = false;

        # Never show the bookmarks toolbar.
        "browser.toolbars.bookmarks.visibility" = "never";

        # Do not show the menu toolbar when pressing Alt.
        "ui.key.menuAccessKeyFocuses" = false;

        # Save files to ~/Downloads without asking.
        "browser.download.folderList" = 2;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.download.useDownloadDir" = true;

        # Never translate German.
        "browser.translations.neverTranslateLanguages" = "de";

        # Do not suggest recent searches or open tabs.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.openpage" = false;

        # Hide the tab close button.
        "browser.tabs.tabClipWidth" = 999;

        # Highlight all search results on a page.
        "findbar.highlightAll" = true;

        # Use Jetbrains Mono with Nerd font patches as monospaced font.
        "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";
        "font.size.monospace.x-western" = 14;
        "font.size.variable.x-western" = 17;

        # Use system locale settings.
        "intl.regional_prefs.use_os_locales" = true;

        # Smooth full-screen transitions.
        "full-screen-api.transition-duration.enter" = "200 200";
        "full-screen-api.transition-duration.leave" = "200 200";

        # Disable the full screen warning.
        "full-screen-api.warning.timeout" = 0;

        # Unload tabs after 5 minutes.
        "browser.tabs.min_inactive_duration_before_unload" = "300000";

        # Increase the speed of processing images.
        "image.mem.decode_bytes_at_a_time" = 131072;

        # http://forums.mozillazine.org/viewtopic.php?f=7&t=2416193
        # https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74561.html
        "network.buffer.cache.size" = 262144;
        "network.buffer.cache.count" = 128;

        # Increase SSL and DNS caches
        "network.ssl_tokens_cache_capacity" = 32768;
        "network.dnsCacheEntries" = 2000;
        "network.dnsCacheExpiration" = 7200; # 2 hours
        "network.dnsCacheExpirationGracePeriod" = 3600; # 1 hour

        # Use the XDG desktop portal.
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;

        # Do not print header and footer.
        "print.print_footerleft" = "";
        "print.print_headerright" = "";

        # Disable slow startup notifications.
        "browser.slowStartup.maxSamples" = 0;
        "browser.slowStartup.notificationDisabled" = true;
        "browser.slowStartup.samples" = 0;

        # Disable domain guessing.
        "browser.fixup.alternate.enabled" = false;

        # Disable Normandy and Shield.
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # Disable experiments.
        "messaging-system.rsexperimentloader.enabled" = false;

        # Disable new tab page and the activity stream.
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

        # Disable extension recommendations.
        "extensions.htmlaboutaddons.recommendations.enabled" = false;

        # Disable Safe Browsing.
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportURL" = "";
        "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportURL" = "";
        "browser.safebrowsing.reportPhishURL" = "";

        # Disable live search suggestions.
        "browser.search.suggest.enabled" = false;

        # Disable geo localization.
        "geo.enabled" = false;

        # Disable Firefox location tracking.
        "browser.region.update.enabled" = false;
        "browser.region.network.url" = "";

        # Deactivate tracking protection and the 'Do not track' header since
        # ironically, they may be used for tracking.
        "privacy.trackingprotection.enabled" = false;
        "privacy.donottrackheader.enabled" = false;

        # Activate total cookie protection which puts each site's cookies in its
        # own container.
        "network.cookie.cookieBehavior" = 5;

        # Use US as locale in javascript.
        "javascript.use_us_english_locale" = true;

        # Disable Pocket and screenshots.
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;

        # Enforce punycode for internationalized domain names to eliminate
        # possible spoofing.
        "network.IDN_show_punycode" = true;

        # Display all parts of the URL in the location bar, e.g. http(s)://.
        "browser.urlbar.trimURLs" = false;

        # Display "insecure" icon and "Not Secure" text on insecure HTTP
        # connections.
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;

        # Operate in HTTPS-only mode.
        "dom.security.https_only_mode" = true;

        # Download mixed content via HTTPS.
        "security.mixed_content.upgrade_display_content" = true;

        # Disable VPN promotion.
        "browser.vpn_promo.enabled" = false;

        # UI state
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [ ];
            nav-bar = with addonActions; [
              "sidebar-button"
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "fxa-toolbar-menu-button"
              tab-session-manager
              zotero-connector
              "unified-extensions-button"
            ];
            unified-extensions-area = with addonActions; [
              auto-sort-bookmarks
              auto-tab-discard
              darkreader
              i-dont-care-about-cookies
              keepassxc-browser
              languagetool
              plasma-integration
              refined-github
              sidebery
              simple-translate
              ublock-origin
              web-search-navigator
            ];
            toolbar-menubar = [ "menubar-items" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "alltabs-button"
            ];
            vertical-tabs = [ ];
            PersonalToolbar = [ "personal-bookmarks" ];
          };
          seen = with addonActions; [
            auto-sort-bookmarks
            auto-tab-discard
            darkreader
            i-dont-care-about-cookies
            keepassxc-browser
            languagetool
            plasma-integration
            refined-github
            sidebery
            simple-translate
            tab-session-manager
            ublock-origin
            web-search-navigator
            zotero-connector
            "developer-button"
          ];
          dirtyAreaCache = [
            "unified-extensions-area"
            "nav-bar"
            "widget-overflow-fixed-list"
            "toolbar-menubar"
            "TabsToolbar"
            "vertical-tabs"
            "PersonalToolbar"
          ];
          currentVersion = 21;
          newElementCount = 7;
        };
      };

      search = {
        force = true;
        default = "google";
        engines =
          let
            nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in
          {
            bing.metaData.hidden = true;
            cloogle = {
              name = "Cloogle";
              definedAliases = [ "@cloogle" ];
              urls = [ { template = "https://cloogle.org/#{searchTerms}"; } ];
            };
            ctan = {
              name = "CTAN";
              definedAliases = [ "@ctan" ];
              icon = "https://ctan.org/assets/favicon/favicon-16x16-ecad89e8a3475c9b10c36f82efef3bcd.png";
              urls = [ { template = "https://ctan.org/search?phrase={searchTerms}"; } ];
            };
            home-manager = {
              name = "Home Manager";
              definedAliases = [
                "@hm"
                "@home-manager"
              ];
              icon = nixIcon;
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
                }
              ];
            };
            hoogle = {
              name = "Hoogle";
              definedAliases = [
                "@h"
                "@hoogle"
              ];
              icon = "https://hoogle.haskell.org/favicon.png";
              urls = [
                {
                  template = "https://hoogle.haskell.org/?hoogle={searchTerms}";
                }
              ];
            };
            nixpkgs = {
              name = "Nix Packages";
              definedAliases = [
                "@np"
                "@nixpkgs"
              ];
              icon = nixIcon;
              urls = [
                {
                  template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                }
              ];
            };
            nixos-options = {
              name = "NixOS Options";
              definedAliases = [
                "@no"
                "@nixosopts"
              ];
              icon = nixIcon;
              urls = [
                {
                  template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                }
              ];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              definedAliases = [
                "@nw"
                "@nixoswiki"
              ];
              icon = nixIcon;
              urls = [
                {
                  template = "https://nixos.wiki/index.php?search={searchTerms}";
                }
              ];
            };
            noogle = {
              name = "Noogle";
              definedAliases = [ "@noogle" ];
              icon = nixIcon;
              urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
            };
            texdoc = {
              name = "texdoc";
              definedAliases = [ "@texdoc" ];
              icon = ./TeX.svg;
              urls = [ { template = "https://texdoc.org/serve/{searchTerms}/0"; } ];
            };
          };
      };

      settings."extensions.autoDisableScopes" = 0; # automatically enable extensions
      settings."extensions.update.autoUpdateDefault" = false;
      extensions' = {
        auto-sort-bookmarks = {
          package = firefox-addons.auto-sort-bookmarks;
          settings.weh-prefs.auto_sort = true;
        };
        auto-tab-discard = {
          package = firefox-addons.auto-tab-discard;
          settings = {
            notification.permission = true;
            online = true;
            paused = true;
            prepends = "";
          };
        };
        darkreader.package = firefox-addons.darkreader;
        i-dont-care-about-cookies.package = firefox-addons.i-dont-care-about-cookies;
        languagetool = {
          package = firefox-addons.languagetool;
          settings = {
            hasPickyModeEnabledGlobally = true;
            hasSynonymsEnabled = true;
            motherTongue = "de";
            preferredLanguages = [
              "en"
              "nl"
            ];
          };
          settingsFiles = [ secrets."firefox_extensions/languagetool".path ];
        };
        refined-github.package = firefox-addons.refined-github;
        sidebery.package = firefox-addons.sidebery;
        simple-translate = {
          package = firefox-addons.simple-translate;
          settings.Settings = {
            deeplPlan = "deeplFree";
            secondTargetLang = "en-US";
            targetLang = "de";
            translationApi = "deepl";
          };
          settingsFiles = [ secrets."firefox_extensions/simple-translate".path ];
        };
        tab-session-manager = {
          package = firefox-addons.tab-session-manager;
          settings.Settings = {
            enabledAutoSync = true;
            ifAutoSave = false;
            ifSupportTst = true;
            saveButtonBehavior = "saveOnlyCurrentWindow";
            shouldTrackNewWindow = false;
          };
          settingsFiles = [ secrets."firefox_extensions/tab-session-manager".path ];
        };
        ublock-origin.package = firefox-addons.ublock-origin;
        web-search-navigator.package = firefox-addons.web-search-navigator;
      };
    };

  };

  sops.secrets = {
    "firefox_extensions/keepassxc-browser" = { };
    "firefox_extensions/languagetool" = { };
    "firefox_extensions/simple-translate" = { };
    "firefox_extensions/tab-session-manager" = { };
  };

  programs.plasma.window-rules = [
    {
      description = "Firefox master password dialog";
      match = {
        window-class = "firefox firefox";
        title = "Password Required - Mozilla Firefox";
      };
      apply = {
        placement.apply = "force";
        placement.value = 5; # centered
      };
    }
    {
      description = "Picture in Picture";
      match = {
        window-class = "firefox firefox";
        title = "Picture-in-Picture";
      };
      apply = {
        above = true;
        desktops = "\\0";
        noborder = true;
        skippager = true;
        skipswitcher = true;
        skiptaskbar = true;
      };
    }
  ];

}
