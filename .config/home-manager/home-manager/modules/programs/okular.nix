{ config, lib, ... }:

let
  inherit (lib) mkIf plasma;
  cfg = config.programs.okular;

in
{
  options.programs.okular.shortcutSchemes = plasma.shortcutSchemesOption;
  config.programs.plasma.shortcutSchemes.okular = mkIf cfg.enable cfg.shortcutSchemes;
}
