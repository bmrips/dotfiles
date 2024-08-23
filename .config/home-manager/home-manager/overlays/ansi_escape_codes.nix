final: prev:

let
  inherit (final.lib) lists strings;

  ansiEscapeCodes = {
    combine = strings.concatStringsSep ";";

    reset = "0";
    bold = "1";
    faint = "2";
    italic = "3";
    underline = "4";
    slowBlink = "5";
    rapidBlink = "6";
    reverse = "7";

    base16 = {
      color = mods: toString (lists.foldl' builtins.add 0 mods);

      fg = 30;
      bg = 40;

      bright = 60;

      black = 0;
      red = 1;
      green = 2;
      yellow = 3;
      blue = 4;
      magenta = 5;
      cyan = 6;
      white = 7;
    };
  };

in { lib = prev.lib // { inherit ansiEscapeCodes; }; }
