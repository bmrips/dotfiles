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
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt";
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
    programs-db = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {

        imports = with inputs; [
          pre-commit.flakeModule
          treefmt.flakeModule
        ];

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
            pkgs,
            ...
          }:
          {
            devShells.default = config.pre-commit.devShell.overrideAttrs (prevAttrs: {
              nativeBuildInputs =
                let
                  inherit (inputs.nixpkgs.lib) attrValues;
                  formatters = attrValues config.treefmt.build.programs;
                in
                (prevAttrs.nativeBuildInputs or [ ]) ++ formatters;
            });

            pre-commit.settings.hooks = {
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
              shellcheck.enable = true;
              statix.enable = true;
              statix.settings.format = "stderr";
              treefmt.enable = true;
              trim-trailing-whitespace.enable = true;
              typos.enable = true;
            };

            treefmt = {
              settings.global.excludes = [
                ".convco"
                ".markdownlint.yaml"
                "home-manager/config/files/fonts.conf"
                "home-manager/config/files/ghci.conf"
                "home-manager/config/files/haskeline"
                "home-manager/config/files/ideavimrc"
                "home-manager/config/files/latexmkrc"
                "home-manager/config/files/toprc"
                "home-manager/config/programs/firefox/TeX.svg"
                "home-manager/config/programs/git/commit_message_template"
                "home-manager/config/programs/git/templates/hooks/pre-commit"
                "home-manager/config/programs/git/templates/info/exclude"
                "home-manager/config/programs/neovim/.luarc.json"
                "home-manager/config/programs/neovim/.styluaignore"
                "home-manager/config/programs/neovim/lazy-lock.json"
                "home-manager/config/programs/neovim/neovim.yaml"
                "home-manager/config/programs/neovim/selene.toml"
                "neovim.yaml"
                "selene.toml"
                "statix.toml"
                "typos.toml"
              ];
              programs = {
                mdformat = {
                  enable = true;
                  settings.wrap = "no";
                  package = pkgs.mdformat.withPlugins (
                    ps: with ps; [
                      mdformat-footnote
                      mdformat-gfm
                      mdformat-gfm-alerts
                      mdformat-tables
                    ]
                  );
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
    );
}
