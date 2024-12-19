{ config, lib, ... }:

let
  inherit (lib) ansiEscapeCodes mkIf;
  inherit (lib.ansiEscapeCodes) base16 reset;

  normal =
    c:
    with base16;
    color [
      fg
      c
    ];
  bold =
    c:
    ansiEscapeCodes.combine [
      ansiEscapeCodes.bold
      (normal c)
    ];

in
{

  home.defaultCommandFlags.grep = mkIf config.programs.grep.enable {
    binary-files = "without-match";
    color = "auto";
  };

  programs.grep.colors = with base16; {
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
