lib:

let inherit (lib) mergeAttrsList;

in rec {

  colors = {
    background.dark = {
      hard = "29,32,33";
      medium = "40,40,40";
      soft = "50,48,47";
    };
    background.light = {
      hard = "249,245,215";
      medium = "251,241,199";
      soft = "242,229,188";
    };
    black = {
      "-1" = "251,241,199";
      "0" = "146,131,116";
      "1" = "40,40,40";
    };
    red = {
      "-1" = "157,0,6";
      "0" = "204,36,29";
      "1" = "251,73,52";
    };
    green = {
      "-1" = "121,116,14";
      "0" = "152,151,26";
      "1" = "184,187,38";
    };
    yellow = {
      "-1" = "181,118,20";
      "0" = "215,153,33";
      "1" = "250,189,47";
    };
    blue = {
      "-1" = "7,102,120";
      "0" = "69,133,136";
      "1" = "131,165,152";
    };
    magenta = {
      "-1" = "143,63,113";
      "0" = "177,98,134";
      "1" = "211,134,155";
    };
    cyan = {
      "-1" = "66,123,88";
      "0" = "104,157,106";
      "1" = "142,192,124";
    };
    white = {
      "-1" = "60,56,54";
      "0" = "168,153,132";
      "1" = "235,219,178";
    };
  };

  mkScheme = darkness:
    { background, bright }:
    let
      offset = if darkness == "light" then "-1" else "1";
      first = if bright then "dimmed" else "normal";
      second = if bright then "normal" else "bright";
    in {
      background = colors.background.${darkness}.${background};
      foreground = colors.white.${offset};
      black.normal = colors.black.${offset};
      black.bright = colors.black."0";
    } // mergeAttrsList (map (c: {
      ${c} = {
        ${first} = colors.${c}."0";
        ${second} = colors.${c}.${offset};
      };
    }) [ "red" "green" "yellow" "blue" "magenta" "cyan" "white" ]);

}
