{
  config,
  lib,
  pkgs,
  ...
}:

let
  whitelistedDomains =
    let
      whitelist = [
        "reddit"
        "redd\.it"
        "whatsapp"
      ];
      pattern = "[^ ]*(${lib.escape [ "." ] (lib.concatStringsSep "|" whitelist)})[^ ]*";
      rg = lib.getExe pkgs.ripgrep;
    in
    pkgs.runCommandLocal "whitelisted-domains" { } ''
      ${rg} -o '${pattern}' ${pkgs.stevenblack-blocklist.social} >$out
    '';
in
{
  networking.stevenblack = {
    block = [
      "fakenews"
      "gambling"
      "porn"
      "social"
    ];
    whitelist = lib.pipe whitelistedDomains [
      builtins.readFile
      (lib.removeSuffix "\n")
      (lib.splitString "\n")
    ];
  };

  networking.hosts."0.0.0.0" = lib.mkIf config.networking.stevenblack.enable [
    # Twitch
    "twitch.com"

    # YouTube
    "googlevideo.com"
    "m.youtube.com"
    "music.youtube.com"
    "www.youtube.com"
    "youtu.be"
    "youtube-nocookie.com"
    "youtube.com"
    "ytimg.com"
  ];
}
