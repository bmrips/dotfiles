{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.development.lua.enable = lib.mkEnableOption "Lua development tools.";

  config = lib.mkIf config.development.lua.enable {
    home.defaultCommandFlags.stylua.search-parent-directories = true;
    home.packages = with pkgs; [
      lua-language-server
      selene
      stylua
    ];
  };
}
