{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.container;

in {

  options.development.container.enable =
    mkEnableOption "container development tools";

  config.home.packages =
    mkIf cfg.enable (with pkgs; [ dockerfile-language-server-nodejs podman ]);

}
