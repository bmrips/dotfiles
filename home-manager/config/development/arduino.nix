{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.arduino.enable = lib.mkEnableOption "Arduino development tools.";

  config = lib.mkIf config.development.arduino.enable {
    home.packages = with pkgs; [
      arduino-ide
      python3
    ];
  };
}
