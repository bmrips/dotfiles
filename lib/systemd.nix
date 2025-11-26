{ lib, ... }:

{
  escapeDir = lib.flip lib.pipe [
    lib.strings.normalizePath
    (lib.removePrefix "/")
    (lib.removeSuffix "/")
    (builtins.replaceStrings [ "/" ] [ "-" ])
  ];
}
