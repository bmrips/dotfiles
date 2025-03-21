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

    profiles.gui.extra.enable = true;
    profiles.research.enable = true;

    home.packages = with pkgs; [ eduvpn-client ];

    programs.firefox.profiles.default.settings = {
      "browser.toolbars.bookmarks.visibility" = mkForce "always";
    };

    programs.merkuro.enable = true;
    programs.slack.enable = true;

    services.davmail.enable = pkgs.stdenv.isLinux;
  };
}
