{ config, lib, pkgs, ... }:

with lib;

{
  options.ci.pre-commit.enable = mkEnableOption "pre-commit integration";

  config = mkIf config.ci.pre-commit.enable {
    home.packages = (with pkgs; [ gitlint nixfmt-classic pre-commit yamlfmt ]);
  };
}
