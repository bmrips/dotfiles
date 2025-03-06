{

  description = "NixOS configuration";

  inputs = {
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
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
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
      pre-commit-hooks,
      plasma-manager,
      programs-db,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (import ./lib);
      user = "bmr";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgs_23_05 = import nixpkgs_23_05 { inherit system; };

      mkNixosConfig =
        {
          host,
          extraModules ? [ ],
        }:
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

      mdformat = pkgs.mdformat.withPlugins (
        ps: with ps; [
          mdformat-footnote
          mdformat-gfm
          mdformat-gfm-alerts
          mdformat-tables
        ]
      );

      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
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
          shellcheck.enable = true;
          shellcheck.exclude_types = [ "zsh" ];
          shfmt.args = [ "--indent=4" ];
          shfmt.enable = true;
          shfmt.exclude_types = [ "zsh" ];
          stylua.enable = true;
          stylua.excludes = [ "'^home-manager/config/programs/neovim/lua/config/mappings\\.lua$'" ];
          trim-trailing-whitespace.enable = true;
        };
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

      checks.${system}.pre-commit = pre-commit-check;

      devShells.${system}.default = pkgs.mkShell {
        packages = pre-commit-check.enabledPackages;
        inherit (pre-commit-check) shellHook;
      };
    };

}
