{ inputs, lib, ... }:

{
  imports = [
    "${inputs.plasma-manager}/modules"
    "${inputs.sops}/modules/home-manager/sops.nix"
  ]
  ++ lib.haumea.collectModules ./modules
  ++ lib.haumea.collectModules ./config;
}
