{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  # Temporarily required to build Zotero: https://github.com/NixOS/nixpkgs/issues/568692
  nixpkgs.config.permittedInsecurePackages =
    assert lib.versionOlder pkgs.zotero.version "11";
    [ "firefox-esr-140-bin-unwrapped-140.17.0esr" ];

  nixpkgs.overlays = lib.attrValues inputs.self.overlays ++ [
    inputs.defaults.overlays.defaults
    inputs.firefox-addons.overlays.default
  ];
}
