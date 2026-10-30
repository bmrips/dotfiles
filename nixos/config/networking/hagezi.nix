{
  config,
  lib,
  pkgs,
  ...
}:

let
  fetchHageziList =
    {
      name,
      hash ? lib.fakeHash,
      whitelist ? [ ],
    }:
    let
      orig = pkgs.fetchurl {
        url = "https://hagezi-mirror.dnsbunker.org/dnsmasq/${name}.txt";
        inherit hash;
      };
      pattern = lib.escape [ "." ] (lib.concatStringsSep "|" whitelist);
    in
    if whitelist == [ ] then
      orig
    else
      pkgs.runCommandLocal "HaGeZi-${name}.txt" { } ''
        grep -vE '${pattern}' <${orig} >$out
      '';

  blocklists = {
    custom-blocklist =
      let
        domains = [
          # Twitch
          "twitch.com"
          "twitch.tv"

          # YouTube
          "googlevideo.com"
          "youtu.be"
          "youtube-nocookie.com"
          "youtube.com"
          "ytimg.com"
        ];
      in
      lib.pipe domains [
        (lib.concatMapStringsSep "\n" (d: "local=/${d}/"))
        (pkgs.writeText "custom-blocklist")
      ];
    HaGeZi-pro-plus = fetchHageziList {
      name = "pro.plus";
      hash = "sha256-RzBApKTbC3dMVljws50Jgqt5ZdUyolS9c4RUf7A5VYE=";
    };
    HaGeZi-TIF = fetchHageziList {
      name = "tif.mini";
      hash = "sha256-SxaE81cGjpFJeZnGUpQ/jmGCORFTgYhhDpxH31wRPzI=";
    };
    HaGeZi-anti-piracy = fetchHageziList {
      name = "anti.piracy";
      hash = "sha256-fn9eB3pxhlf1LWIzqxxPuUIUFCPDV7xwhMuaHl+RAUE=";
    };
    HaGeZi-social = fetchHageziList {
      name = "social";
      hash = "sha256-OZ9Ern5qwlNva/KRuffMurMrOFVyULpFHu43Lta3xxA=";
      whitelist = [
        "reddit"
        "redd.it"
      ];
    };
    HaGeZi-NSFW = fetchHageziList {
      name = "nsfw";
      hash = "sha256-tA3VPNX9f2EtZCRCkZWw7p/ev/N75MK/5Q784lUzqEo=";
    };
    HaGeZi-gambling = fetchHageziList {
      name = "gambling";
      hash = "sha256-T50ryHMtAeL6Jwulm5O8K9b+O/AJLL3cSgv5rZgcyAg=";
    };
  };
in
{
  options.networking.hagezi.enable = lib.mkEnableOption "the HaGeZi DNS blocklists";

  config = lib.mkIf config.networking.hagezi.enable {
    environment.etc = lib.mapAttrs' (name: list: {
      name = "NetworkManager/dnsmasq.d/${name}.conf";
      value.source = list;
    }) blocklists;

    networking.networkmanager.dns = "dnsmasq";

    # resolved conflicts with NetworkManager's dnsmasq.
    services.resolved.enable = lib.mkForce false;
  };
}
