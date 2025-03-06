{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) concatLines mapAttrsToList;

in
{
  services.kmscon = {

    hwRender = true;

    extraConfig =
      let
        inherit (config.services.xserver) xkb;

        colors = rec {
          black = "40,40,40";
          dark-grey = "146,131,116";
          red = "251,73,52";
          light-red = red;
          green = "184,187,38";
          light-green = green;
          yellow = "250,189,47";
          light-yellow = yellow;
          blue = "131,165,152";
          light-blue = blue;
          magenta = "211,134,155";
          light-magenta = magenta;
          cyan = "142,192,124";
          light-cyan = cyan;
          light-grey = white;
          white = "235,219,178";
          foreground = white;
          background = black;
        };

        colorConfigStr = concatLines (
          [ "palette=custom" ] ++ mapAttrsToList (n: v: "palette-${n}=${v}") colors
        );

      in
      ''
        font-size=11
        xkb-layout=${xkb.layout}
        xkb-options=${xkb.options}
        ${colorConfigStr}
      '';

    fonts = [
      {
        name = "JetbrainsMono NF Medium";
        package = pkgs.nerd-fonts.jetbrains-mono;
      }
    ];

  };
}
