{

  description = "NixOS configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_23_05.url =
      "github:nixos/nixpkgs/2c9c58e98243930f8cb70387934daa4bc8b00373";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self, home-manager, nixos-hardware, nixpkgs, nixpkgs_23_05, nur }@inputs:
    let lib = nixpkgs.lib.extend (import ./lib);
    in {

      nixosConfigurations.orion = let
        host = "orion";
        user = "bmr";
        system = "x86_64-linux";
        pkgs_23_05 = import nixpkgs_23_05 { inherit system; };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit host inputs lib pkgs_23_05 user; };
        modules = [
          ./hosts/orion.nix
          nixos-hardware.nixosModules.dell-xps-13-9360
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ nur.overlay ];
            home-manager.useGlobalPkgs = true;
            home-manager.extraSpecialArgs = { inherit pkgs_23_05; };
          }
        ];
      };

    };

}
