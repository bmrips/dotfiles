{ config, ... }:

{
  lib.sops.path = secret: {
    inherit (config.sops.secrets.${secret}) path;
    dependsOn = [ "sops-nix.service" ];
  };
}
