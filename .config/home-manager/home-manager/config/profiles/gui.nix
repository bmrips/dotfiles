{ config, lib, pkgs, ... }:

with lib;

let inherit (pkgs.stdenv.hostPlatform) isLinux;

in {
  options.profiles.gui.enable = mkEnableOption "the GUI profile";

  config = mkIf config.profiles.gui.enable {
    home.packages = with pkgs;
      [ keepassxc logseq spotify ]
      ++ optionals isLinux [ libreoffice-qt signal-desktop vlc ];
    nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];
    programs.firefox.enable = true;
  };
}
