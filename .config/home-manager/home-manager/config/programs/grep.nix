{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.grep;

  inherit (pkgs.lib) ansiEscapeCodes;
  inherit (pkgs.lib.ansiEscapeCodes) base16 reset;

  normal = c: with base16; color [ fg c ];
  bold = c: ansiEscapeCodes.combine [ ansiEscapeCodes.bold (normal c) ];

in {

  config = mkMerge [

    {
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

    (mkIf cfg.enable {
      home.defaultCommandFlags.grep = {
        binary-files = "without-match";
        color = "auto";
      };
    })

  ];

}
