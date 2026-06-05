{ config, lib, ... }:

let
  cfg = config.programs.dolphin;

  viewPropertiesType = lib.types.attrsOf lib.plasma.coercedSettingsType;
  viewPropertiesOption =
    kind:
    lib.mkOption {
      type = viewPropertiesType;
      default = { };
      description = "${kind} view properties.";
      example = {
        PreviewsShown = false;
        ViewMode = 1;
      };
    };

in
{

  options.programs.dolphin = {
    enable = lib.mkEnableOption "Dolphin";
    shortcutSchemes = lib.plasma.shortcutSchemesOption;
    viewProperties = {
      global = viewPropertiesOption "Global";
      remote = viewPropertiesOption "Remote";
      trash = viewPropertiesOption "Trash";
      local = lib.mkOption {
        description = "Directory-local view properties";
        default = { };
        type = lib.types.attrsOf viewPropertiesType;
      };
    };
  };

  config.programs.plasma = lib.mkIf cfg.enable {

    shortcutSchemes.dolphin = cfg.shortcutSchemes;

    dataFile =
      let
        mkFilename = kind: "dolphin/view_properties/${kind}/.directory";
      in
      lib.mkMerge [
        {
          ${mkFilename "global"}.Dolphin = cfg.viewProperties.global;
          ${mkFilename "remote"}.Dolphin = cfg.viewProperties.remote;
          ${mkFilename "trash"}.Dolphin = cfg.viewProperties.remote;
        }
        (lib.mapAttrs' (path: props: {
          name = mkFilename "local/${path}";
          value.Dolphin = props;
        }) cfg.viewProperties.local)
      ];

  };

}
