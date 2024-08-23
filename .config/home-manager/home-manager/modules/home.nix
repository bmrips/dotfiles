{ config, lib, pkgs, ... }:

with lib;

let
  defaultFlags = config.home.defaultCommandFlags;

  inherit (pkgs.lib) gnuCommandLine;

in {

  options.home.defaultCommandFlags = mkOption {
    type = with types; attrsOf (attrsOf (oneOf [ bool int str ]));
    default = { };
    description = "Default flags for shell commands";
    example = {
      grep.binary-files = "without-match";
      ls.color = true;
      make.jobs = 4;
    };
  };

  config.home.shellAliases =
    mapAttrs (prog: opts: "${prog} ${gnuCommandLine opts}") defaultFlags;

}
