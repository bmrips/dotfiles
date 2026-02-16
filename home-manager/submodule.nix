{
  config,
  host,
  inputs,
  lib,
  system,
  user,
  utils,
  ...
}:

let
  hm = config.home-manager;
  userCfg = hm.users.${user};
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  environment.pathsToLink = lib.mkIf (hm.useUserPackages && userCfg.xdg.portal.enable) [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        host
        inputs
        system
        utils
        ;
    };
    users.${user} = ./.;
  };
}
