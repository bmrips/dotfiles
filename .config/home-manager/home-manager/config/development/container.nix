{ config, lib, pkgs, ... }:

with lib;

{
  options.development.container.enable =
    mkEnableOption "container development tools";

  config = mkIf config.development.container.enable {
    home.packages = (with pkgs; [ dockerfile-language-server-nodejs podman ]);
  };
}
