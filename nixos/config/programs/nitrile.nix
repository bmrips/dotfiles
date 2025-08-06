{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{

  options.programs.nitrile.enable = lib.mkEnableOption "{command}`nitrile`.";

  config = lib.mkIf config.programs.nitrile.enable {
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
