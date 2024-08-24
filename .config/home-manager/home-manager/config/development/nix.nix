{ config, lib, pkgs, ... }:

with lib;

{
  options.development.nix.enable = mkEnableOption "Nix development tools";

  config = mkIf config.development.nix.enable {
    home.packages = with pkgs; [ nil nixfmt-classic ];
  };
}
