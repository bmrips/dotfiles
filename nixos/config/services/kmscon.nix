{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.kmscon = {
    useXkbConfig = true;
    config = {
      font-name = "JetbrainsMono NF Medium";
      font-size = 11;
      hwaccel = true;
      multi-monitor = "largest";
      palette = "custom";
    }
    // lib.base16.asRgbCodes (lib.gruvbox_material.scheme "dark") rec {
      palette-foreground = "base05";
      palette-background = "base00";
      palette-black = palette-background;
      palette-white = palette-foreground;
      palette-dark-grey = "base04";
      palette-light-grey = "base03";
      palette-red = "base08";
      palette-light-red = "base12";
      palette-yellow = "base0A";
      palette-light-yellow = "base13";
      palette-green = "base0B";
      palette-light-green = "base14";
      palette-cyan = "base0C";
      palette-light-cyan = "base15";
      palette-blue = "base0D";
      palette-light-blue = "base16";
      palette-magenta = "base0E";
      palette-light-magenta = "base17";
    };
  };

  fonts.packages = lib.mkIf config.services.kmscon.enable [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
