{ inputs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Temporarily required to build Zotero: https://github.com/NixOS/nixpkgs/issues/568692
  nixpkgs.config.permittedInsecurePackages = [ "firefox-esr-140-bin-unwrapped-140.17.0esr" ];

  nixpkgs.overlays = lib.attrValues inputs.self.overlays ++ [
    inputs.defaults.overlays.default
    inputs.firefox-addons.overlays.default
  ];
}
