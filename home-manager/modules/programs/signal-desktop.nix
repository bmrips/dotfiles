{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.signal-desktop;
  json = pkgs.formats.json { };
in
{

  options.programs.signal-desktop = {
    enable = lib.mkEnableOption "Signal Desktop";
    package = lib.mkPackageOption pkgs "signal-desktop" { };
    autostart = lib.mkOption {
      description = "Whether Signal Desktop starts automatically on login.";
      default = false;
      type = lib.types.bool;
    };
    config = lib.mkOption {
      description = ''
        Configuration; is merged into {file}`$XDG_CONFIG_HOME/Signal/config.json`.
      '';
      example = {
        mediaPermissions = true;
        mediaCameraPermissions = true;
      };
      default = { };
      inherit (json) type;
    };
    ephemeralConfig = lib.mkOption {
      description = ''
        Ephemeral configuration; is merged into {file}`$XDG_CONFIG_HOME/Signal/ephemeral.json`.
      '';
      example.system-tray-setting = "MinimizeToAndStartInSystemTray";
      default = { };
      inherit (json) type;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = lib.mkIf cfg.autostart [
      "${cfg.package}/share/applications/signal.desktop"
    ];
    home.file' =
      lib.optionalAttrs (cfg.config != { }) {
        "${config.xdg.configHome}/Signal/config.json" = {
          type = "json";
          sources = [ (json.generate "signal-config.json" cfg.config) ];
        };
      }
      // lib.optionalAttrs (cfg.ephemeralConfig != { }) {
        "${config.xdg.configHome}/Signal/ephemeral.json" = {
          type = "json";
          sources = [ (json.generate "signal-ephemeral.json" cfg.ephemeralConfig) ];
        };
      };
  };

}
