{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.kubectl;

in
{
  options.programs.kubectl = {
    enable = lib.mkEnableOption "{command}`kubectl`.";
    package = lib.mkPackageOption pkgs "kubectl" { };
  };

  config.home.packages = lib.mkIf cfg.enable [ cfg.package ];
}
