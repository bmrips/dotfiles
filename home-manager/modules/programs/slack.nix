{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.slack;

  minimizedSlack =
    let
      desktopFile = "slack.desktop";
    in
    pkgs.runCommandLocal desktopFile { } ''
      substitute \
        ${cfg.package}/share/applications/${desktopFile} $out \
        --replace-fail \
        'Exec=${cfg.package}/bin/slack -s %U' \
        'Exec=${cfg.package}/bin/slack --silent --startup %U'
    '';
in
{

  options.programs.slack = {
    enable = lib.mkEnableOption "Slack";
    package = lib.mkPackageOption pkgs "slack" { };
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether Slack starts automatically on login.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.autostart.entries = lib.mkIf cfg.autostart [ minimizedSlack ];
  };

}
