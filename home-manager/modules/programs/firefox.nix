{
  config,
  lib,
  pkgs,
  ...
}:

let
  json = pkgs.formats.json { };

  inject =
    module:
    lib.mkOption {
      type = with lib.types; attrsOf (submodule module);
    };

  extensionType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        enable = lib.mkEnableOption "this extension." // {
          default = true;
        };
        package = lib.mkOption {
          type = lib.types.package;
          example = "pkgs.nur.repos.rycee.firefox-addons.ublock-origin";
          description = "The extension package to install.";
        };
        id = lib.mkOption {
          type = lib.types.str;
          default = config.package.addonId;
          defaultText = "config.package.addonId";
          description = "The id of this extension.";
        };
        settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = ''
            Settings to be merged into the current settings.
          '';
        };
        settingsFiles = lib.mkOption {
          type = with lib.types; listOf path;
          default = [ ];
          description = ''
            Files containing settings that will be merged into the current
            settings. This option is useful to set secrets.
          '';
        };
      };
    }
  );
in
{
  options.programs.firefox.profiles = inject (
    { config, ... }:
    {

      options.extensions' = lib.mkOption {
        type = lib.types.attrsOf extensionType;
        default = { };
        description = "Extensions to install.";
      };

      config =
        let
          extensions = lib.attrValues config.extensions';
          hasSettings = ext: ext.settings != { } || ext.settingsFiles != { };
        in
        {
          # Enable legacy extension storage
          settings."extensions.webextensions.ExtensionStorageIDB.enabled" =
            lib.mkIf (lib.any hasSettings extensions) false;
          extensions.packages = map (ext: ext.package) (lib.filter (ext: ext.enable) extensions);
        };

    }
  );

  # Since the configuration of Firefox extensions contain state and secrets, we
  # apply the settings through merging with `yq`.
  config.home.file' =
    let
      applySettings =
        profile: _: ext:
        let
          targetFile = lib.concatStringsSep "/" [
            config.programs.firefox.profilesPath
            profile.path
            "browser-extension-data"
            ext.id
            "storage.js"
          ];
          sources =
            ext.settingsFiles
            ++ lib.optional (ext.settings != { }) (json.generate "${ext.id}-settings.json" ext.settings);
        in
        {
          ${targetFile} = lib.mkIf (ext.enable && sources != [ ]) {
            type = "yaml";
            inherit sources;
          };
        };
    in
    lib.concatMapAttrs (
      _: profile: lib.concatMapAttrs (applySettings profile) profile.extensions'
    ) config.programs.firefox.profiles;
}
