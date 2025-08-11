{
  config,
  lib,
  user,
  ...
}:

lib.mkIf config.security.tpm2.enable {
  users.users.${user}.extraGroups = [ config.security.tpm2.tssGroup ];
}
