{
  inputs,
  lib,
  pkgs,
  ...
}:

pkgs.callPackage inputs.base16.lib { }
// {
  asRgbCodes =
    scheme:
    lib.mapAttrsRecursive (
      _: color:
      lib.concatStringsSep "," [
        scheme."${color}-rgb-r"
        scheme."${color}-rgb-g"
        scheme."${color}-rgb-b"
      ]
    );
}
