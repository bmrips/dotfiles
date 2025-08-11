{ config, lib, ... }:

let
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

  config.home.shellAliases = lib.mapAttrs (
    prog: opts: "${prog} ${lib.gnuCommand.line opts}"
  ) defaultFlags;

}
