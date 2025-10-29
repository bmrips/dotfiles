{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.yamllint;
  yaml = pkgs.formats.yaml { };

in
{

  options.programs.yamllint = {

    enable = lib.mkEnableOption "{command}`yamllint`";

    package = lib.mkPackageOption pkgs "yamllint" { };

    settings = lib.mkOption {
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables.YAMLLINT_CONFIG_FILE = lib.mkIf (cfg.settings != { }) (
      yaml.generate "yamllint.yaml" cfg.settings
    );
  };

}
