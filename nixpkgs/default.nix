{

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
  };

  nixpkgs.overlays = map import [
    ./packages
    ./pre-commit_with_meta_hooks.nix
    ./konsole_with_full_font_hinting.nix
  ];

}
