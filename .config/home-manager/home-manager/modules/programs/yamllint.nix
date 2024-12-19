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
    mkMerge
    mkOption
    mkPackageOption
    ;
  cfg = config.programs.yamllint;
  yaml = pkgs.formats.yaml { };

in
{

  options.programs.yamllint = {

    enable = mkEnableOption "{command}`yamllint`";

    package = mkPackageOption pkgs "yamllint" { };

    settings = mkOption {
      type = yaml.type;
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

  config = mkIf cfg.enable (mkMerge [

    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.settings != { }) {
      home.sessionVariables.YAMLLINT_CONFIG_FILE = "${config.xdg.configHome}/yamllint.yaml";
      xdg.configFile."yamllint.yaml".source = yaml.generate "yamllint.yaml" cfg.settings;
    })

  ]);

}
