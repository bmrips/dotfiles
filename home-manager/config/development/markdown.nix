{
  config,
  lib,
  defaultsPkgs,
  ...
}:

{
  options.development.markdown.enable = lib.mkEnableOption "Markdown development tools";

  config = lib.mkIf config.development.markdown.enable {
    home.packages = with defaultsPkgs; [
      markdownlint-cli
      (mdformat.withPlugins (
        ps: with ps; [
          mdformat-footnote
          mdformat-gfm
        ]
      ))
    ];
  };
}
