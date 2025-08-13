{ config, lib, ... }:

let
  name = "lacie";

in
{
  options.hardware.devices.lacie_drive.enable = lib.mkEnableOption "the external Lacie drive";

  config = lib.mkIf config.hardware.devices.lacie_drive.enable {
    environment.etc.crypttab.text = ''
      ${name} UUID=17a21a62-269e-4d40-a28d-1d49ae100d36 - noauto,tpm2-device=auto
    '';
    fileSystems."/mnt/${name}" = {
      # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
      # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
      device = "/dev/mapper/${name}";
      fsType = "btrfs";
      options = [
        "autodefrag"
        "compress=zstd"
        "lazytime"
        "noauto"
        "rw"
        "space_cache=v2"
        "strictatime"
      ];
    };
    systemd.mounts = [
      {
        overrideStrategy = "asDropin";
        what = "/dev/mapper/${name}";
        where = "/mnt/${name}";
        bindsTo = [ "systemd-cryptsetup@${name}.service" ];
        after = [ "systemd-cryptsetup@${name}.service" ];
      }
    ];
  };
}
