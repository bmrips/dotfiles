{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.yaml.enable = lib.mkEnableOption "YAML development tools";

  config = lib.mkIf config.development.yaml.enable {
    home.packages = [
      pkgs.yaml-language-server
      pkgs.yamlfmt
      pkgs.yq-go
      pkgs.defaults.yamllint
    ];
  };
}
