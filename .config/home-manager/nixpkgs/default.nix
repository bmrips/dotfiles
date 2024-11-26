{

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-27.3.11" ];
    warnUndeclaredOptions = true;
  };

  nixpkgs.overlays = map import [ ./packages ./pre-commit_with_meta_hooks.nix ];

}
