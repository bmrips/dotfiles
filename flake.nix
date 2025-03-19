{

  description = "My dotfiles";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    pre-commit = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programs-db = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {

        imports = [ inputs.pre-commit.flakeModule ];

        systems = [ "x86_64-linux" ];

        flake.nixosConfigurations =
          let
            lib = inputs.nixpkgs.lib.extend (import ./lib);

            mkNixosConfig =
              {
                system ? "x86_64-linux",
                host,
                extraModules ? [ ],
              }:
              withSystem system (
                { inputs', ... }:
                lib.nixosSystem {
                  inherit system;
                  specialArgs = {
                    user = "bmr";
                    inherit
                      host
                      inputs
                      lib
                      ;
                  };
                  modules = [
                    ./nixos
                    inputs.nix-index-database.nixosModules.nix-index
                    inputs.nur.modules.nixos.default
                    inputs.home-manager.nixosModules.home-manager
                    {
                      home-manager = {
                        useGlobalPkgs = true;
                        extraSpecialArgs = {
                          pkgs_23_05 = inputs'.nixpkgs_23_05.legacyPackages;
                          programs-db = inputs'.programs-db.packages.programs-sqlite;
                        };
                        sharedModules = [
                          ./home-manager
                          inputs.plasma-manager.homeManagerModules.plasma-manager
                        ];
                      };
                    }
                  ] ++ extraModules;
                }
              );
          in
          {
            orion = mkNixosConfig {
              host = "orion";
              extraModules = [ ./hosts/orion.nix ];
            };
            radboud = mkNixosConfig {
              host = "radboud";
              extraModules = [ ./hosts/radboud.nix ];
            };
          };

        perSystem =
          {
            config,
            inputs',
            pkgs,
            ...
          }:
          {
            devShells.default = config.pre-commit.devShell;
            pre-commit.settings.hooks =
              let
                mdformat = pkgs.mdformat.withPlugins (
                  ps: with ps; [
                    mdformat-footnote
                    mdformat-gfm
                    mdformat-gfm-alerts
                    mdformat-tables
                  ]
                );
              in
              {
                check-added-large-files.enable = true;
                check-executables-have-shebangs.enable = true;
                check-merge-conflicts.enable = true;
                check-shebang-scripts-are-executable.enable = true;
                check-symlinks.enable = true;
                check-toml.enable = true;
                check-vcs-permalinks.enable = true;
                check-yaml.enable = true;
                convco.enable = true;
                detect-private-keys.enable = true;
                markdownlint.enable = true;
                mdformat.enable = true;
                mdformat.package = mdformat;
                mixed-line-endings.enable = true;
                nixfmt-rfc-style.enable = true;
                selene.args = [ "--no-summary" ];
                selene.enable = true;
                shellcheck.enable = true;
                shfmt.args = [ "--indent=4" ];
                shfmt.enable = true;
                stylua.enable = true;
                trim-trailing-whitespace.enable = true;
                typos.enable = true;
              };
          };

      }
    );
}
