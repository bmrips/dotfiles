{ config, lib, ... }:

let
  cfg = config.programs.okular;

in
{
  options.programs.okular.shortcutSchemes = lib.plasma.shortcutSchemesOption;
  config.programs.plasma.shortcutSchemes.okular = lib.mkIf cfg.enable cfg.shortcutSchemes;
}
