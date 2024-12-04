{ config, lib, pkgs, user, ... }:

lib.mkIf config.services.printing.enable {
  services.printing.drivers = with pkgs; [ epson-workforce-635-nx625-series ];

  # Enable autodiscovery of network printers and scanners
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  users.users.${user}.extraGroups = [ "lp" ];
}
