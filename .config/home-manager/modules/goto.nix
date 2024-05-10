{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.goto;
  init = ''
    source ${pkgs.goto}/share/goto.sh
  '';

in {

  options.programs.goto = {
    enable = mkEnableOption "goto";
    package = mkPackageOption pkgs "goto" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.bash.initExtra = init;
    programs.zsh.initExtra = init;
  };

}
