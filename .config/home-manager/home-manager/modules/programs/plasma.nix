{ config, lib, ... }:

let
  inherit (lib)
    concatMapAttrs concatStringsSep isString mapAttrs' mapAttrsToList mkOption
    types;

  mkShortcutSchemeFor = let
    mkAction = name: value:
      let keys = if isString value then value else concatStringsSep "; " value;
      in ''<Action name="${name}" shortcut="${keys}"/>'';
  in app: scheme: ''
    <gui name="${app}" version="1">
      <ActionProperties>
        ${concatStringsSep "\n    " (mapAttrsToList mkAction scheme)}
      </ActionProperties>
    </gui>
  '';

in {

  options.programs.plasma.shortcutSchemes = mkOption {
    type = with types;
      let shortcut = either str (listOf str);
      in attrsOf (attrsOf (attrsOf shortcut));
    default = { };
    description = "Shortcut schemes.";
  };

  config.xdg.dataFile = concatMapAttrs (app:
    mapAttrs' (name: scheme: {
      name = "${app}/shortcuts/${name}";
      value.text = mkShortcutSchemeFor app scheme;
    })) config.programs.plasma.shortcutSchemes;

}
