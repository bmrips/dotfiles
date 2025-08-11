{ lib, self, ... }:

{
  args = lib.cli.toGNUCommandLine { optionValueSeparator = "="; };
  line = attrs: lib.concatStringsSep " " (self.args attrs);
}
