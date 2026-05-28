{ config, lib, ... }:

lib.mkIf config.programs.steam.enable {
  boot.kernelModules = [ "ntsync" ];
  programs.gamemode.enable = true;
}
