{ config, lib, pkgs, ... }:

with lib;

{
  options.development.markdown.enable =
    mkEnableOption "Markdown development tools";

  config = mkIf config.development.markdown.enable {
    home.packages = with pkgs; [
      ltex-ls
      markdownlint-cli
      (mdformat.withPlugins (ps:
        with ps; [
          mdformat-footnote
          mdformat-gfm
          mdformat-gfm-alerts
          mdformat-tables
        ]))
    ];
  };
}
