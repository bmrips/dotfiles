{ config, ... }:

{
  services.resolved.settings.Resolve = {
    LLMNR = false; # LLMNR is deprecated and unsafe
    MulticastDNS = !config.services.avahi.enable;
  };
}
