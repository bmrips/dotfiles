final: _prev:

let
  optionalChecks = [
    "add-default-case"
    # "avoid-negated-conditions"
    "avoid-nullary-conditions"
    "check-deprecate-which"
    # "check-extra-masked-returns"
    "check-set-e-suppressed"
    "deprecate-which"
    "require-double-brackets"
    # "useless-use-of-cat"
  ];
in
{
  writeShellApplication' =
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
