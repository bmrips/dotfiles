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
  cfg = config.programs.slack;

in
{

  options.programs.slack = {
    enable = mkEnableOption "Slack.";
    package = mkPackageOption pkgs "slack" { };
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether Slack starts automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.slack = mkIf cfg.autostart "${cfg.package}/share/applications/slack.desktop";
  };

}
