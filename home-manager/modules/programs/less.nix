{ config, lib, ... }:

let
  cfg = config.programs.less;

in
{

  options.programs.less.options = lib.mkOption {
    type =
      with lib.types;
      attrsOf (oneOf [
        bool
        int
        str
      ]);
    default = { };
    description = "GNU-style options to be exported to {env}`LESS`";
    example = {
      quiet = true;
    };
  };

  config.programs.less.keys = lib.mkIf (cfg.options != { }) ''
    #env
    LESS = ${lib.cli.toGNUCommandLineShell { } cfg.options}
  '';

}
