{ config, lib, ... }:

let
  cfg = config.sops;
  path = f: secret: f (cfg.secrets ? ${secret}) cfg.secrets.${secret}.path;
in
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/var/lib/sops/age/keys.txt";
    age.generateKey = true;
    secrets.hashed_password.neededForUsers = true;
  };

  environment.variables.SOPS_AGE_KEY_FILE = cfg.age.keyFile;

  lib.sops = {
    path = path lib.mkIf;
    pathOptional = path lib.optional;
  };
}
