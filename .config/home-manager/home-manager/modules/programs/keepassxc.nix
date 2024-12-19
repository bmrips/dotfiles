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
  cfg = config.programs.keepassxc;

in
{

  options.programs.keepassxc = {
    enable = mkEnableOption "KeePassXC";
    package = mkPackageOption pkgs "keepassxc" { };
    autostart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether Keepassxc starts automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.firefox.nativeMessagingHosts = [ cfg.package ];
    xdg.autostart.keepassxc = mkIf cfg.autostart "${cfg.package}/share/applications/org.keepassxc.KeePassXC.desktop";
  };

}
