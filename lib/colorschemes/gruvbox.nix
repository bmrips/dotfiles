{ lib, ... }:

rec {

  colors = {
    black = {
      "-1" = "#1d2021";
      "0" = "#282828";
      "1" = "#32302f";
      "2" = "#3c3836";
      "3" = "#504945";
      "4" = "#665c54";
    };
    white = {
      "-1" = "#f9f5d7";
      "0" = "#fbf1c7";
      "1" = "#f2e5bc";
      "2" = "#ebdbb2";
      "3" = "#d5c4a1";
      "4" = "#bdae93";
    };
    blue = {
      "-1" = "#076678";
      "0" = "#458588";
      "1" = "#83a598";
    };
    cyan = {
      "-1" = "#427b58";
      "0" = "#689d6a";
      "1" = "#8ec07c";
    };
    gray = {
      "-1" = "#7c6f64";
      "0" = "#928374";
      "1" = "#a89984";
    };
    green = {
      "-1" = "#79740e";
      "0" = "#98971a";
      "1" = "#b8bb26";
    };
    magenta = {
      "-1" = "#8f3f71";
      "0" = "#b16286";
      "1" = "#d3869b";
    };
    orange = {
      "-1" = "#af3a03";
      "0" = "#d65d0e";
      "1" = "#fe8019";
    };
    red = {
      "-1" = "#9d0006";
      "0" = "#cc241d";
      "1" = "#fb4934";
    };
    yellow = {
      "-1" = "#b57614";
      "0" = "#d79921";
      "1" = "#fabd2f";
    };
  };

  templates.konsole =
    darkness:
    { background, bright }:
    let
      offset =
        if background == "soft" then
          "1"
        else if background == "hard" then
          "-1"
        else
          "0";
      darkOrLight =
        color:
        if color == "black" && darkness == "light" then
          "white"
        else if color == "black" && darkness == "light" then
          "white"
        else
          color;
      first = if bright then "dimmed" else "normal";
      second = if bright then "normal" else "bright";
    in
    {
      background = colors.${darkOrLight "black"}.${offset};
      foreground = colors.${if darkness == "dark" then "white" else "black"}."2";
      black.normal = colors.${darkOrLight "black"}."0";
      black.bright = colors.gray."0";
      white.${first} = colors.gray."0";
      white.${second} = colors.${darkOrLight "white"}."2";
    }
    // lib.mergeAttrsList (
      map
        (c: {
          ${c} = {
            ${first} = colors.${c}."0";
            ${second} = colors.${c}.${if darkness == "dark" then "1" else "-1"};
          };
        })
        [
          "red"
          "green"
          "yellow"
          "blue"
          "magenta"
          "cyan"
        ]
    );

}
