{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.profiles.radboud.enable = lib.mkEnableOption "the Radboud profile";

  config = lib.mkIf config.profiles.radboud.enable {
    development.c.enable = true;
    development.arduino.enable = true;

    profiles.gui.extra.enable = true;

    home.packages = with pkgs; [ eduvpn-client ];

    programs.git.includes = [
      {
        condition = "hasconfig:remote.*.url:git@gitlab.science.ru.nl:*/**";
        contents.user.email = "benedikt.rips@ru.nl";
      }
    ];

    programs.slack.enable = true;
    programs.zotero.enable = true;

    services.gpg-agent.sshKeys = [ "E9A3C51CC575A8B0610A78799C3396888765BA26" ];
  };
}
