{ config, lib, ... }:

let
  inherit (lib) mkIf;

in
{
  programs.signal-desktop.autostart = true;

  programs.plasma.window-rules = mkIf config.programs.signal-desktop.enable [
    {
      description = "Signal";
      match.window-class.value = "signal Signal";
      apply = {
        maximizehoriz = false;
        maximizevert = false;
        placement.apply = "force";
        placement.value = 5;
        size.value = "780,556";
      };
    }
  ];
}
