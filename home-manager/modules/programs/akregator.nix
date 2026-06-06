{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.akregator;
in
{
  options.programs.akregator = {
    enable = lib.mkEnableOption "Akregator.";
    package = lib.mkPackageOption pkgs [ "kdePackages" "akregator" ] { nullable = true; };
    shortcutSchemes = lib.plasma.shortcutSchemesOption;
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    programs.plasma.shortcutSchemes.akregator = cfg.shortcutSchemes;
  };
}
