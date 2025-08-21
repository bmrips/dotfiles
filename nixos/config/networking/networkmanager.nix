{
  config,
  lib,
  user,
  ...
}:

{
  users.users.${user}.extraGroups = lib.mkIf config.networking.networkmanager.enable [
    "networkmanager"
  ];

  networking.networkmanager.wifi.powersave = true;

  networking.networkmanager.ensureProfiles.profiles = {
    Home = {
      connection.id = "Home";
      connection.type = "wifi";
      wifi.ssid = "$HOME_SSID";
      wifi-security = {
        key-mgmt = "sae";
        psk = "$HOME_PSK";
      };
    };
    Phone = {
      connection.id = "Phone";
      connection.type = "wifi";
      wifi.ssid = "$PHONE_SSID";
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$PHONE_PSK";
      };
    };
  };

  sops.secrets.networks = { };
  networking.networkmanager.ensureProfiles.environmentFiles = [
    config.sops.secrets.networks.path
  ];
}
