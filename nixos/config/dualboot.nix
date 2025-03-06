{ config, lib, ... }:

let
  inherit (lib)
    mkIf
    mkOption
    types
    uuid
    ;

  cfg = config.dualboot.windows;

  mountPoint = "/mnt/windows";

in
{

  options.dualboot.windows.uuid = mkOption {
    type = with types; nullOr str;
    default = null;
    description = "The UUID of the Windows partition.";
    example = "16E2EEDDE2EEBFDB";
  };

  config = mkIf (cfg.uuid != null) {
    fileSystems.${mountPoint} = {
      device = uuid cfg.uuid;
      fsType = "ntfs-3g";
      options = [ "noauto" ];
    };
    services.bt-dualboot = {
      enable = true;
      inherit mountPoint;
    };
  };

}
