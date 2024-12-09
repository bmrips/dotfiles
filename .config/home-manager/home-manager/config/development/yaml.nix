{ config, lib, pkgs, ... }:

{
  options.development.yaml.enable = lib.mkEnableOption "YAML development tools";

  config = lib.mkIf config.development.yaml.enable {
    home.packages = with pkgs; [ yaml-language-server yamlfmt ];
    programs.yamllint.enable = true;
  };
}
