{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.keepassxc;
in
{
  options.programs.keepassxc.databasePath = lib.mkOption {
    type = lib.types.str;
    default = "~/Documents/passwords.kdbx";
    description = "The path to the database.";
  };

  config = lib.mkMerge [
    {
      programs.keepassxc.autostart = true;

      programs.keepassxc.settings = {
        Browser.Enabled = true;
        Browser.UpdateBinaryPath = false;
        General.ConfigVersion = 2;
        General.HideWindowOnCopy = true;
        Security.IconDownloadFallback = true;
        Security.LockDatabaseIdle = false;
        SSHAgent.Enabled = config.services.ssh-agent.enable;
        GUI = {
          ApplicationTheme = "classic";
          CheckForUpdates = false;
          HidePreviewPanel = true;
          HideToolbar = true;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };
      };
    }

    (lib.mkIf cfg.enable {
      sops.secrets."firefox_extensions/keepassxc-browser" = { };

      programs.firefox.profiles.default.extensions'.keepassxc-browser = {
        package = pkgs.firefox-addons.keepassxc-browser;
        permissions = [
          "internal:privateBrowsingAllowed"
          "privacy"
        ];
        settings.settings = {
          autoFillSingleTotp = true;
          autoReconnect = true;
          checkUpdateKeePassXC = 0;
          defaultGroupAlwaysAsk = true;
          defaultPasswordManager = true;
          downloadFaviconAfterSave = true;
          saveDomainOnly = true;
          saveDomainOnlyNewCreds = true;
        };
        settingsFiles = config.lib.sops.pathUnit "firefox_extensions/keepassxc-browser";
      };

      programs.plasma.window-rules = [
        {
          description = "KeePassXC - Browser Access Request";
          match = {
            title.value = "KeePassXC - Browser Access Request";
            window-class.value = "keepassxc org.keepassxc.KeePassXC";
          };
          apply = {
            maximizehoriz = false;
            maximizevert = false;
            placement.apply = "force";
            placement.value = 5; # centred
            size.value = "464,291";
          };
        }
        {
          description = "KeePassXC";
          match.window-class.value = "keepassxc org.keepassxc.KeePassXC";
          apply = {
            maximizehoriz = false;
            maximizevert = false;
            placement.apply = "force";
            placement.value = 5; # centred
            size.value = "600,528";
          };
        }
      ];
    })
  ];
}
