{ config, ... }:

{
  lib.file.mkOutOfStoreSymlink' =
    path:
    let
      base = "${config.xdg.configHome}/home-manager";
      pathStr = builtins.toString path;
      suffix = builtins.head (builtins.match "/nix/store/[^/]+/(.*)$" pathStr);
    in
    config.lib.file.mkOutOfStoreSymlink "${base}/${suffix}";
}
