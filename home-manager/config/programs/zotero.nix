{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    ;

  cfg = config.programs.zotero;

in
{
  options.programs.zotero = {
    enable = mkEnableOption "Zotero.";
    package = mkPackageOption pkgs "zotero" { };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.firefox.profiles.default.extensions.packages = [
      pkgs.nur.repos.rycee.firefox-addons.zotero-connector
    ];
  };
}
