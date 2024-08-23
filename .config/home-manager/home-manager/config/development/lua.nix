{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.lua;

in {

  options.development.lua.enable = mkEnableOption "Lua development tools";

  config = mkIf cfg.enable {
    home.defaultCommandFlags.stylua.search-parent-directories = true;
    home.packages = with pkgs; [ lua-language-server selene stylua ];
  };

}
