{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.programs.grep;

in
{

  options.programs.grep = {
    enable = mkEnableOption "{command}`grep`";
    package = mkPackageOption pkgs "gnugrep" { };
    colors = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Settings for {env}`GREP_COLORS`";
      example = {
        error = "01;31";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [

    { home.packages = [ cfg.package ]; }

    (mkIf (cfg.colors != { }) {
      home.sessionVariables.GREP_COLORS = concatStringsSep ":" (
        mapAttrsToList (n: v: "${n}=${v}") cfg.colors
      );
    })

  ]);

}
