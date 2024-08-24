{ config, lib, ... }:

with lib;

mkIf config.services.displayManager.sddm.enable {
  services.xserver.enable = true;
}
