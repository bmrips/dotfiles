{
  config,
  lib,
  user,
  ...
}:

lib.mkIf config.services.resolved.enable {
  home-manager.users.${user}.programs.firefox.profiles.default.settings = {
    # Disable Firefox' DNS cache if systemd-resolved is enabled.
    "network.dnsCacheExpiration" = lib.mkForce 0;
  };
}
