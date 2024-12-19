{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [

  {
    boot.plymouth = {
      theme = "breeze";
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
    };
  }

  (lib.mkIf config.boot.plymouth.enable { boot.kernelParams = [ "quiet" ]; })

]
