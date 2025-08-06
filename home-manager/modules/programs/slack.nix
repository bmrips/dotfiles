{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.slack;

in
{

  options.programs.slack = {
    enable = lib.mkEnableOption "Slack.";
    package = lib.mkPackageOption pkgs "slack" { };
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Slack starts automatically on login.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = lib.mkIf cfg.autostart [
      "${cfg.package}/share/applications/slack.desktop"
    ];
  };

}
