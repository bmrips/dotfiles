args@{ inputs, lib, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.sops.homeModules.sops
  ]
  ++ lib.haumea.collectModules ./modules args
  ++ lib.haumea.collectModules ./config args;
}
