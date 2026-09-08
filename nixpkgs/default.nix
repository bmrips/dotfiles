{ inputs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = lib.attrValues inputs.self.overlays;
}
