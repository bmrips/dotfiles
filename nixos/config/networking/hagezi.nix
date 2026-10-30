{ config, lib, ... }:

lib.mkMerge [
  {
    networking.hagezi.blocklists = {
      "pro.plus".hash = "sha256-RzBApKTbC3dMVljws50Jgqt5ZdUyolS9c4RUf7A5VYE=";
      "tif.mini".hash = "sha256-SxaE81cGjpFJeZnGUpQ/jmGCORFTgYhhDpxH31wRPzI=";
      "anti.piracy".hash = "sha256-fn9eB3pxhlf1LWIzqxxPuUIUFCPDV7xwhMuaHl+RAUE=";
      social = {
        hash = "sha256-OZ9Ern5qwlNva/KRuffMurMrOFVyULpFHu43Lta3xxA=";
        whitelist = [
          "reddit"
          "redd.it"
        ];
      };
      nsfw.hash = "sha256-tA3VPNX9f2EtZCRCkZWw7p/ev/N75MK/5Q784lUzqEo=";
      gambling.hash = "sha256-T50ryHMtAeL6Jwulm5O8K9b+O/AJLL3cSgv5rZgcyAg=";
    };
  }

  (lib.mkIf config.networking.hagezi.enable {
    environment.etc."NetworkManager/dnsmasq.d/custom-blocklist.conf".text =
      lib.concatMapStringsSep "\n" (d: "local=/${d}/")
        [
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
  })
]
