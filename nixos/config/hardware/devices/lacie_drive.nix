{ config, lib, ... }:

let
  name = "lacie";

in
{
  options.hardware.devices.lacie_drive.enable = lib.mkEnableOption "the external Lacie drive";

  config = lib.mkIf config.hardware.devices.lacie_drive.enable {
    environment.etc.crypttab.text = ''
      ${name} UUID=17a21a62-269e-4d40-a28d-1d49ae100d36 /etc/keys/${name}.key noauto
    '';
    fileSystems."/mnt/${name}" = {
      # Refer to encrypted volumes as /dev/mapper/<volume> to disable timeouts.
      # See https://github.com/NixOS/nixpkgs/issues/250003 for more information.
      device = "/dev/mapper/${name}";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress=zstd"
        "autodefrag"
        "space_cache=v2"
        "noauto"
      ];
    };
  };
}
