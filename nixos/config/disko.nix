{
  config,
  host,
  lib,
  ...
}:

{
  options.disko.enable = lib.mkEnableOption "disko";

  config = lib.mkIf config.disko.enable {
    disko.devices.disk.main.content = {
      type = "gpt";
      partitions = {
        "EFI system" = {
          type = "EF00";
          priority = 150; # place the ESP first
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "dmask=0077"
              "fmask=0177"
              "nodev"
              "noexec"
              "nosuid"
            ];
          };
        };
        Swap.content = {
          type = "swap";
          mountOptions = [ "nofail" ];
          randomEncryption = true;
        };
        LUKS = {
          type = "8309";
          size = "100%";
          content = {
            type = "luks";
            name = "nixos";
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = lib.mkIf config.boot.lanzaboote.enable [
                "tpm2-device=auto"
                "tpm2-measure-pcr=yes"
              ];
            };
            content = {
              type = "btrfs";
              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
                "lazytime"
                "rw"
                "strictatime"
              ];
              subvolumes = {
                "home" = { };
                "nix" = { };
                "var/cache" = { };
              };
            };
          };
        };
      };
    };

    boot.kernelParams = [ "zswap.enabled=1" ];

    services.btrbk.instances.btrbk = {
      onCalendar = "hourly";
      snapshotOnly = true; # the backup disk is offline
      settings.volume."/" = {
        snapshot_dir = "snapshots";
        target = "${config.hardware.devices.lacie_drive.mountPoint}/backup/${host}";
        subvolume.home = {
          snapshot_preserve_min = "2d";
          snapshot_preserve = "14d";
          target_preserve_min = "latest"; # in case of an emergency backup
          target_preserve = "12w *m";
        };
      };
    };

    services.btrfs.autoScrub.enable = true;
  };
}
