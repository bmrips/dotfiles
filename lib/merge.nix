{ lib, pkgs, ... }:

let
  merge =
    format: targetFile:
    lib.concatMapStrings (file: /* bash */ ''
      run ${lib.getExe pkgs.yq-go} --inplace $VERBOSE_ARG --output-format ${format} \
        '. *= load("${file}")' \
        '${targetFile}'
    '');

in
{
  json = merge "json";
  yaml = merge "yaml";
}
