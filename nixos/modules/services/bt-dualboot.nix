{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    removePrefix
    removeSuffix
    strings
    types
    ;
  cfg = config.services.bt-dualboot;

  escape =
    s:
    builtins.replaceStrings [ "/" ] [ "-" ] (
      removePrefix "/" (removeSuffix "/" (strings.normalizePath s))
    );
  escapedMountPoint = escape cfg.mountPoint;

in
{

  options.services.bt-dualboot = {
    enable = mkEnableOption "{command}`bt-dualboot`";
    mountPoint = mkOption {
      type = types.str;
      description = "The mount point of the Windows data partition.";
      example = "/mnt";
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.bt-dualboot ];

    systemd.services.bt-dualboot = {
      description = "Copy bluetooth pairing keys from Windows";
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
