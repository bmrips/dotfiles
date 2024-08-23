{ config, lib, pkgs, ... }:

with lib;

let cfg = config.ci.pre-commit;

in {

  options.ci.pre-commit.enable = mkEnableOption "pre-commit integration";

  config.home.packages =
    mkIf cfg.enable (with pkgs; [ gitlint nixfmt-classic pre-commit yamlfmt ]);

}
