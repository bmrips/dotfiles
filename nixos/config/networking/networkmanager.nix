{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.networking.networkmanager;
in
lib.mkMerge [
  {
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

    sops.secrets.networks = lib.mkIf cfg.enable { };
    networking.networkmanager.ensureProfiles.environmentFiles = config.lib.sops.pathOptional "networks";
  }

  (lib.mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "networkmanager" ];

    # Overwrite NetworkManager-wait-online.service's ExecStart to remove the
    # `-s` flag such that the service succeeds only when a connection is up.
    systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
      ""
      "${cfg.package}/bin/nm-online -q"
    ];
  })
]
