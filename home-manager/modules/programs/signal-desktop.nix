{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.programs.signal-desktop;

  signal-desktop-in-system-tray =
    let
      desktopFile = "signal-desktop.desktop";
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
    enable = mkEnableOption "Signal Desktop.";
    package = mkPackageOption pkgs "signal-desktop" { };
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether Signal Desktop starts automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = mkIf cfg.autostart [
      "${signal-desktop-in-system-tray}"
    ];
  };

}
