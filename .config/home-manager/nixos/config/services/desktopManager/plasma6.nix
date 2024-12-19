{
  config,
  lib,
  user,
  ...
}:

lib.mkIf config.services.desktopManager.plasma6.enable {
  home-manager.users.${user}.programs.plasma.enable = true;
  profiles.gui.enable = true;
  services.displayManager.sddm.enable = true;
}
