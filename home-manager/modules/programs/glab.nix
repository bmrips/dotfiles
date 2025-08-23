{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.glab;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.glab = {
    enable = lib.mkEnableOption "{command}`glab`.";
    package = lib.mkPackageOption pkgs "glab" { };
    aliases = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Aliases written to {file}`$XDG_CONFIG_HOME/glab-cli/aliases.yml`.";
      example.co = "mr checkout";
    };
    settings = lib.mkOption {
      inherit (yaml) type;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glab-cli/config.yml`.";
      example.check_update = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # The mode of the configuration file has to be 0600.
    home.file'.".config/glab-cli/config.yml" = lib.mkIf (cfg.settings != { }) {
      mode = "0600";
      sources = yaml.generate "glab-cli_config.yml" cfg.settings;
      type = "yaml";
    };

    xdg.configFile."glab-cli/aliases.yml" = lib.mkIf (cfg.aliases != { }) {
      source = yaml.generate "glab-cli_aliases.yml" cfg.aliases;
    };
  };
}
