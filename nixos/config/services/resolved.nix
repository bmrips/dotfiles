{
  config,
  lib,
  user,
  ...
}:

lib.mkMerge [
  {
    services.resolved.settings.Resolve.LLMNR = false; # LLMNR is deprecated and unsafe
  }

  (lib.mkIf config.services.resolved.enable {
    # Disable Firefox' DNS cache and DNS over HTTPS.
    home-manager.users.${user}.programs.firefox.profiles.default.settings = {
      "network.dnsCacheEntries" = lib.mkForce 0;
      "network.trr.mode" = lib.mkForce 5;
    };
  })
]
