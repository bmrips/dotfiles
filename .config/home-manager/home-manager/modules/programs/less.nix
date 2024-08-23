{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.less;
  inherit (pkgs.lib) gnuCommandLine;

in {

  options.programs.less.settings = mkOption {
    type = with types; attrsOf (oneOf [ bool int str ]);
    default = { };
    description = "GNU-style options to be exported to {env}`LESS`";
    example = { quiet = true; };
  };

  config.home.sessionVariables.LESS =
    mkIf (cfg.enable && cfg.settings != { }) (gnuCommandLine cfg.settings);

}
