{ config, lib, ... }:

with lib;

{
  config = mkIf config.services.displayManager.sddm.enable {
    services.xserver.enable = true;
  };
}
