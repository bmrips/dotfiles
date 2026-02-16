{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.security.tpm2;
in
{
  security.tpm2 = {
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "tabrmd";
  };

  users.users.${user}.extraGroups = lib.mkIf cfg.enable [ cfg.tssGroup ];
}
