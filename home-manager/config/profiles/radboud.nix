{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.profiles.radboud.enable = lib.mkEnableOption "the Radboud profile.";

  config = lib.mkIf config.profiles.radboud.enable {
    development.c.enable = true;

    profiles.gui.extra.enable = true;

    home.packages = with pkgs; [ eduvpn-client ];

    programs.firefox.profiles.default.settings = {
      "browser.toolbars.bookmarks.visibility" = lib.mkForce "always";
    };

    programs.glab.enable = true;
    programs.merkuro.enable = true;
    programs.slack.enable = true;
    programs.zotero.enable = true;

    services.davmail = {
      enable = pkgs.stdenv.isLinux;
      imitateOutlook = true;
      settings = {
        "davmail.mode" = "O365Interactive";
        "davmail.oauth.persistToken" = true;
      };
    };
  };
}
