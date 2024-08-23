{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.markdown;

in {
  options.development.markdown.enable =
    mkEnableOption "Markdown development tools";

  config.home.packages = mkIf cfg.enable (with pkgs; [
    ltex-ls
    markdownlint-cli
    python3Packages.mdformat
    python3Packages.mdformat-footnote
    python3Packages.mdformat-gfm
    python3Packages.mdformat-tables
  ]);
}
