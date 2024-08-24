{ config, lib, user, ... }:

lib.mkIf config.networking.networkmanager.enable {
  users.users."${user}".extraGroups = [ "networkmanager" ];
}
