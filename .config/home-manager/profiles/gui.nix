{ config, lib, pkgs, ... }:

with lib;

{
  options.profiles.gui.enable = mkEnableOption "the GUI profile";

  config = mkIf config.profiles.gui.enable {
    home.packages = with pkgs; [ keepassxc spotify ];
    programs.firefox.enable = true;
  };
}
