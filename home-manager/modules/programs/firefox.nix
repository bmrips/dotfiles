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
        origins = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          example = [ "<all_urls>" ];
          description = "Additional origins on which this extensions is allowed";
        };
        permissions = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          example = [ "internal:privateBrowsingAllowed" ];
          description = "Additional permissions granted to this extensions";
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

  filterEnabled = lib.filter (ext: ext.enable);

  perProfile =
    f:
    lib.concatMapAttrs (
      _: profile:
      lib.pipe profile.extensions' [
        lib.attrValues
        filterEnabled
        (f profile)
      ]
    ) config.programs.firefox.profiles;

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
          extensions.packages = map (ext: ext.package) (filterEnabled extensions);
        };

    }
  );

  # Since the configuration of Firefox extensions contain state and secrets, we
  # apply the settings through merging with `yq`.
  config.home.file' = perProfile (
    profile: extensions:
    let
      permissionsPath = lib.concatStringsSep "/" [
        config.programs.firefox.profilesPath
        profile.path
        "extension-preferences.json"
      ];
      mkPermissions =
        ext:
        let
          origins = lib.optionalAttrs (ext.origins != [ ]) { inherit (ext) origins; };
          permissions = lib.optionalAttrs (ext.permissions != [ ]) { inherit (ext) permissions; };
        in
        lib.nameValuePair ext.id (origins // permissions);
      permissionsFile = json.generate "firefox_${profile.name}_extension-preferences.json" (
        lib.pipe extensions [
          (map mkPermissions)
          (lib.filter (pair: pair.value != { }))
          lib.listToAttrs
        ]
      );
      applySettings =
        ext:
        let
          storagePath = lib.concatStringsSep "/" [
            config.programs.firefox.profilesPath
            profile.path
            "browser-extension-data"
            ext.id
            "storage.js"
          ];
          sources =
            ext.settingsFiles
            ++ lib.optional (ext.settings != { }) (
              json.generate "firefox_${profile.name}_${ext.id}-settings.json" ext.settings
            );
        in
        {
          ${storagePath} = lib.mkIf (sources != [ ]) {
            type = "json";
            inherit sources;
          };
        };
    in
    lib.mkMerge (
      map applySettings extensions
      ++ [
        {
          ${permissionsPath} = {
            type = "json";
            sources = [ permissionsFile ];
          };
        }
      ]
    )
  );
}
