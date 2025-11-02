{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) hostPlatform;

  hasTPM2 = config.submoduleSupport.enable && osConfig.security.tpm2.enable;

in
{
  options.profiles.linux.enable = lib.mkEnableOption "the Linux profile" // {
    default = hostPlatform.isLinux;
    defaultText = "pkgs.stdenv.hostPlatform.isLinux";
  };

  config = lib.mkIf config.profiles.linux.enable {

    assertions = [
      (lib.hm.assertions.assertPlatform "profiles.linux" pkgs lib.platforms.linux)
    ];

    # List all processes and the systemd units they belong to.
    home.shellAliases.ps-systemd = "ps xawf -eo pid,user,cgroup,args";

    # Compact Firefox UI.
    programs.firefox.profiles.default.settings."browser.uidensity" = 1;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
      defaultCacheTtl = 3600; # at least one hour
      maxCacheTtl = 43200; # 12 hours at most
    };

    services.nextcloud-client.enable = true;
    services.ssh-agent.enable = true;
    services.ssh-tpm-agent.enable = hasTPM2;

    # Put the cache into a subvolume and clean files older than 4 weeks.
    systemd.user.tmpfiles.rules = [ "v %C - - - '4 weeks'" ];

    xdg.userDirs.enable = true;

  };
}
