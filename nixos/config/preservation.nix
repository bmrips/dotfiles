{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [

  {
    preservation.preserveAt."/persistent" = {
      files = [
        "/etc/adjtime"
        {
          file = "/etc/machine-id";
          mode = "0444";
          inInitrd = true;
        }
        {
          file = "/var/lib/logrotate.status";
          mode = "0600";
          how = "symlink";
        }
      ];
      directories = [
        {
          directory = "/var/lib/nixos/";
          inInitrd = true;
        }
        {
          directory = "/var/lib/sops/";
          inInitrd = lib.any (s: s.neededForUsers) (lib.attrValues config.sops.secrets);
        }
        "/var/lib/systemd/"
        "/var/log/"
      ]
      ++ lib.optional config.boot.lanzaboote.enable config.boot.lanzaboote.pkiBundle
      ++ lib.optional config.hardware.bluetooth.enable "/var/lib/bluetooth/"
      ++ lib.optional config.networking.networkmanager.enable {
        directory = "/etc/NetworkManager/system-connections/";
        mode = "0700";
      }
      ++ lib.optional config.services.accounts-daemon.enable "/var/lib/AccountsService/"
      ++ lib.optional config.services.bt-dualboot.enable "/var/backup/bt-dualboot/"
      ++ lib.optional config.services.colord.enable {
        directory = "/var/lib/colord/";
        user = "colord";
        group = "colord";
      }
      ++ lib.optional config.services.hardware.bolt.enable "/var/lib/boltd/"
      ++ lib.optional config.services.tlp.enable "/var/lib/tlp/"
      ++ lib.optional config.services.upower.enable "/var/lib/upower/";
    };
  }

  (lib.mkIf config.preservation.enable {
    btrfs.subvolumeMounts = {
      root = "/";
      persistent = "/persistent";
    };

    fileSystems."/persistent".neededForBoot = true;

    systemd.services.systemd-machine-id-commit = {
      description = "Save the transient machine ID to the persistent volume";
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persistent/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persistent"
      ];
    };

    # When the time zone is managed imperatively, copy `/etc/localtime` manually
    # since it is a symlink and hence can not be mounted.
    systemd.services.persist-timezone = lib.mkIf (config.time.timeZone == null) {
      description = "Persist `/etc/localtime`";
      wantedBy = [ "multi-user.target" ];
      unitConfig.RequiresMountsFor = "/persistent";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/cp --no-dereference /persistent/etc/localtime /etc/localtime";
        ExecStop = "${pkgs.coreutils}/bin/cp --no-dereference /etc/localtime /persistent/etc/localtime";
      };
    };
  })

]
