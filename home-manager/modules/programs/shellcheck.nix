{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.shellcheck;

in
{

  options.programs.shellcheck = {

    enable = lib.mkEnableOption "{command}`shellcheck`.";

    package = lib.mkPackageOption pkgs "shellcheck" { };

    settings = lib.mkOption {
      type = with lib.types; attrsOf (either str (listOf str));
      default = { };
      description = "Settings to put into {file}`$XDG_CONFIG_HOME/shellcheckrc`";
      example = {
        shell = "bash";
        enable = [
          "add-default-case"
          "avoid-nullary-conditions"
          "check-deprecate-which"
          "check-set-e-suppressed"
          "deprecate-which"
          "require-double-brackets"
        ];
      };
    };

  };

  config = lib.mkIf cfg.enable {

    home.packages = [ cfg.package ];

    xdg.configFile.shellcheckrc.text = lib.mkIf (cfg.settings != { }) (
      lib.pipe cfg.settings [
        (lib.mapAttrsToList (
          name: value: if lib.isList value then map (v: "${name}=${v}") value else "${name}=${value}"
        ))
        lib.flatten
        lib.concatLines
      ]
    );

  };

}
