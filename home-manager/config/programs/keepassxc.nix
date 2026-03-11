{
  config,
  lib,
  nixosConfig,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.programs.keepassxc;

  windowsCfg = nixosConfig.dualboot.windows;
  isDualBooted = nixosConfig != null && windowsCfg.device != null;
  escapedWindowsMountPoint = utils.escapeSystemdPath windowsCfg.mountPoint;
in
{
  options.programs.keepassxc.databasePath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Documents/passwords.kdbx";
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
        settingsFiles = [ config.sops.secrets."firefox_extensions/keepassxc-browser".path ];
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

      systemd.user.services.keepassxc-copy-database = lib.mkIf isDualBooted {
        Unit = {
          Description = "Copy the KeePassXC database to Windows before shutdown";
          Requires = [ "${escapedWindowsMountPoint}.mount" ];
          After = [ "${escapedWindowsMountPoint}.mount" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = lib.concatStringsSep " " [
            "${pkgs.coreutils}/bin/cp"
            "--update"
            cfg.databasePath
            "${windowsCfg.mountPoint}/Users/bened/Desktop/"
          ];
        };
      };
    })
  ];
}
