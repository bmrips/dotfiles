{

  description = "My dotfiles";

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";
    defaults.url = "github:bmrips/defaults.nix";
    defaults.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea.url = "github:nix-community/haumea/v0.2.2";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_23_05.url = "github:nixos/nixpkgs/2c9c58e98243930f8cb70387934daa4bc8b00373";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:bmrips/plasma-manager";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      nixosSystem =
        {
          host,
          system,
          user ? "bmr",
          extraModules,
          ...
        }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system extraModules;
          specialArgs = {
            inherit
              host
              inputs
              system
              user
              ;
          };
          lib = inputs.self.lib system;
          modules = [
            ./nixos
            ./home-manager/submodule.nix
            inputs.disko.nixosModules.default
            { nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ]; }
            inputs.lanzaboote.nixosModules.default
            inputs.sops.nixosModules.default
          ];
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [ inputs.defaults.flakeModule ];

      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      flake.lib =
        system:
        inputs.nixpkgs.lib.extend (
          final: prev:
          inputs.haumea.lib.load {
            src = ./lib;
            inputs = {
              inherit final inputs prev;
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
        precision3490 = nixosSystem {
          host = "precision3490";
          system = "x86_64-linux";
          extraModules = [ ./hosts/precision3490.nix ];
        };
        xps13-9360 = nixosSystem {
          host = "xps13-9360";
          system = "x86_64-linux";
          extraModules = [ ./hosts/xps13-9360.nix ];
        };
      };

      perSystem =
        { pkgs, system, ... }:
        {
          ecosystems = {
            github.enable = true;
            lua.enable = true;
            markdown.enable = true;
            sops.enable = true;
          };

          ecosystems.github.workflows.nix-flake-check = {
            arguments = [ "--impure" ];
            preSteps = [
              {
                name = "Create passwords database stub for the installer image";
                run = ''
                  sudo mkdir -p /home/bmr/Documents
                  sudo touch /home/bmr/Documents/passwords.kdbx
                '';
              }
            ];
          };

          legacyPackages.installer =
            (nixosSystem {
              inherit system;
              host = "installer";
              user = "nixos";
              extraModules = [ ./hosts/installer.nix ];
            }).config.system.build.images;

          make-shells.default.packages = [ pkgs.age ];

          packages = import ./nixpkgs/packages/default.nix pkgs;

          treefmt.programs = {
            mdformat.plugins = ps: [
              ps.mdformat-gfm
              ps.mdformat-gfm-alerts
            ];
            shfmt.enable = true;
          };
        };

    };
}
