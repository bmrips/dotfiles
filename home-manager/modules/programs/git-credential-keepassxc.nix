{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.git-credential-keepassxc;

  helperConfig =
    let
      group = if cfg.group == null then "--git-groups" else "--group ${cfg.group}";
    in
    {
      helper = "${cfg.package}/bin/git-credential-keepassxc ${group}";
    };

in
{

  options.programs.git-credential-keepassxc = {
    enable = lib.mkEnableOption "{command}`git-credential-keepassxc`.";
    package = lib.mkPackageOption pkgs "git-credential-keepassxc" { };
    group = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        The KeePassXC group used for storing and fetching of credentials. By
        default, the group created by
        {command}`git-credential-keepassxc configure [--group <GROUP>]` is used.
      '';
      example = "Git";
    };
    hosts = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Hosts to enable the {command}`git-credential-keepassxc` for.";
      example = [ "https://github.com" ];
    };
  };

  config = {
    home.packages = [ cfg.package ];
    programs.git.extraConfig.credential = lib.mkIf cfg.enable (
      if cfg.hosts == [ ] then
        helperConfig
      else
        lib.listToAttrs (map (host: lib.nameValuePair host helperConfig)) cfg.hosts
    );
  };

}
