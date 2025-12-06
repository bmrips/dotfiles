{ lib, self, ... }:

{
  args = lib.cli.toCommandLineGNU { };
  line = attrs: lib.concatStringsSep " " (self.args attrs);
}
