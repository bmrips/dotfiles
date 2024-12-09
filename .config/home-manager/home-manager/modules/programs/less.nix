{ config, lib, ... }:

let
  inherit (lib) gnuCommandLine mkIf mkOption types;
  cfg = config.programs.less;

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
