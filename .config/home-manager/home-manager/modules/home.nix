{ config, lib, ... }:

let
  inherit (lib) gnuCommandLine mapAttrs;
  defaultFlags = config.home.defaultCommandFlags;

in
{

  options.home.defaultCommandFlags = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        attrsOf (oneOf [
          bool
          int
          str
        ])
      );
    default = { };
    description = "Default flags for shell commands";
    example = {
      grep.binary-files = "without-match";
      ls.color = true;
      make.jobs = 4;
    };
  };

  config.home.shellAliases = mapAttrs (prog: opts: "${prog} ${gnuCommandLine opts}") defaultFlags;

}
