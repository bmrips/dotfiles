{ config, ... }:

{
  config.services.xserver.enable = config.services.displayManager.sddm.enable;
}
