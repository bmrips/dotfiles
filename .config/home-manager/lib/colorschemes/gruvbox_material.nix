lib:

let
  inherit (lib) mergeAttrsList;

in
rec {

  colors = {
    dark = rec {
      background = {
        hard = "29,32,33";
        medium = "40,40,40";
        soft = "50,48,47";
      };
      foreground = {
        "0" = white."1";
        "1" = white."2";
      };
      black = {
        # "0" = background.${background};
        "1" = "124,111,100";
        "2" = "146,131,116";
      };
      red = {
        "0" = "234,105,98";
        "1" = "242,89,75";
        "2" = "251,73,52";
      };
      green = {
        "0" = "169,182,101";
        "1" = "176,184,70";
        "2" = "184,187,38";
      };
      yellow = {
        "0" = "216,166,87";
        "1" = "233,177,67";
        "2" = "250,189,47";
      };
      blue = {
        "0" = "125,174,163";
        "1" = "128,170,158";
        "2" = "131,165,152";
      };
      magenta = {
        "0" = "211,134,155"; # TODO
        "1" = "211,134,155";
        "2" = "211,134,155";
      };
      cyan = {
        "0" = "137,180,130";
        "1" = "139,186,127";
        "2" = "142,192,124";
      };
      white = {
        "0" = "146,131,116";
        "1" = "212,190,152";
        "2" = "226,204,169";
      };
    };
    light = rec {
      background = {
        hard = "249,245,215";
        medium = "251,241,199";
        soft = "242,229,188";
      };
      foreground = {
        "0" = white."1";
        "1" = white."2";
      };
      black = {
        # "0" = background.${background};
        "1" = "168,153,132";
        "2" = "146,131,116";
      };
      red = {
        "0" = "193,74,74";
        "1" = "175,37,40";
        "2" = "157,0,6";
      };
      green = {
        "0" = "108,120,46";
        "1" = "114,118,30";
        "2" = "121,116,14";
      };
      yellow = {
        "0" = "180,113,9";
        "1" = "180,115,14";
        "2" = "181,118,20";
      };
      blue = {
        "0" = "69,112,122";
        "1" = "38,107,121";
        "2" = "7,102,120";
      };
      magenta = {
        "0" = "148,94,128";
        "1" = "146,79,121";
        "2" = "143,63,113";
      };
      cyan = {
        "0" = "76,122,93";
        "1" = "71,122,91";
        "2" = "66,123,88";
      };
      white = {
        "0" = "146,131,116";
        "1" = "101,71,53";
        "2" = "81,64,54";
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
    // mergeAttrsList (
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
