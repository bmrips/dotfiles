lib:

rec {

  colors = {
    background.dark = {
      hard = "#1d2021";
      medium = "#282828";
      soft = "#32302f";
    };
    background.light = {
      hard = "#f9f5d7";
      medium = "#fbf1c7";
      soft = "#f2e5bc";
    };
    black = {
      "-1" = "#fbf1c7";
      "0" = "#928374";
      "1" = "#282828";
    };
    red = {
      "-1" = "#9d0006";
      "0" = "#cc241d";
      "1" = "#fb4934";
    };
    green = {
      "-1" = "#79740e";
      "0" = "#98971a";
      "1" = "#b8bb26";
    };
    yellow = {
      "-1" = "#b57614";
      "0" = "#d79921";
      "1" = "#fabd2f";
    };
    blue = {
      "-1" = "#076678";
      "0" = "#458588";
      "1" = "#83a598";
    };
    magenta = {
      "-1" = "#8f3f71";
      "0" = "#b16286";
      "1" = "#d3869b";
    };
    cyan = {
      "-1" = "#427b58";
      "0" = "#689d6a";
      "1" = "#8ec07c";
    };
    white = {
      "-1" = "#3c3836";
      "0" = "#a89984";
      "1" = "#ebdbb2";
    };
  };

  mkScheme =
    darkness:
    { background, bright }:
    let
      offset = if darkness == "light" then "-1" else "1";
      first = if bright then "dimmed" else "normal";
      second = if bright then "normal" else "bright";
    in
    {
      background = colors.background.${darkness}.${background};
      foreground = colors.white.${offset};
      black.normal = colors.black.${offset};
      black.bright = colors.black."0";
    }
    // lib.mergeAttrsList (
      map
        (c: {
          ${c} = {
            ${first} = colors.${c}."0";
            ${second} = colors.${c}.${offset};
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
