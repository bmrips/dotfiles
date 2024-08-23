final: prev:

let
  gnuCommandArgs =
    final.lib.cli.toGNUCommandLine { optionValueSeparator = "="; };
  gnuCommandLine = attrs: final.lib.concatStringsSep " " (gnuCommandArgs attrs);

in { lib = prev.lib // { inherit gnuCommandArgs gnuCommandLine; }; }
