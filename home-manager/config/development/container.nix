{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.container.enable = lib.mkEnableOption "container development tools";

  config = lib.mkIf config.development.container.enable {
    home.packages = with pkgs; [
      dockerfile-language-server-nodejs
      podman
    ];
  };
}
