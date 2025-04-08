{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkForce mkIf;

in
{
  options.profiles.radboud.enable = mkEnableOption "the Radboud profile.";

  config = mkIf config.profiles.radboud.enable {
    development.c.enable = true;
    development.java.enable = true;

    profiles.gui.extra.enable = true;

    home.packages = with pkgs; [ eduvpn-client ];

    programs.firefox.profiles.default.settings = {
      "browser.toolbars.bookmarks.visibility" = mkForce "always";
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
