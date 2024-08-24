{ config, lib, pkgs, ... }:

with lib;

{
  options.development.lua.enable = mkEnableOption "Lua development tools";

  config = mkIf config.development.lua.enable {
    home.defaultCommandFlags.stylua.search-parent-directories = true;
    home.packages = with pkgs; [ lua-language-server selene stylua ];
  };
}
