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
    plasma
    ;

  cfg = config.programs.kmail;

in
{

  options.programs.kmail = {
    enable = mkEnableOption "KMail.";
    package = mkPackageOption pkgs [ "kdePackages" "kmail" ] { };
    shortcutSchemes = plasma.shortcutSchemesOption;
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.kdePackages.kleopatra
    ];
    programs.plasma.shortcutSchemes.kmail2 = cfg.shortcutSchemes;
  };

}
