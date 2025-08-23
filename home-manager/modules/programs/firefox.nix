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
in
{
  options.programs.firefox.profiles = inject (
    { config, ... }:
    {

      options.extensions'.settings = inject {
        options.settings = lib.mkOption {
          inherit (json) type;
          default = { };
          description = ''
            Settings to be merged into the current settings. The declarative
            settings override the current settings in case of conflicts.
          '';
        };
        options.files = lib.mkOption {
          type = with lib.types; listOf path;
          default = [ ];
          description = ''
            Files containing settings that will be merged into the current
            settings. This option is especially useful to set secrets.
          '';
        };
      };

      config.settings = {
        # Enable legacy extension storage
        "extensions.webextensions.ExtensionStorageIDB.enabled" = lib.mkIf (config.extensions' != { }) false;
      };

    }
  );

  # Since the configuration of Firefox extensions contain state and secrets, we
  # apply the settings through merging with `yq`.
  config.home.file' =
    let
      applySettings =
        profile: addonId: addonSettings:
        let
          targetFile = lib.concatStringsSep "/" [
            config.home.homeDirectory
            config.programs.firefox.profilesPath
            profile.path
            "browser-extension-data"
            addonId
            "storage.js"
          ];
          sourceFiles =
            addonSettings.files
            ++ lib.optional (addonSettings.settings != { }) (
              json.generate "${addonId}-settings.json" addonSettings.settings
            );
        in
        ''
          run mkdir $VERBOSE_ARG -p "$(dirname '${targetFile}')"
          run touch '${targetFile}'
        ''
        + lib.concatMapStrings (file: ''
          [[ -r '${file}' ]] &&
            run ${pkgs.yq-go}/bin/yq --inplace $VERBOSE_ARG '. *= load("${file}")' '${targetFile}'
        '') sourceFiles;
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.concatMapAttrsStringSep "\n" (
        _: profile: lib.concatMapAttrsStringSep "\n" (applySettings profile) profile.extensions'.settings
      ) config.programs.firefox.profiles
    );
}
