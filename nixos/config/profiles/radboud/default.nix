{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  options.profiles.radboud.enable = lib.mkEnableOption "the Radboud profile";

  config = lib.mkIf config.profiles.radboud.enable {
    networking.networkmanager.ensureProfiles.profiles.eduroam = {
      connection.id = "eduroam";
      connection.type = "wifi";
      wifi.ssid = "eduroam";
      wifi-security.key-mgmt = "wpa-eap";
      "802-1x" = {
        domain-suffix-match = "ru.nl";
        eap = "peap";
        identity = "benedikt.rips@ru.nl";
        password = "$EDUROAM_PASSWORD";
        phase2-auth = "mschapv2";
      };
    };

    # Since eduVPN creates openVPN profiles.
    networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

    programs.nitrile.enable = true;

    # To set up printing over the network. The URL is:
    #  smb://[url encoded email]:[url encoded password]@print.hosting.ru.nl/FollowMe
    services.samba.enable = true;

    # Grant access to serial ports to communicate with Arduino boards.
    users.users.${user}.extraGroups = [ "dialout" ];

    home-manager.users.${user}.profiles.radboud.enable = true;
  };
}
