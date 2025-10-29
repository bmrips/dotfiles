{
  config,
  host,
  lib,
  ...
}:

let
  cfg = config.services.btrbk;
in
{
  options.services.btrbk = {
    enable = lib.mkEnableOption "{command}`btrbk`";
    mountPoint = lib.mkOption {
      type = lib.types.str;
      default = "/media/btrfs_root";
      description = "Path where the Btrfs root volume is mounted.";
    };
  };

  config = lib.mkIf cfg.enable {

    btrfs.subvolumeMounts."/" = cfg.mountPoint;

    services.btrbk = {
      instances.${host}.settings.volume.${cfg.mountPoint} = {
        snapshot_dir = "btrbk_snapshots";
        target = "${config.hardware.devices.lacie_drive.mountPoint}/backup/${host}";
        subvolume.home = {
          snapshot_preserve_min = "2d";
          snapshot_preserve = "14d";
          target_preserve_min = "no";
          target_preserve = "12w *m";
        };
      };
    };

  };
}
