lib:

{
  plasma.shortcutSchemesOption = lib.mkOption {
    type =
      with lib.types;
      let
        shortcut = either str (listOf str);
      in
      attrsOf (attrsOf shortcut);
    default = { };
    description = "Shortcut schemes.";
  };
}
