{ config, lib, ... }:

let
  cfg = config.btrfs;

  mkOptions = lib.flip lib.pipe [
    (lib.filterAttrs (_: v: (!builtins.isBool v) || v))
    (lib.mapAttrsToList (
      name: value:
      if builtins.isBool value then
        name
      else if builtins.isInt value then
        "${name}=${toString value}"
      else
        "${name}=${value}"
    ))
  ];

in
{
  options.btrfs = {

    device = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "/dev/disk/by-partlabel/NixOS";
      description = "The device containing the Btrfs volume";
    };

    mountOptions = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          int
          str
        ]);
      default = { };
      example.autodefrag = true;
      apply = mkOptions;
      description = "Mount options that are used for all subvolume mounts.";
    };

    subvolumeMounts = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example.root = "/";
      description = ''
        The subvolumes to be mounted. The attribute denotes the path to the
        subvolume and the value denotes its mount point.
      '';
    };

  };

  config = lib.mkIf (cfg.device != null) {
    fileSystems = lib.flip lib.mapAttrs' cfg.subvolumeMounts (
      subvolume: mountPoint: {
        name = mountPoint;
        value = {
          inherit (cfg) device;
          fsType = "btrfs";
          options = cfg.mountOptions ++ [ "subvol=${subvolume}" ];
        };
      }
    );

    services.btrfs.autoScrub.enable = true;
  };
}
