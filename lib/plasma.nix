{ lib, ... }:

{
  shortcutSchemesOption = lib.mkOption {
    description = "Shortcut schemes.";
    default = { };
    type =
      with lib.types;
      let
        keys = either str (listOf str);
      in
      attrsWith' "scheme-name" (attrsWith' "action" keys);
  };
}
