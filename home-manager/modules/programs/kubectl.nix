{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption;
  cfg = config.programs.kubectl;

in
{
  options.programs.kubectl = {
    enable = mkEnableOption "{command}`kubectl`";
    package = mkPackageOption pkgs "kubectl" { };
  };

  config.home.packages = mkIf cfg.enable [ cfg.package ];
}
