{
  config,
  lib,
  user,
  ...
}:

{
  security.tpm2 = {
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "tabrmd";
  };

  users.users.${user}.extraGroups = lib.mkIf config.security.tpm2.enable [
    config.security.tpm2.tssGroup
  ];
}
