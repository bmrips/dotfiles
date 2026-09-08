{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ./packages/overlay.nix)
    (import ./konsole-with-split-view-shortcuts.nix)
  ];
}
