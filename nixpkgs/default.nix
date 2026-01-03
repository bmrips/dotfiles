{

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = map import [
    ./packages/overlay.nix
    ./konsole_with_full_font_hinting.nix
  ];

}
