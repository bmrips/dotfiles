{
  programs.shellcheck.settings = {
    shell = "bash";
    enable = [
      # enable optional checks
      "add-default-case"
      "avoid-negated-conditions"
      "avoid-nullary-conditions"
      "check-deprecate-which"
      "check-extra-masked-returns"
      "check-set-e-suppressed"
      "deprecate-which"
      "require-double-brackets"
      "useless-use-of-cat"
    ];
  };
}
