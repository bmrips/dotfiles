{

  description = "My dotfiles";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "pre-commit";
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
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit = {
      url = "github:bmrips/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preservation.url = "github:nix-community/preservation";
    programs-db = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib.extend (
        final: _prev:
        inputs.haumea.lib.load {
          src = ./lib;
          inputs.lib = final;
          inputs.inputs = inputs;
        }
      );

      nixosSystem =
        {
          host,
          system,
          extraModules,
          ...
        }:
        lib.nixosSystem {
          inherit lib system extraModules;
          specialArgs = {
            user = "bmr";
            inherit host inputs;
          };
          modules = [
            ./nixos
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-index-database.nixosModules.nix-index
            inputs.nur.modules.nixos.default
            inputs.preservation.nixosModules.preservation
            inputs.sops.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                extraSpecialArgs = {
                  inherit host;
                  pkgs_23_05 = inputs.nixpkgs_23_05.legacyPackages.${system};
                  programs-db = inputs.programs-db.packages.${system}.programs-sqlite;
                };
                sharedModules = [
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                  inputs.sops.homeManagerModules.sops
                  ./home-manager
                ];
              };
            }
          ];
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = with inputs; [
        pre-commit.flakeModule
        treefmt.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      flake.nixosConfigurations = {
        "private-xps13-9360" = nixosSystem {
          host = "private-xps13-9360";
          system = "x86_64-linux";
          extraModules = [ ./hosts/private-xps13-9360.nix ];
        };
        "radboud-precision3490" = nixosSystem {
          host = "radboud-precision3490";
          system = "x86_64-linux";
          extraModules = [ ./hosts/radboud-precision3490.nix ];
        };
      };

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        {
          devShells.default = config.pre-commit.devShell.overrideAttrs (prevAttrs: {
            nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [
              pkgs.age
              pkgs.sops
            ];
            shellHook = prevAttrs.shellHook + ''
              git config diff.sops.textconv "sops decrypt"
            '';
          });

          packages.installer =
            (nixosSystem {
              inherit system;
              host = "installer";
              extraModules = [ ./hosts/installer.nix ];
            }).config.system.build.isoImage;

          pre-commit.settings.hooks = {
            actionlint.enable = true;
            check-added-large-files.enable = true;
            check-executables-have-shebangs.enable = true;
            check-merge-conflicts.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            check-symlinks.enable = true;
            check-toml.enable = true;
            check-vcs-permalinks.enable = true;
            check-yaml.enable = true;
            convco.enable = true;
            deadnix.enable = true;
            detect-private-keys.enable = true;
            markdownlint.enable = true;
            mixed-line-endings.enable = true;
            selene.enable = true;
            statix.enable = true;
            statix.settings.format = "stderr";
            treefmt.enable = true;
            trim-trailing-whitespace.enable = true;
            typos.enable = true;
            yamlfmt.enable = true;
            yamlfmt.entry = "${pkgs.yamlfmt}/bin/yamlfmt";
          };

          treefmt.programs = {
            mdformat = {
              enable = true;
              settings.wrap = "no";
            };
            nixfmt.enable = true;
            shfmt = {
              enable = true;
              indent_size = 4;
            };
            stylua = {
              enable = true;
              settings = {
                call_parentheses = "None";
                column_width = 100;
                indent_type = "Spaces";
                indent_width = 2;
                quote_style = "AutoPreferSingle";
              };
            };
          };
        };

    };
}
