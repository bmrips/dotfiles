{
  config,
  lib,
  pkgs,
  ...
}:

let
  xml = pkgs.formats.xml { };

  mkShortcutSchemeFor =
    let
      mkAction = name: keys: {
        "@name" = name;
        "@shortcut" = if lib.isString keys then keys else lib.concatStringsSep "; " keys;
      };
    in
    app: scheme: {
      gui = {
        "@name" = app;
        "@version" = "1";
        ActionProperties.Action = lib.mapAttrsToList mkAction scheme;
      };
    };
in
{
  options.programs.plasma.shortcutSchemes = lib.mkOption {
    description = "Shortcut schemes.";
    default = { };
    type = lib.types.attrsWith' "app" lib.plasma.shortcutSchemesOption.type;
  };

  config.xdg.dataFile = lib.concatMapAttrs (
    app:
    lib.mapAttrs' (
      name: scheme: {
        name = "${app}/shortcuts/${name}";
        value.source = xml.generate "shortcuts-${app}-${name}" (mkShortcutSchemeFor app scheme);
      }
    )
  ) config.programs.plasma.shortcutSchemes;
}
