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
  cfg = config.programs.yamllint;
  yaml = pkgs.formats.yaml { };

in
{

  options.programs.yamllint = {

    enable = mkEnableOption "{command}`yamllint`.";

    package = mkPackageOption pkgs "yamllint" { };

    settings = mkOption {
      inherit (yaml) type;
      default = { };
      description = "Settings for {command}`yamllint`.";
      example = {
        extends = "default";
        rules = {
          document-end = "disable";
          document-start = "disable";
          empty-values = "enable";
          float-values.require-numeral-before-decimal = true;
        };
      };
    };

  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables.YAMLLINT_CONFIG_FILE = mkIf (cfg.settings != { }) (
      yaml.generate "yamllint.yaml" cfg.settings
    );
  };

}
