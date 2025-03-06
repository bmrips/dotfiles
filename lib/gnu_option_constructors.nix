lib:

rec {
  gnuCommandArgs = lib.cli.toGNUCommandLine { optionValueSeparator = "="; };
  gnuCommandLine = attrs: lib.concatStringsSep " " (gnuCommandArgs attrs);
}
