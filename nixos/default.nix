{ lib, ... }:

{
  imports =
    lib.haumea.collectModules ./modules ++ lib.haumea.collectModules ./config ++ [ ../nixpkgs ];
}
