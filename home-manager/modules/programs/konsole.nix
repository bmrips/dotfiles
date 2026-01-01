{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.konsole;

  ini = pkgs.formats.ini { };

  colorScheme =
    let
      colorType = lib.types.strMatching "^[[:digit:]]{1,3},[[:digit:]]{1,3},[[:digit:]]{1,3}$";
      color =
        name:
        lib.mkOption {
          description = "The ${name} color, as comma-separated decimal RGB values.";
          example = "40,40,40";
          type = colorType;
        };
      optionalColor =
        name:
        lib.mkOption {
          description = "The ${name} color, as comma-separated decimal RGB values.";
          example = "40,40,40";
          default = null;
          type = lib.types.nullOr colorType;
        };
      colorWithVariants =
        col:
        lib.mkOption {
          description = ''
            The ${col} color and (optionally) its faint and intense variants.

            If set to a string, '${col}.normal' is set to that string and its
            faint and intense variants remain unspecified.
          '';
          example = {
            faint = "29,32,33";
            normal = "40,40,40";
            intense = null;
          };
          type =
            with lib.types;
            either colorType (submodule {
              options = {
                normal = color "normal ${col}";
                faint = optionalColor "faint ${col}";
                intense = optionalColor "intense ${col}";
              };
            });
          apply =
            x:
            if lib.isString x then
              {
                normal = x;
                faint = null;
                intense = null;
              }
            else
              x;
        };

    in
    name: {
      options = {
        name = lib.mkOption {
          description = "Name of the colorscheme.";
          default = name;
          defaultText = "<name>";
          type = lib.types.str;
        };
        extraSettings = lib.mkOption {
          description = ''
            Extra settings for the colorscheme. May be used to override
            settings set through other options.
          '';
          example = {
            Blur = true;
            ColorRandomization = true;
            Opacity = 0.1;
          };
          default = { };
          inherit (ini) type;
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
        // lib.optionalAttrs (vals.faint != null) {
          "${nameMap.${col}}Faint".Color = vals.faint;
        }
        // lib.optionalAttrs (vals.intense != null) {
          "${nameMap.${col}}Intense".Color = vals.intense;
        };
    in
    scheme:
    lib.recursiveUpdate (
      {
        General.Description = scheme.name;
      }
      // lib.concatMapAttrs mkColorWithVariants (lib.intersectAttrs nameMap scheme)
    ) scheme.extraSettings;

in
{

  options.programs.konsole = {

    colorSchemes = lib.mkOption {
      description = "Color schemes.";
      example = {
        "Gruvbox Material Dark" = {
          background = {
            faint = "29,32,33";
            normal = "40,40,40";
          };
          foreground = "226,204,169";
          black = {
            normal = "40,40,40";
            intense = "146,131,116";
          };
          red = "242,89,75";
          green = "176,184,70";
          yellow = "233,177,67";
          blue = "128,170,158";
          magenta = "211,134,155";
          cyan = "139,186,127";
          white = "226,204,169";
          extraConfig = {
            Blur = true;
            ColorRandomization = true;
            Opacity = 0.1;
          };
        };
      };
      default = { };
      type = with lib.types; attrsOf (submodule colorScheme);
    };

    shortcutSchemes = lib.plasma.shortcutSchemesOption;

  };

  config = lib.mkIf cfg.enable {

    xdg.dataFile = lib.mapAttrs' (name: value: {
      name = "konsole/${name}.colorscheme";
      value.source = ini.generate "${name}.colorscheme" (mkColorScheme value);
    }) cfg.colorSchemes;

    programs.plasma.shortcutSchemes.konsole = cfg.shortcutSchemes;

  };
}
