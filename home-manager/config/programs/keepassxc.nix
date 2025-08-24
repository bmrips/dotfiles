{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.keepassxc;

  unlock = ''
    ${pkgs.dbus}/bin/dbus-send --type=method_call --print-reply \
        --dest=org.keepassxc.KeePassXC.MainWindow \
        /keepassxc org.keepassxc.KeePassXC.MainWindow.openDatabase \
        string:${config.home.homeDirectory}/Cloud/Documents/passwords.kdbx \
        string:"$(cat ${config.sops.secrets.keepassxc_password.path})"
  '';

  unlockedKeepassxc =
    let
      desktopFile = "org.keepassxc.KeePassXC.desktop";
      wrapper = pkgs.writeShellScript "keepassxc" ''
        ${cfg.package}/bin/keepassxc "$@" &
        sleep 1
        ${unlock}
      '';
    in
    pkgs.runCommandLocal desktopFile { } ''
      substitute \
        ${cfg.package}/share/applications/${desktopFile} $out \
        --replace-fail \
        'Exec=keepassxc %f' \
        'Exec=${wrapper} %f'
    '';

  unlockAfterScreensaverDeactivation =
    let
      dbus-monitor = "${pkgs.dbus}/bin/dbus-monitor";
      rg = "${pkgs.ripgrep}/bin/rg";
    in
    pkgs.writeShellScript "keepassxc-unlock" ''
      ${dbus-monitor} type=signal,interface=org.freedesktop.ScreenSaver,path=/ScreenSaver,member=ActiveChanged |
          ${rg} 'boolean false' --line-buffered |
          while read -r; do
              echo 'Unlocking the KeePassXC database...'
              ${unlock}
          done
    '';

in
{
  options.programs.keepassxc.autounlock = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Whether to unlock Keepassxc automatically on login and screen unlocking.
    '';
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
        SSHAgent.Enabled = true;
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
      programs.firefox.profiles.default.extensions'.keepassxc-browser = {
        package = pkgs.nur.repos.rycee.firefox-addons.keepassxc-browser;
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
            placement.value = 5; # centered
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
            placement.value = 5; # centered
            size.value = "600,528";
          };
        }
      ];
    })

    (lib.mkIf (cfg.enable && cfg.autounlock) {
      # For auto-unlocking, we want to use a custom autostart unit.
      programs.keepassxc.autostart = lib.mkOverride 90 false;

      sops.secrets.keepassxc_password = { };

      systemd.user.services.keepassxc-unlock = {
        Unit.Description = "Unlocks the KeePassXC database after unlocking the screen";
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = "${unlockAfterScreensaverDeactivation}";
      };

      xdg.autostart.entries = [ "${unlockedKeepassxc}" ];
    })
  ];
}
