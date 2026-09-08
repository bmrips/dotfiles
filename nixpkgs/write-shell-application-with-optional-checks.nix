{ defaultsPkgs, ... }:

final: _prev:

let
  optionalChecks = defaultsPkgs.shellcheck.configuration.settings.enable;
in
{
  writeShellApplicationStrict =
    args:
    final.writeShellApplication (
      args
      // {
        extraShellCheckFlags = args.extraShellCheckFlags or [ ] ++ [
          "--enable=${final.lib.concatStringsSep "," optionalChecks}"
        ];
      }
    );
}
