{ config, lib, ... }:

let
  normal =
    c:
    with lib.ansiEscapeCodes.base16;
    color [
      fg
      c
    ];
  bold =
    c:
    lib.ansiEscapeCodes.combine [
      lib.ansiEscapeCodes.bold
      (normal c)
    ];

in
{

  home.defaultCommandFlags.grep = lib.mkIf config.programs.grep.enable {
    binary-files = "without-match";
    color = "auto";
  };

  programs.grep.colors =
    with lib.ansiEscapeCodes;
    with lib.ansiEscapeCodes.base16;
    {
      ms = bold red;
      mc = bold red;
      sl = reset;
      cx = reset;
      fn = normal magenta;
      ln = normal green;
      bn = normal green;
      se = normal cyan;
    };

}
