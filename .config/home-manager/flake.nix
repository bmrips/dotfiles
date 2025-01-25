{

  description = "NixOS configuration";

  inputs = {
    flake-compat.url = "github:edolstra/flake-compat/v1.0.0";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_23_05.url = "github:nixos/nixpkgs/2c9c58e98243930f8cb70387934daa4bc8b00373";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programs-db = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixos-hardware,
      nixpkgs,
      nixpkgs_23_05,
      nix-index-database,
      nur,
      plasma-manager,
      programs-db,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (import ./lib);
      user = "bmr";

      mkNixosConfig =
        {
          system ? "x86_64-linux",
          host,
          extraModules ? [ ],
        }:
        let
          pkgs_23_05 = import nixpkgs_23_05 { inherit system; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              host
              inputs
              lib
              user
              ;
          };
          modules = [
            ./nixos
            nix-index-database.nixosModules.nix-index
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                extraSpecialArgs = {
                  inherit pkgs_23_05;
                  programs-db = programs-db.packages.${system}.programs-sqlite;
                };
                sharedModules = [
                  ./home-manager
                  plasma-manager.homeManagerModules.plasma-manager
                ];
              };
            }
          ] ++ extraModules;
        };

    in
    {
      nixosConfigurations = {
        orion = mkNixosConfig {
          host = "orion";
          extraModules = [ ./hosts/orion.nix ];
        };
        radboud = mkNixosConfig {
          host = "radboud";
          extraModules = [ ./hosts/radboud.nix ];
        };
      };
    };

}
