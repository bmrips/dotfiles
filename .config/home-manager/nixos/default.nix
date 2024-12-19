{ inputs, ... }:

{
  imports = import ./modules/module-list.nix ++ [
    ./config
    ../nixpkgs
  ];

  nixpkgs.overlays = [ (import ./nixos-option_with_flakes.nix inputs.flake-compat) ];
}
