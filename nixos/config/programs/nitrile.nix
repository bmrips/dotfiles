{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

in
{

  options.programs.nitrile.enable = mkEnableOption "{command}`nitrile`.";

  config = mkIf config.programs.nitrile.enable {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        libgcc
        libcxx
      ];
    };

    home-manager.users.${user}.home.sessionPath = [ "/home/${user}/.nitrile/bin" ];
  };

}
