args:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ./packages/overlay.nix)
    (import ./konsole-with-full-font-hinting.nix args)
    (import ./write-shell-application-with-optional-checks.nix)
  ];
}
