{ config, lib, user, ... }:

with lib;

{
  config = mkIf config.services.desktopManager.plasma6.enable {
    home-manager.users."${user}".profiles.kde-plasma.enable = true;
    profiles.gui.enable = true;
    services.displayManager.sddm.enable = true;
  };
}
