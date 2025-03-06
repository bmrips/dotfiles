{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.programs.merkuro;

in
{

  options.programs.merkuro = {
    enable = mkEnableOption "Merkuro.";
    package = mkPackageOption pkgs [ "kdePackages" "merkuro" ] { };
    settings = mkOption {
      type =
        with types;
        let
          scalar = nullOr (oneOf [
            bool
            float
            int
            str
          ]);
        in
        attrsOf (attrsOf scalar);
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.plasma.configFile.kalendarrc = cfg.settings;
  };

}
