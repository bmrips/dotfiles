{ lib, pkgs, ... }:

let
  merge =
    format: targetFile:
    lib.concatMapStrings (file: /* bash */ ''
      ${lib.getExe pkgs.yq-go} --inplace --output-format ${format} \
        '. *= load("${file}")' \
        '${targetFile}'
    '');

in
{
  json = merge "json";
  yaml = merge "yaml";
}
