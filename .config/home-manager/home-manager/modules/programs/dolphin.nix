{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf plasma;
  cfg = config.programs.dolphin;

in {

  options.programs.dolphin = {
    enable = mkEnableOption "Dolphin.";
    shortcutSchemes = plasma.shortcutSchemesOption;
  };

  config.programs.plasma.shortcutSchemes.dolphin =
    mkIf cfg.enable cfg.shortcutSchemes;

}
