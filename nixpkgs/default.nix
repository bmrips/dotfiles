{

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
  };

  nixpkgs.overlays = map import [
    ./packages
    ./konsole_with_full_font_hinting.nix
  ];

}
