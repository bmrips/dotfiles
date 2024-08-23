{
  config.programs.shellcheck.settings = {
    shell = "bash";
    enable = [ # enable optional checks
      "add-default-case"
      "avoid-nullary-conditions"
      "check-deprecate-which"
      "check-set-e-suppressed"
      "deprecate-which"
      "require-double-brackets"
    ];
  };
}
