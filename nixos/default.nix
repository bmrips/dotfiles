{ lib, ... }:

{
  imports = lib.haumea.collectModules ./config ++ [ ../nixpkgs ];
}
