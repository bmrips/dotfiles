{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.ci.pre-commit.enable = lib.mkEnableOption "pre-commit integration";

  config = lib.mkIf config.ci.pre-commit.enable {
    home.packages = (
      with pkgs;
      [
        gitlint
        pre-commit
      ]
    );
    development.markdown.enable = true;
    development.nix.enable = true;
    development.lua.enable = true;
    development.yaml.enable = true;
  };
}
