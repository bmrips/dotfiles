{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) hostPlatform;

in
{
  options.profiles.linux.enable = lib.mkEnableOption "the Linux profile" // {
    default = hostPlatform.isLinux;
    defaultText = "pkgs.stdenv.hostPlatform.isLinux";
  };

  config = lib.mkIf config.profiles.linux.enable {

    assertions = [
      {
        assertion = hostPlatform.isLinux;
        message = "This profile is only available on Linux.";
      }
    ];

    home.shellAliases = {
      open = "xdg-open";
      trash = "mv -t ${config.xdg.dataHome}/Trash/files";
      xc = "wl-copy";
      xp = "wl-paste";

      # List all processes and the systemd units they belong to.
      ps-systemd = "ps xawf -eo pid,user,cgroup,args";
    };
    # Compact Firefox UI.
    programs.firefox.profiles.default.settings."browser.uidensity" = 1;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
      defaultCacheTtl = 3600; # at least one hour
      maxCacheTtl = 43200; # 12 hours at most
    };

    services.owncloud-client.enable = true;
    services.ssh-agent.enable = true;

    xdg.userDirs.enable = true;

  };
}
