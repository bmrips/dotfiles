{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.json.enable = lib.mkEnableOption "JSON development tools";

  config = lib.mkIf config.development.json.enable {
    home.packages = with pkgs; [
      jq
      vscode-json-languageserver
    ];
  };
}
