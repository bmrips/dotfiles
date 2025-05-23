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

    systemd.tmpfiles.settings.clm = {
      "/usr/bin/as"."L+".argument = "${pkgs.binutils}/bin/as";
      "/usr/bin/gcc"."L+".argument = "${pkgs.gcc}/bin/gcc";
    };
  };

}
