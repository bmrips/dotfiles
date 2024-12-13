{ config, lib, ... }:

let
  inherit (lib) mapAttrs' mkEnableOption mkIf mkOption mkMerge plasma types;

  cfg = config.programs.dolphin;

  basicSettingsType = with types; nullOr (oneOf [ bool float int str ]);
  viewPropertiesType = types.attrsOf basicSettingsType;
  viewPropertiesOption = kind:
    mkOption {
      type = viewPropertiesType;
      default = { };
      description = "${kind} view properties.";
      example = {
        PreviewsShown = false;
        ViewMode = 1;
      };
    };

in {

  options.programs.dolphin = {
    enable = mkEnableOption "Dolphin.";
    shortcutSchemes = plasma.shortcutSchemesOption;
    viewProperties = {
      global = viewPropertiesOption "Global";
      remote = viewPropertiesOption "Remote";
      trash = viewPropertiesOption "Trash";
      local = mkOption {
        type = types.attrsOf viewPropertiesType;
        default = { };
        description = "Directory-local view properties";
      };
    };
  };

  config.programs.plasma = {

    shortcutSchemes.dolphin = mkIf cfg.enable cfg.shortcutSchemes;

    dataFile =
      let mkFilename = kind: "dolphin/view_properties/${kind}/.directory";
      in mkMerge [
        {
          ${mkFilename "global"}.Dolphin = cfg.viewProperties.global;
          ${mkFilename "remote"}.Dolphin = cfg.viewProperties.remote;
          ${mkFilename "trash"}.Dolphin = cfg.viewProperties.remote;
        }
        (mapAttrs' (path: props: {
          name = mkFilename "local/${path}";
          value.Dolphin = props;
        }) cfg.viewProperties.local)
      ];

  };

}
