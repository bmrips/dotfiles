{ lib, ... }:

rec {

  colors = {
    dark = rec {
      background = {
        hard = "#1d2021";
        medium = "#282828";
        soft = "#32302f";
      };
      foreground = {
        "0" = white."1";
        "1" = white."2";
      };
      black = {
        # "0" = background.${background};
        "1" = "#7c6f64";
        "2" = "#928374";
      };
      red = {
        "0" = "#ea6962";
        "1" = "#f2594b";
        "2" = "#fb4934";
      };
      green = {
        "0" = "#a9b665";
        "1" = "#b0b846";
        "2" = "#b8bb26";
      };
      yellow = {
        "0" = "#d8a657";
        "1" = "#e9b143";
        "2" = "#fabd2f";
      };
      blue = {
        "0" = "#7daea3";
        "1" = "#80aa9e";
        "2" = "#83a598";
      };
      magenta = {
        "0" = "#d3869b"; # TODO
        "1" = "#d3869b";
        "2" = "#d3869b";
      };
      cyan = {
        "0" = "#89b482";
        "1" = "#8bba7f";
        "2" = "#8ec07c";
      };
      white = {
        "0" = "#928374";
        "1" = "#d4be98";
        "2" = "#e2cca9";
      };
    };
    light = rec {
      background = {
        hard = "#f9f5d7";
        medium = "#fbf1c7";
        soft = "#f2e5bc";
      };
      foreground = {
        "0" = white."1";
        "1" = white."2";
      };
      black = {
        # "0" = background.${background};
        "1" = "#a89984";
        "2" = "#928374";
      };
      red = {
        "0" = "#c14a4a";
        "1" = "#af2528";
        "2" = "#9d0006";
      };
      green = {
        "0" = "#6c782e";
        "1" = "#72761e";
        "2" = "#79740e";
      };
      yellow = {
        "0" = "#b47109";
        "1" = "#b4730e";
        "2" = "#b57614";
      };
      blue = {
        "0" = "#45707a";
        "1" = "#266b79";
        "2" = "#076678";
      };
      magenta = {
        "0" = "#945e80";
        "1" = "#924f79";
        "2" = "#8f3f71";
      };
      cyan = {
        "0" = "#4c7a5d";
        "1" = "#477a5b";
        "2" = "#427b58";
      };
      white = {
        "0" = "#928374";
        "1" = "#654735";
        "2" = "#514036";
      };
    };
  };

  mkScheme =
    darkness:
    { background, bright }:
    let
      colors' = colors.${darkness};
      offset = if bright then 1 else 0;
    in
    {
      background = colors'.background.${background};
      foreground = colors'.foreground.${toString offset};
      black.normal = colors'.background.${background};
      black.bright = colors'.black.${toString (1 + offset)};
    }
    // lib.mergeAttrsList (
      map
        (c: {
          ${c} = {
            normal = colors'.${c}.${toString (0 + offset)};
            bright = colors'.${c}.${toString (1 + offset)};
          };
        })
        [
          "red"
          "green"
          "yellow"
          "blue"
          "magenta"
          "cyan"
          "white"
        ]
    );

}
