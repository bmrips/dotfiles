{ config, lib, pkgs, ... }:

with lib;

{
  options.development.yaml.enable = mkEnableOption "YAML development tools";

  config = mkIf config.development.yaml.enable {
    home.packages = with pkgs; [ yaml-language-server yamlfmt ];
    programs.yamllint.enable = true;
  };
}
