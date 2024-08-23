{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.yaml;

in {
  options.development.yaml.enable = mkEnableOption "YAML development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ yaml-language-server yamlfmt ];

    programs.yamllint.enable = true;
  };
}
