{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.nix;

in {
  options.development.nix.enable = mkEnableOption "Nix development tools";

  config.home.packages = mkIf cfg.enable (with pkgs; [ nil nixfmt-classic ]);
}
