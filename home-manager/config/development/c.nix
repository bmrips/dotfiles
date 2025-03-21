{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.c.enable = lib.mkEnableOption "C development tools.";

  config = lib.mkIf config.development.c.enable {
    home.packages = with pkgs; [
      man-pages
      man-pages-posix
    ];
  };
}
