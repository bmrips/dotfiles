{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.java.enable = lib.mkEnableOption "Java development tools.";

  config = lib.mkIf config.development.java.enable {
    home.packages = with pkgs; [
      jdt-language-server
      (openjdk.override { enableJavaFX = true; })
    ];
  };
}
