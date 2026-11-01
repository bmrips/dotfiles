{ config, lib, ... }:

lib.mkMerge [
  {
    networking.hagezi.blocklists = {
      "pro.plus".enable = true;
      "tif.mini".enable = true;
      "anti.piracy".enable = true;
      social = {
        enable = true;
        whitelist = [
          "reddit"
          "redd.it"
        ];
      };
      nsfw.enable = true;
      gambling.enable = true;
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
