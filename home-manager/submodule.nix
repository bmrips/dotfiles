{
  host,
  inputs,
  system,
  user,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit host inputs system; };
    users.${user} = ./.;
  };
}
