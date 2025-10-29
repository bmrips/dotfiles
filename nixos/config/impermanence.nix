{ config, lib, ... }:

{
  options.impermanence.enable = lib.mkEnableOption "an impermanent root file system";

  config = lib.mkIf config.impermanence.enable {

    assertions = [
      {
        assertion = config.btrfs.device != null;
        message = ''
          impermanence: requires a Btrfs device. Set {option}`btrfs.device`.
        '';
      }
    ];

    preservation.enable = true;

    btrfs.subvolumeMounts = {
      home = "/home";
      nix = "/nix";
    };

    boot.initrd.systemd.services.erase-root = {
      description = "Erase the /root subvolume";
      wantedBy = [ "sysroot.mount" ];
      before = [ "sysroot.mount" ];
      requires = [ "initrd-root-device.target" ];
      after = [ "initrd-root-device.target" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        echo "Mount the Btrfs volume"
        mkdir -p /mnt
        mount -o ${lib.concatStringsSep "," config.btrfs.mountOptions} /dev/mapper/nixos /mnt
        mkdir -p /mnt/prev_roots

        echo "Delete previous /root subvolumes older than 30 days"
        find /mnt/prev_roots/ -maxdepth 1 -mtime +30 \
          -exec btrfs subvolume delete --recursive {} +

        echo "Move the current /root subvolume to /prev_roots"
        timestamp="$(date --iso-8601=minutes --date="@$(stat -c %Y /mnt/root)")"
        mv /mnt/root "/mnt/prev_roots/$timestamp"

        echo "Initialize the new /root subvolume"
        btrfs subvolume create /mnt/root
        umount /mnt
      '';
    };

  };
}
