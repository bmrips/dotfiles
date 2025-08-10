{ config, lib, ... }:

let
  cfg = config.dualboot.windows;

  mountPoint = "/mnt/windows";

in
{

  options.dualboot.windows.uuid = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = "The UUID of the Windows partition.";
    example = "16E2EEDDE2EEBFDB";
  };

  config = lib.mkIf (cfg.uuid != null) {
    fileSystems.${mountPoint} = {
      device = "/dev/disk/by-uuid/${cfg.uuid}";
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
    services.bt-dualboot = {
      enable = true;
      inherit mountPoint;
    };
  };

}
