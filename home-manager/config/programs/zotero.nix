{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.zotero;

in
{
  options.programs.zotero = {
    enable = lib.mkEnableOption "Zotero";
    package = lib.mkPackageOption pkgs "zotero" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.firefox.profiles.default.extensions'.zotero-connector = {
      package = pkgs.nur.repos.rycee.firefox-addons.zotero-connector;
      permissions = [
        "clipboardWrite"
        "management"
      ];
    };
  };
}
