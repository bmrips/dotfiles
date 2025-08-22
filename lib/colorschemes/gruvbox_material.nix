rec {

  colors = {
    dark = {
      background = {
        "-1" = "#1b1b1b";
        "0" = "#282828";
        "1" = "#32302f";
        "2" = "#3c3836";
        "3" = "#45403d";
        "4" = "#5a524c";
      };
      foreground = "#e2cca9";
      blue = "#80aa9e";
      cyan = "#8bba7f";
      gray = "#928374";
      green = "#b0b846";
      magenta = "#d3869b";
      orange = "#f28534";
      red = "#f2594b";
      yellow = "#e9b143";
    };
    light = {
      background = {
        "-1" = "#f2e5bc";
        "0" = "#fbf1c7";
        "1" = "#f4e8be";
        "2" = "#f2e5bc";
        "3" = "#eee0b7";
        "4" = "#e5d5ad";
      };
      foreground = "#514036";
      blue = "#266b79";
      cyan = "#477a5b";
      gray = "#928374";
      green = "#72761e";
      magenta = "#924f79";
      orange = "#b94c07";
      red = "#af2528";
      yellow = "#b4730e";
    };
  };

  templates.konsole =
    darkness:
    let
      colors' = colors.${darkness};
    in
    rec {
      inherit (colors')
        foreground
        blue
        cyan
        green
        magenta
        red
        yellow
        ;
      background = colors'.background."0";
      black.normal = background;
      black.bright = colors'.gray;
      white = foreground;
    };

}
