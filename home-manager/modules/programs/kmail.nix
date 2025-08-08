{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.kmail;

in
{

  options.programs.kmail = {
    enable = lib.mkEnableOption "KMail.";
    package = lib.mkPackageOption pkgs [ "kdePackages" "kmail" ] { };
    shortcutSchemes = lib.plasma.shortcutSchemesOption;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.kdePackages; [
      akonadi-search
      cfg.package
      kleopatra
      kmail-account-wizard
    ];
    programs.plasma.shortcutSchemes.kmail2 = cfg.shortcutSchemes;
  };

}
