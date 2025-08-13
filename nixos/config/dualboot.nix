{ config, lib, ... }:

let
  cfg = config.dualboot.windows;

  mountPoint = "/mnt/windows";

in
{

  options.dualboot.windows.device = lib.mkOption {
    type = with lib.types; nullOr str;
    default = null;
    description = "The Windows device.";
    example = "/dev/disk/by-uuid/16E2EEDDE2EEBFDB";
  };

  config = lib.mkIf (cfg.device != null) {
    fileSystems.${mountPoint} = {
      inherit (cfg) device;
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
    services.bt-dualboot = {
      inherit (config.hardware.bluetooth) enable;
      inherit mountPoint;
      registryBackups.retentionPeriod = "4 weeks";
    };
  };

}
