{

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
  };

  nixpkgs.overlays = map import [
    ./packages
    ./age_with_plugins.nix
    ./pre-commit_with_meta_hooks.nix
    ./konsole_with_full_font_hinting.nix
  ];

}
