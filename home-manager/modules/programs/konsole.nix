{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapAttrs
    intersectAttrs
    isString
    mapAttrs'
    mkIf
    mkOption
    optionalAttrs
    plasma
    recursiveUpdate
    types
    ;

  cfg = config.programs.konsole;

  ini = pkgs.formats.ini { };

  colorType = types.strMatching "^[[:digit:]]{1,3},[[:digit:]]{1,3},[[:digit:]]{1,3}$";

  color =
    name:
    mkOption {
      type = colorType;
      description = "The ${name} color.";
    };

  optionalColor =
    name:
    mkOption {
      type = types.nullOr colorType;
      default = null;
      description = "The ${name} color.";
    };

  colorWithVariants =
    col:
    mkOption {
      type =
        with types;
        either colorType (submodule {
          options = {
            normal = color "normal ${col}";
            dimmed = optionalColor "dimmed ${col}";
            bright = optionalColor "bright ${col}";
          };
        });
      description = "The ${col} color value";
      apply =
        x:
        if isString x then
          {
            normal = x;
            dimmed = null;
            bright = null;
          }
        else
          x;
    };

  colorScheme = name: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Name of the colorscheme. Defaults to the attribute name.";
      };
      extraConfig = mkOption {
        inherit (ini) type;
        default = { };
        description = ''
          Extra configuration for the colorscheme. Configuration listed here has
          precedence over this Nix module's options.
        '';
      };
      background = colorWithVariants "background";
      foreground = colorWithVariants "foreground";
      black = colorWithVariants "black";
      red = colorWithVariants "red";
      green = colorWithVariants "green";
      yellow = colorWithVariants "yellow";
      blue = colorWithVariants "blue";
      magenta = colorWithVariants "magenta";
      cyan = colorWithVariants "cyan";
      white = colorWithVariants "white";
    };
  };

  mkColorScheme =
    let
      nameMap = {
        background = "Background";
        foreground = "Foreground";
        black = "Color0";
        red = "Color1";
        green = "Color2";
        yellow = "Color3";
        blue = "Color4";
        magenta = "Color5";
        cyan = "Color6";
        white = "Color7";
      };
      mkColorWithVariants =
        col: vals:
        {
          "${nameMap.${col}}".Color = vals.normal;
        }
        // optionalAttrs (vals.dimmed != null) {
          "${nameMap.${col}}Faint".Color = vals.dimmed;
        }
        // optionalAttrs (vals.bright != null) {
          "${nameMap.${col}}Intense".Color = vals.bright;
        };
    in
    scheme:
    recursiveUpdate (
      {
        General.Description = scheme.name;
      }
      // concatMapAttrs mkColorWithVariants (intersectAttrs nameMap scheme)
    ) scheme.extraConfig;

in
{

  options.programs.konsole = {

    colorSchemes = mkOption {
      type = with types; attrsOf (submodule colorScheme);
      default = { };
      description = "Color schemes.";
    };

    shortcutSchemes = plasma.shortcutSchemesOption;

  };

  config = mkIf cfg.enable {

    xdg.dataFile = mapAttrs' (name: value: {
      name = "konsole/${name}.colorscheme";
      value.source = ini.generate "${name}.colorscheme" (mkColorScheme value);
    }) cfg.colorSchemes;

    programs.plasma.shortcutSchemes.konsole = cfg.shortcutSchemes;

  };
}
