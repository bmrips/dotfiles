{ config, lib, pkgs, ... }:

with lib;

let inherit (pkgs.stdenv.hostPlatform) isLinux;

in {
  options.profiles.gui.enable = mkEnableOption "the GUI profile";

  config = mkIf config.profiles.gui.enable {
    home.packages = with pkgs;
      [ keepassxc spotify ]
      ++ (if isLinux then [ libreoffice-qt signal-desktop vlc ] else [ ]);
    programs.firefox.enable = true;
  };
}
