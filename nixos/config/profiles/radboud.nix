{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  options.profiles.radboud.enable = lib.mkEnableOption "the Radboud profile.";

  config = lib.mkIf config.profiles.radboud.enable {
    # For eduvpn
    networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

    programs.nitrile.enable = true;

    home-manager.users.${user}.profiles.radboud.enable = true;
  };
}
