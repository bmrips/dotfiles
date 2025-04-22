{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    types
    ;
  cfg = config.programs.keepassxc;

in
{

  options.programs.keepassxc.autostart = mkOption {
    type = types.bool;
    default = false;
    description = "Whether Keepassxc starts automatically on login.";
  };

  config.xdg.autostart.entries = mkIf (cfg.enable && cfg.autostart) [
    "${cfg.package}/share/applications/org.keepassxc.KeePassXC.desktop"
  ];

}
