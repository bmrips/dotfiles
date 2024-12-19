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

  signal-desktop-in-system-tray = pkgs.runCommandLocal "signal-desktop.desktop" { } ''
    substitute \
      ${cfg.package}/share/applications/signal-desktop.desktop $out \
      --replace-fail \
      'Exec=signal-desktop --no-sandbox %U' \
      'Exec=signal-desktop --no-sandbox %U --use-tray-icon --start-in-tray'
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
    xdg.autostart.signal = mkIf cfg.autostart "${signal-desktop-in-system-tray}";
  };

}
