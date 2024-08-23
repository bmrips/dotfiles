{
  nixpkgs.overlays = import ./overlays;
  imports = import ./modules/module-list.nix ++ [ ./config ];
}
