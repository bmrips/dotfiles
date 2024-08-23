{ config, lib, pkgs, ... }:

with lib;

let cfg = config.development.lua;

in {
  options.development.lua.enable = mkEnableOption "Lua development tools";

  config.home.packages =
    mkIf cfg.enable (with pkgs; [ lua-language-server selene stylua ]);
}
