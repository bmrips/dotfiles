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

    programs.merkuro.enable = true;
    programs.slack.enable = true;
    programs.zotero.enable = true;

    services.davmail = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      imitateOutlook = true;
      settings = {
        "davmail.mode" = "O365Interactive";
        "davmail.oauth.persistToken" = true;

        # Set a static fingerprint/salt such that it is non-flaky.
        # See https://github.com/mguessan/davmail/issues/403.
        "davmail.oauth.fingerprint" = "0000000000000000";
      };
    };
  };
}
