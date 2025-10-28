{
  config,
  host,
  inputs,
  lib,
  system,
  user,
  ...
}:

let
  cfg = config.home-manager;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  environment.pathsToLink = lib.mkIf (cfg.useUserPackages && cfg.users.${user}.xdg.portal.enable) [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit host inputs system; };
    users.${user} = ./.;
  };
}
