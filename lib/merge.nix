{ lib, pkgs, ... }:

let
  mergeYq =
    format: _: targetFile:
    lib.concatMapStrings (sourceFile: ''
      ${lib.getExe pkgs.yq-go} --inplace --output-format ${format} \
        '. *= load("${sourceFile}")' \
        '${targetFile}'
    '');

in
{
  json = mergeYq "json";
  yaml = mergeYq "yaml";

  xml =
    { stylesheet }:
    targetFile:
    lib.concatMapStrings (sourceFile: ''
      ${lib.getExe pkgs.saxon_12-he} \
        -xsl:${stylesheet} \
        -s:${targetFile} \
        -o:${targetFile}.new \
        sourceFile=${sourceFile}
      mv ${targetFile}.new ${targetFile}
    '');
}
