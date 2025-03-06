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
    home.packages = with pkgs.kdePackages; [
      cfg.package
      kleopatra
      kmail-account-wizard
    ];
    programs.plasma.shortcutSchemes.kmail2 = cfg.shortcutSchemes;
  };

}
