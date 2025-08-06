{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.merkuro;

in
{

  options.programs.merkuro = {
    enable = lib.mkEnableOption "Merkuro.";
    package = lib.mkPackageOption pkgs [ "kdePackages" "merkuro" ] { };
    settings = lib.mkOption {
      type =
        with lib.types;
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

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.plasma.configFile.kalendarrc = cfg.settings;
  };

}
