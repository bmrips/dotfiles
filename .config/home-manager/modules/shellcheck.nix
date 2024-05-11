{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.shellcheck;

in {

  options.programs.shellcheck = {

    enable = mkEnableOption "{command}`shellcheck`";

    package = mkPackageOption pkgs "shellcheck" { };

    settings = mkOption {
      type = with types; attrsOf (either str (listOf str));
      default = { };
      description =
        "Settings to put into {file}`$XDG_CONFIG_HOME/shellcheckrc`";
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

  config = mkIf cfg.enable (mkMerge [

    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.settings != { }) {
      xdg.configFile.shellcheckrc.text = concatLines (flatten
        (flip mapAttrsToList cfg.settings (name: value:
          if isList value then
            map (v: "${name}=${v}") value
          else
            "${name}=${value}")));
    })

  ]);

}
