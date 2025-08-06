{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.signal-desktop;

  signal-desktop-in-system-tray =
    let
      desktopFile = "signal.desktop";
    in
    pkgs.runCommandLocal desktopFile { } ''
      substitute \
        ${cfg.package}/share/applications/${desktopFile} $out \
        --replace-fail \
        'Exec=signal-desktop %U' \
        'Exec=signal-desktop %U --use-tray-icon --start-in-tray'
    '';

in
{

  options.programs.signal-desktop = {
    enable = lib.mkEnableOption "Signal Desktop.";
    package = lib.mkPackageOption pkgs "signal-desktop" { };
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Signal Desktop starts automatically on login.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = lib.mkIf cfg.autostart [
      "${signal-desktop-in-system-tray}"
    ];
  };

}
