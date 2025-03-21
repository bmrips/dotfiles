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
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.programs.grep;

in
{

  options.programs.grep = {
    enable = mkEnableOption "{command}`grep`.";
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

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables.GREP_COLORS = mkIf (cfg.colors != { }) (
      concatStringsSep ":" (mapAttrsToList (n: v: "${n}=${v}") cfg.colors)
    );
  };

}
