{ config, lib, user, ... }:

with lib;

{
  config.users.users."${user}".extraGroups =
    mkIf config.networking.networkmanager.enable [ "networkmanager" ];
}
