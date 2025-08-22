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
      gray = {
        "-1" = "#7c6f64";
        "0" = "#928374";
        "1" = "#a89984";
      };
      foreground = {
        "-1" = "#fbf1c7";
        "0" = "#f4e8be";
        "1" = "#eee0b7";
        "2" = "#e2cca9";
      };
      blue = "#80aa9e";
      brown = "#a96b2c";
      cyan = "#8bba7f";
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
      gray = {
        "-1" = "#a89984";
        "0" = "#928374";
        "1" = "#7c6f64";
      };
      foreground = {
        "-1" = "#282828";
        "0" = "#32302f";
        "1" = "#45403d";
        "2" = "#514036";
      };
      blue = "#266b79";
      brown = "#d8a657";
      cyan = "#477a5b";
      green = "#72761e";
      magenta = "#924f79";
      orange = "#b94c07";
      red = "#af2528";
      yellow = "#b4730e";
    };
  };

  scheme =
    darkness:
    let
      colors' = colors.${darkness};
    in
    {
      system = "base24";
      name = "Gruvbox Material";
      variant = "${darkness} medium";
      palette = rec {
        base00 = colors'.background."0"; # Background
        base01 = colors'.background."1"; # Darkest gray
        base02 = colors'.background."2"; # Bright black
        base03 = colors'.gray."0"; # Gray
        base04 = colors'.gray."-1"; # Light gray
        base05 = colors'.foreground."2"; # Foreground
        base06 = colors'.foreground."0"; # White
        base07 = colors'.foreground."-1"; # Bright white
        base08 = colors'.red; # Red
        base09 = colors'.orange; # Orange
        base0A = colors'.yellow; # Yellow
        base0B = colors'.green; # Green
        base0C = colors'.cyan; # Cyan
        base0D = colors'.blue; # Blue
        base0E = colors'.magenta; # Magenta
        base0F = colors'.brown; # Dark red or brown
        base10 = base00; # Darker black
        base11 = colors'.background."-1"; # Darkest black
        base12 = colors'.red; # Bright red
        base13 = colors'.yellow; # Bright yellow
        base14 = colors'.green; # Bright green
        base15 = colors'.cyan; # Bright cyan
        base16 = colors'.blue; # Bright blue
        base17 = colors'.magenta; # Bright magenta
      };
    };

}
