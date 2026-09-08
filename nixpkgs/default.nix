{ inputs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = lib.attrValues inputs.self.overlays ++ [
    inputs.defaults.overlays.default
    inputs.firefox-addons.overlays.default
  ];
}
