{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.plymouth = {
    theme = "breeze";
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
  };

  boot.kernelParams = lib.mkIf config.boot.plymouth.enable [ "quiet" ];
}
