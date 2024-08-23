{ config, lib, user, ... }:

with lib;

{
  config.users.users."${user}".extraGroups =
    mkIf config.hardware.sane.enable [ "scanner" ];
}
