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
    mkPackageOption
    types
    ;

  cfg = config.programs.glab;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.glab = {
    enable = mkEnableOption "{command}`glab`.";
    package = mkPackageOption pkgs "glab" { };
    aliases = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Aliases written to {file}`$XDG_CONFIG_HOME/glab-cli/aliases.yml`.";
      example.co = "mr checkout";
    };
    settings = mkOption {
      inherit (yaml) type;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glab-cli/config.yml`.";
      example.check_update = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile = {
      "glab-cli/aliases.yml" = mkIf (cfg.aliases != { }) {
        source = yaml.generate "glab-cli_aliases.yml" cfg.aliases;
      };
      "glab-cli/config.yml" = mkIf (cfg.settings != { }) {
        source = yaml.generate "glab-cli_config.yml" cfg.settings;
      };
    };
  };
}
