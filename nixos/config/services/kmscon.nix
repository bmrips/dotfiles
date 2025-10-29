{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.kmscon = {

    hwRender = true;

    extraConfig =
      let
        inherit (config.services.xserver) xkb;

        colors = lib.base16.asRgbCodes (lib.gruvbox_material.scheme "dark") rec {
          foreground = "base05";
          background = "base00";
          black = background;
          white = foreground;
          dark-grey = "base04";
          light-grey = "base03";
          red = "base08";
          light-red = "base12";
          yellow = "base0A";
          light-yellow = "base13";
          green = "base0B";
          light-green = "base14";
          cyan = "base0C";
          light-cyan = "base15";
          blue = "base0D";
          light-blue = "base16";
          magenta = "base0E";
          light-magenta = "base17";
        };

        colorConfigStr = lib.concatLines (
          [ "palette=custom" ] ++ lib.mapAttrsToList (n: v: "palette-${n}=${v}") colors
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
