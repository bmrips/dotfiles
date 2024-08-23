{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.kubectl;

in {
  options.programs.kubectl = {
    enable = mkEnableOption "{command}`kubectl`";
    package = mkPackageOption pkgs "kubectl" { };
  };

  config.home.packages = mkIf cfg.enable [ cfg.package ];
}
