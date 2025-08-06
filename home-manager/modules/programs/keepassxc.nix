{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.keepassxc;

in
{

  options.programs.keepassxc.autostart = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether Keepassxc starts automatically on login.";
  };

  config.xdg.autostart.entries = lib.mkIf (cfg.enable && cfg.autostart) [
    "${cfg.package}/share/applications/org.keepassxc.KeePassXC.desktop"
  ];

}
