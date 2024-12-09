{ config, lib, pkgs, ... }:

{
  options.development.markdown.enable =
    lib.mkEnableOption "Markdown development tools";

  config = lib.mkIf config.development.markdown.enable {
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
