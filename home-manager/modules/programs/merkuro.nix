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
    enable = lib.mkEnableOption "Merkuro";
    package = lib.mkPackageOption pkgs [ "kdePackages" "merkuro" ] { nullable = true; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
  };
}
