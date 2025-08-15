{ config, lib, ... }:

let
  cfg = config.dualboot.windows;
in
{

  options.dualboot.windows = {
    device = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = "The Windows device.";
      example = "/dev/disk/by-uuid/16E2EEDDE2EEBFDB";
    };
    mountPoint = lib.mkOption {
      type = lib.types.str;
      default = "/media/windows";
      description = "Path where the Windows system is mounted.";
    };
  };

  config = lib.mkIf (cfg.device != null) {
    fileSystems.${cfg.mountPoint} = {
      inherit (cfg) device;
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
    services.bt-dualboot = {
      inherit (config.hardware.bluetooth) enable;
      inherit (cfg) mountPoint;
      registryBackups.retentionPeriod = "4 weeks";
    };
  };

}
