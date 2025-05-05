{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bt-dualboot;

  escapedMountPoint = lib.pipe cfg.mountPoint [
    lib.strings.normalizePath
    (lib.removePrefix "/")
    (lib.removeSuffix "/")
    (builtins.replaceStrings [ "/" ] [ "-" ])
  ];

in
{

  options.services.bt-dualboot = {
    enable = lib.mkEnableOption "{command}`bt-dualboot`";
    package = lib.mkPackageOption pkgs "bt-dualboot" { };
    mountPoint = lib.mkOption {
      type = lib.types.str;
      description = "The mount point of the Windows data partition.";
      example = "/mnt";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.bt-dualboot = {
      description = "Copy bluetooth pairing keys to Windows before shutdown";
      requires = [ "${escapedMountPoint}.mount" ];
      after = [ "${escapedMountPoint}.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.bt-dualboot}/bin/bt-dualboot --win ${cfg.mountPoint} --no-backup --sync-all";
      };
    };

  };

}
