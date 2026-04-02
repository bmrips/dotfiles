{ config, lib, ... }:

lib.mkIf config.programs.steam.enable {
  boot.kernelModules = [ "ntsync" ];
}
