{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ./packages/overlay.nix)
    (import ./konsole-with-split-view-shortcuts.nix)
    (import ./write-shell-application-with-optional-checks.nix)
  ];
}
