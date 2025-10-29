{ config, lib, ... }:

let
  cfg = config.programs.dolphin;

  basicSettingsType =
    with lib.types;
    nullOr (oneOf [
      bool
      float
      int
      str
    ]);
  viewPropertiesType = lib.types.attrsOf basicSettingsType;
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
        type = lib.types.attrsOf viewPropertiesType;
        default = { };
        description = "Directory-local view properties";
      };
    };
  };

  config.programs.plasma = {

    shortcutSchemes.dolphin = lib.mkIf cfg.enable cfg.shortcutSchemes;

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
