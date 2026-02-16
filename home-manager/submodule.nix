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
  inherit (config.security) tpm2;
  hm = config.home-manager;
  userCfg = hm.users.${user};
  inherit (userCfg.services) ssh-tpm-agent;
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

  users.users.${user}.extraGroups = lib.mkIf (tpm2.enable && ssh-tpm-agent.enable) [
    tpm2.tssGroup
  ];
}
