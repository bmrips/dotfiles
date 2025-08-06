{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.keepassxc;

  unlock =
    let
      dbus-send = "${pkgs.dbus}/bin/dbus-send";
      secret-tool = "${pkgs.libsecret}/bin/secret-tool";
    in
    ''
      ${dbus-send} --type=method_call --print-reply \
          --dest=org.keepassxc.KeePassXC.MainWindow \
          /keepassxc org.keepassxc.KeePassXC.MainWindow.openDatabase \
          string:${config.home.homeDirectory}/Cloud/Documents/passwords.kdbx \
          string:"$(${secret-tool} lookup keepassxc password)"
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
lib.mkMerge [
  {
    # automatically unlock the database after login and screen locker deactivation
    programs.keepassxc.autostart = false;
  }

  (lib.mkIf cfg.enable {
    xdg.autostart.entries = [ "${unlockedKeepassxc}" ];

    systemd.user.services.keepassxc-unlock = {
      Unit.Description = "Unlocks the KeePassXC database after unlocking the screen";
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${unlockAfterScreensaverDeactivation}";
    };

    programs.firefox.profiles.default.extensions.packages = [
      pkgs.nur.repos.rycee.firefox-addons.keepassxc-browser
    ];

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
]
