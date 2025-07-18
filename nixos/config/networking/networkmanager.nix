{
  config,
  lib,
  user,
  ...
}:

lib.mkIf config.networking.networkmanager.enable {
  networking.networkmanager.wifi.powersave = true;
  users.users.${user}.extraGroups = [ "networkmanager" ];
}
