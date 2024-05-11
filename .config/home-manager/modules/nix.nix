{ config, lib, pkgs, ... }:

with lib;

let cfg = config.nix;

in {

  options.nix.path = mkOption {
    type = with types; listOf str;
    default = [ ];
    description = "Paths to add to {env}`NIX_PATH`";
  };

  config.home.sessionVariables.NIX_PATH = mkIf (cfg.path != [ ])
    "${concatStringsSep ":" cfg.path}\${NIX_PATH:+:$NIX_PATH}";

}
