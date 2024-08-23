{ pkgs, ... }:

let
  inherit (pkgs.lib) ansiEscapeCodes;
  inherit (pkgs.lib.ansiEscapeCodes) base16;

  normal = c: with base16; color [ fg c ];
  bold = c: ansiEscapeCodes.combine [ ansiEscapeCodes.bold (normal c) ];

in {
  config.programs.gcc.colors = with base16; {
    error = bold red;
    warning = bold magenta;
    note = bold cyan;
    caret = bold green;
    locus = bold yellow;
    quote = bold blue;
  };
}
