{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.keepassxc;

in {

  options.programs.keepassxc = {
    enable = mkEnableOption "KeePassXC";
    package = mkPackageOption pkgs "keepassxc" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.firefox.nativeMessagingHosts = [ cfg.package ];
  };

}
