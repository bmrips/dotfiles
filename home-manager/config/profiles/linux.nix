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

    # List all processes and the Systemd units they belong to.
    home.shellAliases.ps-systemd = "ps xawf -eo pid,user,cgroup,args";

    # Compact Firefox UI.
    programs.firefox.profiles.default.settings."browser.uidensity" = 1;

    # Use TPM-sealed SSH keys if available.
    programs.keepassxc.settings.SSHAgent.Enabled = !hasTPM2;

    services.nextcloud-client.enable = true;
    services.ssh-agent.enable = !hasTPM2;
    services.ssh-tpm-agent.enable = hasTPM2;

    # Put the cache into a subvolume and clean files older than 4 weeks.
    systemd.user.tmpfiles.rules = [ "v %C - - - '4 weeks'" ];

    xdg.userDirs.enable = true;

  };
}
