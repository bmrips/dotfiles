{
  config,
  lib,
  user,
  ...
}:

lib.mkIf config.hardware.sane.enable {
  users.users.${user}.extraGroups = [ "scanner" ];
}
