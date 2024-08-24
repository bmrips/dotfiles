{ config, lib, pkgs, ... }:

with lib;

let cfg = config.boot.plymouth;

in {
  config = mkMerge [

    {
      boot.plymouth = {
        theme = "breeze";
        logo =
          "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
      };
    }

    (mkIf cfg.enable { boot.kernelParams = [ "quiet" ]; })

  ];
}
