{
  config,
  lib,
  pkgs,
  user,
  ...
}:

let
  stevenBlackBlocklist =
    let
      whitelist = [
        "reddit"
        "redd\.it"
        "whatsapp"
      ];
      pattern = lib.escape [ "." ] (lib.concatStringsSep "|" whitelist);
      blocklist = name: "${pkgs.stevenblack-blocklist}/alternates/${name}/hosts";
      rg = lib.getExe pkgs.ripgrep;
    in
    pkgs.runCommandLocal "custom-stevenblack-blocklist" { } ''
      whitelistPattern="$(
        ${rg} -o '[^ ]*(${pattern})[^ ]*' ${blocklist "social-only"} |
          sed 's/\./\\./g' |
          paste -sd '|'
      )"
      ${rg} -v "$whitelistPattern" ${blocklist "fakenews-gambling-porn-social"} >$out
    '';
  extraBlocklist = pkgs.writeText "extra-blocklist" ''
    # Twitch
    twitch.com

    # YouTube
    googlevideo.com
    m.youtube.com
    music.youtube.com
    www.youtube.com
    youtu.be
    youtube-nocookie.com
    youtube.com
    ytimg.com
  '';
in
lib.mkMerge [
  {
    services.blocky.settings = {
      ports.dns = 53;
      upstreams.groups.default = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      blocking = {
        blackLists.default = [
          stevenBlackBlocklist
          extraBlocklist
        ];
        clientGroupsBlock.default = [ "default" ];
      };
    };
  }

  (lib.mkIf config.services.blocky.enable {
    # Send all system DNS queries to Blocky.
    networking.nameservers = [ "127.0.0.1" ];

    # Prevent NetworkManager from overriding the system resolver.
    networking.networkmanager.dns = lib.mkDefault "none";

    # Disable systemd-resolved's stub listener.
    services.resolved.settings.Resolve.DNSStubListener = false;

    # Disable Firefox' DNS cache and DNS over HTTPS.
    home-manager.users.${user}.programs.firefox.profiles.default.settings = {
      "network.dnsCacheEntries" = lib.mkForce 0;
      "network.trr.mode" = lib.mkForce 5;
    };
  })
]
