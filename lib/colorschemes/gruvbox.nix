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

  scheme =
    darkness:
    let
      foreground = if darkness == "dark" then "black" else "white";
      background = if darkness == "dark" then "white" else "black";
      offset = if darkness == "dark" then "1" else "-1";
      revOffset = if darkness == "dark" then "-1" else "1";
    in
    {
      system = "base24";
      name = "Gruvbox";
      variant = "${darkness} medium";
      palette = rec {
        base00 = colors.${background}."0"; # Background
        base01 = colors.${background}."1"; # Darkest gray
        base02 = colors.${background}."2"; # Bright black
        base03 = colors.gray."0"; # Gray
        base04 = colors.gray.${revOffset}; # Light gray
        base05 = colors.${foreground}."2"; # Foreground
        base06 = colors.${foreground}."0"; # White
        base07 = colors.${foreground}."-1"; # Bright white
        base08 = colors.red."0"; # Red
        base09 = colors.orange."0"; # Orange
        base0A = colors.yellow."0"; # Yellow
        base0B = colors.green."0"; # Green
        base0C = colors.cyan."0"; # Cyan
        base0D = colors.blue."0"; # Blue
        base0E = colors.magenta."0"; # Magenta
        base0F = colors.red.${revOffset}; # Dark red or brown
        base10 = base00; # Darker black
        base11 = colors.${background}."-1"; # Darkest black
        base12 = colors.red.${offset}; # Bright red
        base13 = colors.yellow.${offset}; # Bright yellow
        base14 = colors.green.${offset}; # Bright green
        base15 = colors.cyan.${offset}; # Bright cyan
        base16 = colors.blue.${offset}; # Bright blue
        base17 = colors.magenta.${offset}; # Bright magenta
      };
    };

}
