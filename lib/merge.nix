{ lib, pkgs, ... }:

rec {
  json = yaml;

  yaml =
    targetFile:
    lib.concatMapStrings (file: /* bash */ ''
      [[ -r '${file}' ]] &&
        run ${pkgs.yq-go}/bin/yq --inplace $VERBOSE_ARG '. *= load("${file}")' '${targetFile}'
    '');
}
