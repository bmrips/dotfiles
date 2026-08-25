{
  config,
  lib,
  pkgs,
  defaultsPkgs,
  ...
}:

{
  options.development.lua.enable = lib.mkEnableOption "Lua development tools";

  config = lib.mkIf config.development.lua.enable {
    home.packages = [
      pkgs.emmylua-ls
      pkgs.selene
      defaultsPkgs.stylua
    ];
  };
}
