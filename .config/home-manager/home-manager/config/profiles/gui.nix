{ config, lib, pkgs, ... }:

with lib;

let inherit (pkgs.stdenv.hostPlatform) isLinux;

in {
  options.profiles.gui.enable = mkEnableOption "the GUI profile";

  config = mkIf config.profiles.gui.enable {
    home.packages = with pkgs;
      [ logseq signal-desktop spotify ]
      ++ optionals isLinux [ libreoffice-qt vlc ];
    programs.firefox.enable = true;
    programs.keepassxc.enable = true;
  };
}
