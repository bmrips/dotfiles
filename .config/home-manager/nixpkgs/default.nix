{

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-27.3.11" ];
  };

  nixpkgs.overlays = map import [
    ./packages
    ./pre-commit_with_meta_hooks.nix
    ./epson-workforce-635-nx625-series
  ];

}
