{ config, lib, user, ... }:

with lib;

{
  options.profiles.gui.enable = mkEnableOption "the GUI profile";

  config = mkIf config.profiles.gui.enable {
    home-manager.users."${user}".profiles.gui.enable = true;
    programs.ausweisapp.enable = true;
  };
}
