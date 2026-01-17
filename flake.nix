{

  description = "My dotfiles";

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_23_05.url = "github:nixos/nixpkgs/2c9c58e98243930f8cb70387934daa4bc8b00373";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit.url = "github:cachix/git-hooks.nix";
    pre-commit.inputs.nixpkgs.follows = "nixpkgs";
    preservation.url = "github:nix-community/preservation";
    programs-db.url = "github:wamserma/flake-programs-sqlite";
    programs-db.inputs.nixpkgs.follows = "nixpkgs";
    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      nixosSystem =
        {
          host,
          system,
          extraModules,
          ...
        }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system extraModules;
          specialArgs = {
            user = "bmr";
            inherit host inputs system;
          };
          lib = inputs.self.lib system;
          modules = [
            ./nixos
            ./home-manager/submodule.nix
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nix-index-database.nixosModules.nix-index
            inputs.nur.modules.nixos.default
            inputs.preservation.nixosModules.preservation
            inputs.sops.nixosModules.sops
          ];
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = with inputs; [
        pre-commit.flakeModule
        treefmt.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      flake.lib =
        system:
        inputs.nixpkgs.lib.extend (
          final: _prev:
          inputs.haumea.lib.load {
            src = ./lib;
            inputs = {
              inherit inputs;
              lib = final;
              pkgs = inputs.nixpkgs.legacyPackages.${system};
            };
          }
        );

      flake.overlays = {
        konsole_with_full_font_hinting = import ./nixpkgs/konsole_with_full_font_hinting.nix;
        packages = import ./nixpkgs/packages/overlay.nix;
      };

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
          devShells.default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];
            packages = [
              pkgs.age
              pkgs.sops
            ];
            shellHook = /* bash */ ''
              git config diff.sops.textconv "sops decrypt"
            '';
          };

          packages = import ./nixpkgs/packages/default.nix pkgs // {
            installer =
              (nixosSystem {
                inherit system;
                host = "installer";
                extraModules = [ ./hosts/installer.nix ];
              }).config.system.build.isoImage;
          };

          pre-commit.settings = {
            package = pkgs.prek;
            hooks = {
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
            };
          };

          treefmt.programs = {
            mdformat = {
              enable = true;
              settings.wrap = "no";
            };
            nixf-diagnose = {
              enable = true;
              ignore = [ "sema-primop-overridden" ];
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
            yamlfmt.enable = true;
          };
        };

    };
}
