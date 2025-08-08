{
  config,
  lib,
  pkgs,
  user,
  ...
}:

lib.mkIf config.services.desktopManager.plasma6.enable {
  profiles.gui.enable = true;
  services.displayManager.sddm.enable = true;

  home-manager.users.${user} = {
    programs.plasma.enable = true;
    home.packages = lib.mkIf config.services.displayManager.sddm.enable [
      pkgs.kdePackages.sddm-kcm
    ];
  };
}
