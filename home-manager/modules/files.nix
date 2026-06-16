{ config, ... }:

{
  lib.file.mkOutOfStoreSymlink' =
    path:
    let
      base = "${config.home.homeDirectory}/projects/dotfiles";
      pathStr = toString path;
      suffix = builtins.head (builtins.match "/nix/store/[^/]+/(.*)$" pathStr);
    in
    config.lib.file.mkOutOfStoreSymlink "${base}/${suffix}";
}
