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
  cfg = config.programs.gcc;

in
{

  options.programs.gcc = {
    enable = mkEnableOption "{command}`gcc`";
    package = mkPackageOption pkgs "gcc" { };
    colors = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = "Settings for {env}`GCC_COLORS`";
      example = {
        error = "01;31";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables.GCC_COLORS = mkIf (cfg.colors != { }) (
      concatStringsSep ":" (mapAttrsToList (n: v: "${n}=${v}") cfg.colors)
    );
  };

}
