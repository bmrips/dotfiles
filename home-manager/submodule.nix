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

  nix.settings =
    let
      inheritIfSet = lib.flip lib.pipe [
        (lib.filter (name: userCfg.nix.settings ? ${name}))
        (lib.map (name: lib.nameValuePair name userCfg.nix.settings.${name}))
        lib.listToAttrs
      ];
    in
    inheritIfSet [ "use-xdg-base-directories" ];

  systemd.tmpfiles.settings.nixos."/etc/nixos"."L+".argument =
    "${userCfg.home.homeDirectory}/projects/dotfiles";
}
