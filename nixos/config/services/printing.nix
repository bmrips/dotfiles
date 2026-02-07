{
  config,
  lib,
  pkgs,
  user,
  ...
}:

lib.mkMerge [
  {
    services.printing.drivers = with pkgs; [ epson-workforce-635-nx625-series ];
  }

  (lib.mkIf config.services.printing.enable {
    # Enable automatic discovery of network printers and scanners
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    users.users.${user}.extraGroups = [ "lp" ];
  })
]
