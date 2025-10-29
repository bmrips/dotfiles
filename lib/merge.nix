{ lib, pkgs, ... }:

rec {
  json = yaml;

  yaml =
    targetFile:
    lib.concatMapStrings (file: /* bash */ ''
      [[ -r '${file}' ]] &&
        run ${lib.getExe pkgs.yq-go} --inplace $VERBOSE_ARG '. *= load("${file}")' '${targetFile}'
    '');
}
