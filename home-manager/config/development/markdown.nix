{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.markdown.enable = lib.mkEnableOption "Markdown development tools";

  config = lib.mkIf config.development.markdown.enable {
    home.packages = with pkgs; [
      markdownlint-cli
      (mdformat.withPlugins (
        ps: with ps; [
          mdformat-footnote
          mdformat-gfm
          mdformat-tables
        ]
      ))
    ];
  };
}
