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
    ;

  cfg = config.programs.glab;

  yaml = pkgs.formats.yaml { };

in
{
  options.programs.glab = {
    enable = mkEnableOption "{command}`glab`.";
    package = mkPackageOption pkgs "glab" { };
    settings = mkOption {
      inherit (yaml) type;
      default = { };
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glab-cli/config.yml`.";
      example.check_update = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."glab-cli/config.yml" = mkIf (cfg.settings != { }) {
      source = yaml.generate "glab-cli_config.yml" cfg.settings;
    };
  };
}
