{ config, lib, pkgs, ... }:

with lib;

{
  options.development.markdown.enable =
    mkEnableOption "Markdown development tools";

  config = mkIf config.development.markdown.enable {
    home.packages = with pkgs; [
      ltex-ls
      markdownlint-cli
      python3Packages.mdformat
      python3Packages.mdformat-footnote
      python3Packages.mdformat-gfm
      python3Packages.mdformat-tables
    ];
  };
}
