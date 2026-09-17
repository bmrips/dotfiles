{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.dualboot.windows;
in
{

  options.dualboot.windows = {
    enable = lib.mkEnableOption "Windows dual booting";
    mountPoint = lib.mkOption {
      description = "Mount point of the Microsoft basic data partition.";
      default = "/media/windows";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices.disk.main.content.partitions = {
      "Microsoft reserved" = {
        type = "0C01";
        priority = 290;
        size = "16M";
      };
      "Microsoft basic data" = {
        type = "0700";
        priority = 300;
      };
      "Windows recovery" = {
        type = "2700";
        priority = 310;
        size = "781M";
      };
    };

    fileSystems.${cfg.mountPoint} = {
      inherit (config.disko.devices.disk.main.content.partitions."Microsoft basic data") device;
      fsType = "ntfs-3g";
      options = [
        "dmask=0077"
        "fmask=0177"
        "noauto" # We can not assume that Windows has already been reinstalled
        "uid=${toString config.users.users.${user}.uid}"
        "X-mount.mkdir"
      ];
    };

    services.bt-dualboot = {
      inherit (config.hardware.bluetooth) enable;
      inherit (cfg) mountPoint;
      registryBackups.retentionPeriod = "4 weeks";
    };
  };

}
