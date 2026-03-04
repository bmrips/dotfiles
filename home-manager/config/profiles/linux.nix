{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.profiles.linux.enable = lib.mkEnableOption "the Linux profile" // {
    default = pkgs.stdenv.hostPlatform.isLinux;
    defaultText = "pkgs.stdenv.hostPlatform.isLinux";
  };

  config = lib.mkIf config.profiles.linux.enable {

    assertions = [
      (lib.hm.assertions.assertPlatform "profiles.linux" pkgs lib.platforms.linux)
    ];

    # List all processes and the Systemd units they belong to.
    home.shellAliases.ps-systemd = "ps xawf -eo pid,user,cgroup,args";

    # Compact Firefox UI.
    programs.firefox.profiles.default.settings."browser.uidensity" = 1;

    services.nextcloud-client.enable = true;

    # Put the cache into a subvolume and clean files older than 4 weeks.
    systemd.user.tmpfiles.rules = [ "v %C - - - '4 weeks'" ];

    xdg.userDirs.enable = true;

  };
}
