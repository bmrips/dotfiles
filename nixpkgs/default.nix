{

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = map import [
    ./packages/overlay.nix
    ./konsole-with-full-font-hinting.nix
    ./write-shell-application-with-optional-checks.nix
  ];

}
