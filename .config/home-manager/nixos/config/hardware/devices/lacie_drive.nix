{ config, lib, ... }:

with lib;

{
  options.hardware.devices.lacie_drive.enable =
    mkEnableOption "the external Lacie drive";

  config = mkIf config.hardware.devices.lacie_drive.enable {
    environment.etc.crypttab.text = ''
      lacie UUID=17a21a62-269e-4d40-a28d-1d49ae100d36 /etc/keys/lacie.key noauto
    '';
    fileSystems."/mnt/lacie" = {
      device = lib.uuid "0f7e2383-88f3-4915-be43-f4b47053812a";
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
