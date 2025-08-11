args@{ lib, ... }:

{
  imports = lib.haumea.collectModules ./modules args ++ lib.haumea.collectModules ./config args;
}
