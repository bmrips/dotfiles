{ config, lib, ... }:

let
  mkShortcutSchemeFor =
    let
      mkAction =
        name: value:
        let
          keys = if lib.isString value then value else lib.concatStringsSep "; " value;
        in
        /* xml */ ''<Action name="${name}" shortcut="${keys}"/>'';
    in
    app: scheme: /* xml */ ''
      <gui name="${app}" version="1">
        <ActionProperties>
          ${lib.concatStringsSep "\n    " (lib.mapAttrsToList mkAction scheme)}
        </ActionProperties>
      </gui>
    '';
in
{
  options.programs.plasma.shortcutSchemes = lib.mkOption {
    type =
      with lib.types;
      let
        shortcut = either str (listOf str);
      in
      attrsOf (attrsOf (attrsOf shortcut));
    default = { };
    description = "Shortcut schemes.";
  };

  config.xdg.dataFile = lib.concatMapAttrs (
    app:
    lib.mapAttrs' (
      name: scheme: {
        name = "${app}/shortcuts/${name}";
        value.text = mkShortcutSchemeFor app scheme;
      }
    )
  ) config.programs.plasma.shortcutSchemes;
}
