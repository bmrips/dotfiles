lib:

let
  inherit (lib) mkOption types;

in
{
  plasma.shortcutSchemesOption = mkOption {
    type =
      with types;
      let
        shortcut = either str (listOf str);
      in
      attrsOf (attrsOf shortcut);
    default = { };
    description = "Shortcut schemes.";
  };
}
